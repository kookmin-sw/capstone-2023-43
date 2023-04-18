'''
    DUR 품목 정보 API 중 DUR 품목조회를 통하여 금기명을 가져옵니다.

    출력파일 이름 : dur_type.json
    형태 :
    {"data" : [{"item_seq":int}]}
'''
import asyncio
import json
from async_request_manager import RequestManager
import filter_options

TOTAL_COUNT: int = 26726

BITMASKS: dict[str, int] = {'A': 0x001, 'B': 0x002,
                            'C': 0x004, 'D': 0x008,
                            'E': 0x010, 'F': 0x020,
                            'G': 0x040, 'H': 0x080,
                            'I': 0x100}


async def main():
    request_manager = RequestManager()
    await request_manager.start()

    # DUR 품목조회
    request_url = filter_options.base_url + \
        '/DURPrdlstInfoService02/getDurPrdlstInfoList2'

    for page in range(1, TOTAL_COUNT//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(request_url, {
            'serviceKey': filter_options.token,
            'type': 'json',
            'numOfRows': filter_options.NUM_OF_ROWS,
            'pageNo': page
        })

    response_none_count = 0
    type_items: list[dict[str, int]] = []

    while response_none_count < 5:
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            response_none_count += 1
            continue
        for item in response_json['body']['items']:

            # 수출용 의약품은 국내에서 구매 불가
            if '수출용' in item['ITEM_NAME']:
                break
            for chart in filter_options.full_charts:
                if chart in item['CHART']:
                    dur_types_raw: str = item['TYPE_CODE']
                    dur_types: list[str] = dur_types_raw.split(',')

                    taboo_case: int = 0
                    for dur_type in dur_types:
                        taboo_case |= BITMASKS[dur_type]

                    print(f"{item['ITEM_SEQ']} : {item['ITEM_NAME'].strip()} \
{item['TYPE_CODE']} {item['CHART']}")

                    type_items.append({item['ITEM_SEQ']: taboo_case})
                    break
    await request_manager.stop()

    with open('dur_type.json', "w", encoding='UTF-8') as file:
        json.dump({'data': type_items}, file)


if __name__ == '__main__':
    asyncio.run(main())
