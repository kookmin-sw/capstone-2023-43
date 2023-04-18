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
    mutation MyMutation($item_seq: Int!, $taboo_case: Int!, $image_url: String!, $class_name: String!) {
  update_pb_pill_info_by_pk(pk_columns: {item_seq: $item_seq}, _set: {taboo_case: $taboo_case, image_url: $image_url, class_name: $class_name}) {
    item_seq
    taboo_case
    image_url
    class_name
  }
}
    '''

    dur_type_file = open('dur_type.json', 'r', encoding='UTF-8')
    drug_image_file = open('drug_image.json', 'r', encoding='UTF-8')
    drug_class_file = open('drug_class.json', 'r', encoding='UTF-8')

    dur_types: dict[str, int] = json.load(dur_type_file)['data']
    drug_images: dict[str, str] = json.load(drug_image_file)['data']
    drug_class: dict[str, str] = json.load(drug_class_file)

    merged: dict[str, dict] = {}
    for key in dur_types.keys():
        merged[key] = {'taboo_case': dur_types[key], 'class_name': drug_class[key], 'image_url': ''}

    for key in drug_images.keys():
        if key in merged.keys():
            merged[key]['image_url'] = drug_images[key]
        else:
            merged[key] = {'taboo_case': 0, 'class_name': '', 'image_url': drug_images[key]}

    dur_type_file.close()
    drug_image_file.close()
    drug_class_file.close()

    for key, value in merged.items():
        await rm.create_request(request_url, headers=headers, params={
            'query': mutation,
            'variables': {
                'item_seq': key,
                'taboo_case': value['taboo_case'],
                'image_url': value['image_url'],
                'class_name': value['class_name']
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
                print(row['item_seq'], row['taboo_case'], row['image_url'])

    await rm.stop()
            

if __name__ == '__main__':
    asyncio.run(main())