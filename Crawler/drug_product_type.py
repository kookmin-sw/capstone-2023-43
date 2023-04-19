'''
    식품의약품안전처_의약품 제품 허가정보에서 product_type만 가져오는 스크립트
    drug_product_type.json로 결과물이 나온다.
    아래와 같이 나온다.
    {"item_seq":"product_type", ... }
'''
import asyncio
from async_request_manager import RequestManager
import filter_options
import json

TOTAL_COUNT = 50676


def filter_pill(item: dict[str, str]):
    '''
        INDUTY(업종)가 의약품이고, 수출용이 아닌 약을 걸러낸다.
    '''
    if item['INDUTY'] == '의약품' and '수출용' not in item['ITEM_NAME'] and item['PRDUCT_TYPE'] != None:
        return True
    return False


async def main():
    request_manager = RequestManager()
    await request_manager.start()

    request_url = filter_options.base_url + '/DrugPrdtPrmsnInfoService04/getDrugPrdtPrmsnInq04'
    for page in range(1, TOTAL_COUNT//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(request_url, 
                                             {'serviceKey': filter_options.token,
                                              'type': 'json',
                                              'numOfRows': filter_options.NUM_OF_ROWS,
                                              'pageNo': page})
    # 응답 처리
    response_none_count = 0
    product_types: dict[str, str] = dict()
    while response_none_count < 5:  # 무응답 5번까지 시도해봄
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            response_none_count += 1
            continue
        for item in response_json['body']['items']:
            if filter_pill(item):
                pos = item['PRDUCT_TYPE'].find(']')
                product_type = item['PRDUCT_TYPE'][pos+1:]
                product_types[item['ITEM_SEQ']] = product_type
                print(f'{item["ITEM_SEQ"]} -> {item["ITEM_NAME"]} {product_type}')

    with open('drug_product_type.json', 'w', encoding='UTF-8') as file:
        json.dump(product_types, file)

    await request_manager.stop()

if __name__ == '__main__':
    asyncio.run(main())
