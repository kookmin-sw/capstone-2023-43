import asyncio
from async_request_manager import RequestManager
import filter_options
import json

async def main():

    request_manager = RequestManager(50)
    request_url = filter_options.base_url + "/DURPrdlstInfoService02/getUsjntTabooInfoList02"

    await request_manager.start()

    for page in range(1, 465871//filter_options.NUM_OF_ROWS + 1):
        await request_manager.create_request(
            request_url,
            {"serviceKey":filter_options.token, "pageNo": page, "numOfRows": filter_options.NUM_OF_ROWS, "type": "json"}
        )
    
    retry = 0
    dur_data = list()
    while retry < 3:
        url, _, _, response_json = await request_manager.get_response()
        if url is None:
            retry += 1
            continue
        # filter chart
        for item in response_json['body']['items']:
            for chart_filter in filter_options.full_charts:
                if chart_filter in item['CHART'] and chart_filter in item['MIXTURE_CHART']: # 둘다 필터에 맞으면
                    dur_data.append({"item_seq": item['ITEM_SEQ'], "mixture_item_seq": item['MIXTURE_ITEM_SEQ'], "prohibited_content": item['PROHBT_CONTENT']})
                    print(f"{item['ITEM_SEQ']} {item['ITEM_NAME']} {item['MIXTURE_ITEM_SEQ']} {item['MIXTURE_ITEM_NAME']}")
                    break
    await request_manager.stop()
    
    with open("dur_output.json", "w") as file:
        json.dump({"data": dur_data}, file)

if __name__ == "__main__":
    asyncio.run(main())