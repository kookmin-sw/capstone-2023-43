import asyncio
from asyncio import Semaphore
import aiohttp
import filter_options
import json

async def main():
    sem = Semaphore(32)
    dur_data = list()
    request_url = filter_options.base_url + "/DURPrdlstInfoService02/getUsjntTabooInfoList02"
    session = aiohttp.ClientSession()
    result = await asyncio.gather(*[request(session, request_url, {"serviceKey":filter_options.token, "pageNo": page, "numOfRows": filter_options.NUM_OF_ROWS, "type": "json"}, sem) for page in range(1, 465871//filter_options.NUM_OF_ROWS + 1)])
    await session.close()
    for response in result:
        for item in response['body']['items']:
            dur_data.append({"item_seq": item['ITEM_SEQ'], "mixture_item_seq": item['MIXTURE_ITEM_SEQ'], "prohibited_content": item['PROHBT_CONTENT']})
        print(f"page: {response['body']['pageNo']}. processed: {len(response['body']['items'])}. total: {len(dur_data)}")
    # ret = await request(session, request_url, {"serviceKey":filter_options.token, "pageNo": 1, "numOfRows": filter_options.NUM_OF_ROWS, "type": "json"}, sem)
    # for item in ret['body']['items']:
    #     print(item['DUR_SEQ'], item['ITEM_SEQ'], item['MIXTURE_ITEM_SEQ'], item['PROHBT_CONTENT'])
    with open("dur_output.json", "w") as file:
        json.dump({"data": dur_data}, file)

async def request(session: aiohttp.ClientSession, request_url: str, options: dict, sem: Semaphore):
    await sem.acquire()
    response = await session.get(request_url, params=options)
    json_response = await response.json()
    sem.release()
    print(f"page: {options['pageNo']}")
    return json_response

if __name__ == "__main__":
    asyncio.run(main())