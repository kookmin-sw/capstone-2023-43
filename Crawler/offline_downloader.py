# 각종 JSON을 파일로 저장해줌

import asyncio
import filter_options
from async_request_manager import RequestManager
import json
import os

async def dump_json(path, file_number, data):
    with open(f'{path}/{file_number}.json', 'w') as file:
        json.dump(data, file)
    return file_number + 1

async def download_all(request_manager, url, pages, path):
    if not os.path.exists(path):
        os.mkdir(path)
        print(f'create directory {path}')
    for page in range(1, pages+1):
        await request_manager.create_request(
            url,
            params={
                'serviceKey': filter_options.token,
                'numOfRows': 100,
                'type': 'json',
                'pageNo': page
            })
    
    file_number=1
    retry_count=0
    while retry_count < 3:
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            retry_count += 1
            continue
        file_number = await dump_json(path, file_number, response_json)
        print(f'{file_number} / {pages}', end='\r')
    
async def main():
    request_manager = RequestManager()
    await request_manager.start()
    
    # 의약품 제품 허가정보
    # print('의약품 제품 허가정보')
    # await download_all(request_manager, 'http://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService03/getDrugPrdtPrmsnDtlInq02', 512, 'openapi/drg_prdt_permission/')

    # DUR 품목정보
    # print('DUR 품목정보')
    # await download_all(request_manager, 'http://apis.data.go.kr/1471000/DURPrdlstInfoService02/getDurPrdlstInfoList2', 276, 'openapi/dur_prdt_info')
    
    # DUR 병용금기
    # print('DUR 병용금기')
    # await download_all(request_manager, 'http://apis.data.go.kr/1471000/DURPrdlstInfoService02/getUsjntTabooInfoList02',4569, 'openapi/dur_mix_taboo')
    
    # 의약품 낱알식별정보
    # print('의약품 낱알 식별정보')
    # await download_all(request_manager, 'http://apis.data.go.kr/1471000/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01', 251, 'openapi/medicine_info')
    
    await request_manager.stop()

if __name__ == '__main__':
    asyncio.run(main())