from async_request_manager import RequestManager
import asyncio
import json
import filter_options


async def main():
    rm = RequestManager()
    await rm.start()

    request_url = 'http://64.110.79.49:8080/v1/graphql'
    headers = {'x-hasura-admin-secret': filter_options.hasura_admin_secret,
               'Content-Type': 'application/json'}
    mutation = '''
    mutation MyMutation($item_seq: Int!, $class_name: String!) {
  update_pb_pill_info_by_pk(pk_columns: {item_seq: $item_seq}, _set: {class_name: $class_name}) {
    item_seq
    class_name
  }
}
    '''

    drug_product_type_file = open('drug_product_type.json', 'r', encoding='UTF-8')
    drug_product_type: dict[str, str] = json.load(drug_product_type_file)

    for key, value in drug_product_type.items():
        await rm.create_request(request_url, headers=headers, params={
            'query': mutation,
            'variables': {
                'item_seq': key,
                'class_name': value
            }
        }, is_post=True)
    retry_count = 0
    while retry_count < 10:
        url, _, _, response_json = await rm.get_response()
        if url is None:
            retry_count += 1
            continue
        retry_count = 0
        if 'data' in response_json:
            row = response_json['data']['update_pb_pill_info_by_pk']
            if row is not None:
                print(row['item_seq'], row['class_name'])

    await rm.stop()
            

if __name__ == '__main__':
    asyncio.run(main())