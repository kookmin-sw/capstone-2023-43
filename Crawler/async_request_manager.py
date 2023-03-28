# 비동기 request 핸들링 매니저입니다.
import asyncio
import aiohttp

class RequestManager:
    def __init__(self, max_concurrent_task: int = 16) -> None:
        """비동기 Request를 보내고 결과를 반환하는 똑똑한 매니저

        세마포어 사용하는 방식보다 메모리 최적화가 좋음
        
        불필요한 task를 생성하지 않기 때문, 물론 handler가 상주하고 있어서 낭비가 조금 있긴함

        Args:
            max_concurrent_task (int, optional): 동시에 최대로 보낼 request 수. Defaults to 16.
        """
        self.request_queue: asyncio.Queue[tuple[str, dict[str, str], dict[str,str], bool]] = asyncio.Queue()
        self.request_semaphore = asyncio.Semaphore(max_concurrent_task)
        self.response_queue: asyncio.Queue[tuple[str, dict[str,str],dict[str,str],dict[str,str]]] = asyncio.Queue()
        self.session = aiohttp.ClientSession()
        self._max_concurrent_task = max_concurrent_task
        self._tasks = []
    
    async def start(self):
        """요청 매니저 실행

        이 함수를 호출하기 전까지는 request가 수행되지 않음
        """
        self._tasks = [asyncio.create_task(self._request_handler(f"Handler_{x}")) for x in range(self._max_concurrent_task)]

    async def _request_handler(self, handler_name):
        print(f"RequestManager Handler: {handler_name} Started.")
        while True:
            try:
                request_url, params, headers, is_post = await self.request_queue.get()
                if request_url is None:
                    break
                if is_post:
                    response = await self.session.post(request_url, json=params, headers=headers)
                else:
                    response = await self.session.get(request_url, params=params, headers=headers)
                if response.status != 200:
                    print(f"Request failed. Ignore Response.") #\n{request_url}\n{params}\n{headers}")
                    continue
                json_response = await response.json()
                await self.response_queue.put((request_url, params, headers, json_response))
                print(f"RequestManager Handler: {handler_name}: {response.url.human_repr()}")
            except Exception as e:
                print(f"RequestManager Handler: {handler_name}: {e}")
        print(f"RequestManager Handler: {handler_name} Finished.")


    async def create_request(self, request_url:str, params:dict[str,str]={}, headers:dict[str,str]={}, is_post = False):
        """요청 큐에 넣기

        Args:
            request_url (str): 요청 주소
            params (dict[str,str], optional): GET파라미터 혹은 POST JSON바디. Defaults to {}.
            headers (dict[str,str], optional): 헤더. Defaults to {}.
            is_post (bool, optional): POST면 True
        """
        await self.request_queue.put((request_url, params, headers, is_post))

    async def get_response(self) -> tuple[str, dict[str, str], dict[str, str], dict[str,str]]:
        """응답 하나 가져오기

        최대 3초간 응답을 기다립니다. 없으면 None을 반환합니다.

        Returns:
            (request_url, params, headers, response_json) 형태의 tuple을 반환합니다.
        """
        try:
            response = await asyncio.wait_for(self.response_queue.get(), timeout=3)
            return response
        except asyncio.TimeoutError:
            return (None, None, None, None)

    async def stop(self):
        """요청 매니저 종료

        사용 종료시 반드시 호출하세요
        """
        for _ in range(self._max_concurrent_task):
            await self.request_queue.put((None, None, None))
        done, pending = await asyncio.wait(self._tasks, return_when=asyncio.ALL_COMPLETED)
        for t in done:
            await t
        if len(pending) != 0:
            print("RequestMnager: WARNING: handler task still running. maybe it is bugs.")
        await self.session.close()