from async_request_manager import RequestManager
import asyncio
import json
import filter_options

def divide_chunks(l, n):
    # looping till length l
    for i in range(0, len(l), n):
        yield l[i:i + n]

async def main():
    request_manager = RequestManager(3)
    await request_manager.start()

    request_url = "http://64.110.79.49:8080/v1/graphql"
    headers = {"x-hasura-admin-secret":filter_options.hasura_admin_secret,
               "Content-Type":"application/json"}
    mutation = """
    mutation InsertPillInfo($objects: [pb_pill_info_insert_input!] = {}) {
        insert_pb_pill_info(objects: $objects, on_conflict: {constraint: pb_pill_info_pkey, update_columns: []}) {
            affected_rows
        }
    }
    """
    async def send_request():
        for file_number in range(206):
            while request_manager.request_queue.qsize() > 30:
                await asyncio.sleep(1)
            with open(f"drg_prdt_permission/{file_number}.json", 'r') as file:
                drg_prdt_perm = json.load(file)
            await request_manager.create_request(request_url, headers=headers, params={
                "query": mutation,
                "variables": {
                    "objects": drg_prdt_perm
                }
            }, is_post=True)
    send_request_task = asyncio.create_task(send_request())
    
    retry_count = 0
    while retry_count < 10:
        url, param, header, response_json = await request_manager.get_response()
        if url is None:
            retry_count += 1
            continue
        retry_count=0
        if 'data' in response_json:
            print(response_json['data']['insert_pb_pill_info']['affected_rows'])
    
    await send_request_task

    await request_manager.stop()
    pass

if __name__ == "__main__":
    asyncio.run(main())