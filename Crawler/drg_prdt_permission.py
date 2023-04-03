'''
    식품의약품안전처_의약품 제품 허가정보 API의 내용을 크롤링하는 스크립트
    drg_prd_permission.json로 결과물이 나온다.
    형태는 {
        "data":[{"item_seq":"", "name":"", "entp_name":"", "etc_otc_code":""},
                  "effect":"", "use_method":"", "warning_message":""]}

    usage:
        python drg_prd_permission.py
'''

import asyncio
import json

from async_request_manager import RequestManager
import filter_options
from doc_parse import doc_to_html


TOTAL_COUNT: int = 51235

KEYS: dict[str, str] = {'ITEM_SEQ': 'item_seq', 'ITEM_NAME': 'name',
                        'ENTP_NAME': 'entp_name',
                        'ETC_OTC_CODE': 'etc_otc_code',
                        'EE_DOC_DATA': 'effect',
                        'UD_DOC_DATA': 'use_method',
                        'NB_DOC_DATA': 'warning_message'
                        }


def drug_filter(item: dict[str, str]) -> bool:
    '''
        아래 조건에 모두 부합할 때 True를 반환한다.
        완제의약품
        허가상태가 정상
        경구투여인 약
        수출용이 아닌 약
    '''

    # 수출용이라고 표기되어 있는 약은 국내에서 구입이 불가능하다.
    if item['MAKE_MATERIAL_FLAG'] == '완제의약품' and \
            item['CANCEL_NAME'] == '정상' and \
            item['ITEM_NAME'].find('(수출용)') == -1:

        for chart in filter_options.full_charts:
            if item['CHART'].find(chart) != -1:
                return True
    return False

def json_dump(data, file_number:int) -> int:
    """json 파일로 저장
    file_number 단위로 분할해서 저장

    Args:
        data (_type_): 저장할 json 데이터
        file_number (int): 파일 번호

    Returns:
        int: 다음 파일 번호
    """
    filename = f"drg_prdt_permission/{file_number}.json"
    with open(filename, 'w') as file:
        json.dump(data, file)
    return file_number + 1

async def main():
    request_manager = RequestManager()
    await request_manager.start()

    result_url = filter_options.base_url + \
        '/DrugPrdtPrmsnInfoService03/getDrugPrdtPrmsnDtlInq02'

    for page in range(1, TOTAL_COUNT//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(result_url, {
            'serviceKey': filter_options.token, 'type': 'json',
            'numOfRows': filter_options.NUM_OF_ROWS, 'pageNo': page
        })

    response_none_count = 0

    results: list = []
    file_number = 0
    while response_none_count < 5:
        url, _, _, response_json = await request_manager.get_response()

        if url is None:
            response_none_count += 1
            continue

        for item in response_json['body']['items']:
            # preprocess
            for k, _ in KEYS.items():
                if item[k] is None:
                    item[k] = ""
                item[k] = item[k].replace('\r\n', ' ') \
                    .replace('\n', ' ').strip()

            # filter
            if drug_filter(item):
                # transform
                print(f"{item['ITEM_SEQ']} -> {item['ITEM_NAME']}")

                result: dict = {}
                for k, v in KEYS.items():
                    result[v] = item[k] if not k.endswith('_DOC_DATA') \
                            else doc_to_html(item[k])
                results.append(result)
        
        if len(results) > 100:
            file_number = json_dump(results, file_number)
            results.clear()

    if len(results) > 0:
        file_number = json_dump(results, file_number)
        results.clear()

    await request_manager.stop()

    # with open('drg_prdt_permission.json', 'w', encoding="UTF-8") as file:
    #     json.dump({'data': results}, file)

if __name__ == '__main__':
    asyncio.run(main())
