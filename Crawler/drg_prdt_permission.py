'''
    식품의약품안전처_의약품 제품 허가정보 API의 내용을 크롤링하는 스크립트
    drg_prd_permission.csv로 결과물이 나온다.
    itemSeq, Name, ENTPNAME, ETCOTCCODE, effect, useMethod, WarningMessage 순으로 나열된다.

    usage: 
        python drg_prd_permission.py
'''

import asyncio
import json
import aiohttp

from filter_options import full_charts, token, base_url

END_POINT : str = base_url + '/DrugPrdtPrmsnInfoService03/getDrugPrdtPrmsnDtlInq02'


TOTAL_COUNT : int = 51,235
NUM_OF_ROWS : int = 100


async def main():
    '''script entry point'''
    async with aiohttp.ClientSession() as session:
        async with session.get(END_POINT,
                               headers = {'Content-type':'text/json'},
                               params=[('serviceKey',token),
                                       ('type', 'json'),
                                       ('numOfRows', NUM_OF_ROWS)]) as response:

            body = await response.text()
            body = json.loads(body)
            for item in body['body']['items']:
                item['CHART'] = item['CHART'].replace('\r\n', '').replace('\n', '')
                for chart in full_charts:
                    if item['CHART'].find(chart) != -1 and item['MAKE_MATERIAL_FLAG'] == '완제의약품' and item['CANCEL_NAME'] == '정상':
                        print(item['ITEM_SEQ'], item['ITEM_NAME'], item['CHART'])
                        #print(item['ITEM_SEQ'], '|', item['ITEM_NAME'], '|', item['ENTP_NAME'],
                        #      '|', item['ETC_OTC_CODE'],'|', item['EE_DOC_DATA'],
                        #      '|' ,item['UD_DOC_DATA'], '|',item['NB_DOC_DATA'], '|' ,item['CHART'])
                        break


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
