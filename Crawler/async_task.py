import asyncio
import random

async def request(page):
    await asyncio.sleep(random.random())
    return page

async def request_sem(page, sem: asyncio.Semaphore):
    await sem.acquire() # wait semaphore
    await asyncio.sleep(random.random())
    # 실제 코드 입력
    sem.release() # release semaphore, 코루틴 아님 await 쓰는거 아님
    return page


async def main():
    # method 1
    ret = await asyncio.gather(*[request(page) for page in range(100)])
    print(ret)


    # method 2
    tasks = []
    for i in range(100):
        t = asyncio.create_task(request(i))
        tasks.append(t)
    done, pending = await asyncio.wait(tasks, return_when=asyncio.ALL_COMPLETED)
    for task in done:
        result = await task
        print(result)

    # method 3
    # limit maximum concurrent requests
    concurrent_count = 5 # maximum 5 concurrent requests
    aio_sem = asyncio.Semaphore(concurrent_count)
    ret = await asyncio.gather(*[request_sem(page, aio_sem) for page in range(100)])
    print(ret)

if __name__ == "__main__":
    asyncio.run(main())