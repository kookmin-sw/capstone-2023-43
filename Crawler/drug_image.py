'''
    의약품 낱알식별 정보에서 이미지 URL을 가져옵니다.
    출력파일 이름 : drug_image.json
    형태 :
    {"data":[{"item_seq":"imgae url"}]}
'''
import asyncio
import json
from async_request_manager import RequestManager
import filter_options

TOTAL_COUNT = 25208


async def main():
    request_manager = RequestManager()
    await request_manager.start()

    request_url = filter_options.base_url + \
        '/MdcinGrnIdntfcInfoService01/getMdcinGrnIdntfcInfoList01'

    for page in range(1, TOTAL_COUNT//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(request_url, {
            'serviceKey': filter_options.token,
            'type': 'json', 'numOfRows': filter_options.NUM_OF_ROWS,
            'pageNo': page})

    response_none_count = 0
    images: dict[int, str] = {}

    while response_none_count < 5:
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            response_none_count += 1
            continue

        for item in response_json['body']['items']:
            if '수출용' in item['ITEM_NAME']:
                break

            print(f"{item['ITEM_SEQ']} -> {item['ITEM_NAME']} \
{item['ITEM_IMAGE']}")
            images[int(item['ITEM_SEQ'])] = item['ITEM_IMAGE']

    await request_manager.stop()
    with open('drug_image.json', 'w', encoding='UTF-8') as file:
        json.dump({'data': images}, file)

if __name__ == '__main__':
    asyncio.run(main())
