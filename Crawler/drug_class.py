# 의약품 CLASS_NAME 혹은 CLASS_NO를 파싱하는 코드
# DUR 허가정보 / 낱알식별정보 / DUR 병용금기
# 위 3API에서는 해당 정보를 주는것을 확인

import asyncio
from async_request_manager import RequestManager
import filter_options
import json

async def main():
    request_manager = RequestManager()
    await request_manager.start()

    # DUR 허가정보를 사용해보기로 함
    request_url = filter_options.base_url + "/DURPrdlstInfoService02/getDurPrdlstInfoList2"
    # DUR 허가정보는 총 27545건
    for page in range(1, 27545//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(request_url, 
                                             {'serviceKey': filter_options.token,
                                              'type': 'json',
                                              'numOfRows': filter_options.NUM_OF_ROWS,
                                              'pageNo': page})
    # 응답 처리
    response_none_count = 0
    item_class: dict[str, str] = dict()
    while response_none_count < 5: # 무응답 5번까지 시도해봄
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            response_none_count += 1
            continue
        for item in response_json['body']['items']:
            print(f"{item['ITEM_SEQ']} {item['ITEM_NAME']} {item['CLASS_NO']}")
            item_class[item['ITEM_SEQ']] = item['CLASS_NO']
    with open('drug_class.json', 'w') as file:
        json.dump(item_class, file)

    await request_manager.stop()

if __name__ == '__main__':
    asyncio.run(main())