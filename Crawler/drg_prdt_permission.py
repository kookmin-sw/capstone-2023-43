'''
    식품의약품안전처_의약품 제품 허가정보 API의 내용을 크롤링하는 스크립트
    drg_prd_permission.json로 결과물이 나온다.
    itemSeq, Name, ENTPNAME, ETCOTCCODE, effect, useMethod, WarningMessage
    순으로 나열된다.

    usage:
        python drg_prd_permission.py
'''

import asyncio
from asyncio import Semaphore
import json
import aiohttp

from filter_options import full_charts, token
from filter_options import base_url, NUM_OF_ROWS, TASK_PER_ONCE
from doc_parse import doc_to_html

END_POINT: str = base_url + \
    '/DrugPrdtPrmsnInfoService03/getDrugPrdtPrmsnDtlInq02'


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

        for chart in full_charts:
            if item['CHART'].find(chart) != -1:
                return True
    return False


async def crawler_page(page: int, sem: Semaphore):
    '''
        한페이지를 리퀘스트 하는 크롤러
    '''
    await sem.acquire()

    async with aiohttp.ClientSession() as session:
        async with session.get(END_POINT,
                               headers={'Content-type': 'text/json'},
                               params=[('serviceKey', token),
                                       ('type', 'json'),
                                       ('numOfRows', NUM_OF_ROWS),
                                       ('pageNo', page)]) \
                                        as response:

            body = await response.json()

            results: list = []
            for item in body['body']['items']:
                result: dict = {}

                # preprocess
                for k, _ in KEYS.items():
                    if item[k] is None:
                        item[k] = ""
                    item[k] = item[k].replace('\r\n', ' ') \
                        .replace('\n', ' ')

                # filter
                if drug_filter(item):
                    # transform
                    result: dict = {}
                    for k, v in KEYS.items():
                        result[v] = item[k] if not k.endswith('_DOC_DATA') \
                            else doc_to_html(item[k])
                    results.append(result)

            sem.release()
            return results


async def main():
    '''script entry point'''
    aio_sem: Semaphore = Semaphore(TASK_PER_ONCE)
    ret = await asyncio.gather(*[
        crawler_page(page, aio_sem)
        for page in range(1, min(int(TOTAL_COUNT/NUM_OF_ROWS) + 1, 5)) # 1~4까지만 테스트
    ])
    json_output = json.dumps({"items": [row for rows in ret for row in rows]})
    f = open('drg_prdt_permission_out.json', 'w')
    f.write(json_output)
    f.close()

if __name__ == '__main__':
    asyncio.run(main())
