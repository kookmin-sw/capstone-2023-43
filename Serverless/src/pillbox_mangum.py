import os
import json
import aiohttp
from datetime import datetime
from typing import Union, List
from pydantic import BaseModel
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.exceptions import HTTPException as StarletteHttpException
from mangum import Mangum
from pymongo import MongoClient
from bson import ObjectId, json_util


class PillHistory(BaseModel):
    name: Union[str, None] = None
    pills: Union[List[int], None] = None
    start_date: Union[datetime, None] = None
    end_date: Union[datetime, None] = None


class User(BaseModel):
    blood_pressure: Union[int, None] = None
    is_diabetes: Union[bool, None] = False
    is_pregnancy: Union[bool, None] = False
    pill_histories: Union[List[PillHistory], None] = None


host = os.environ.get('MONGODB_HOST')
username = os.environ.get('MONGODB_USERNAME')
password = os.environ.get('MONGODB_PASSWORD')
authSource = os.environ.get('MONGODB_AUTHSOURCE')

client = MongoClient(host, username=username, port=27017, password=password, authSource=authSource)
pillbox_db = client['pillbox']['pillbox']

app = FastAPI()

def get_user_id(scope):
    try:
        user_id = scope['aws.event']['requestContext']['authorizer']['claims']['sub']
    except KeyError:
        user_id = None
    return user_id

def is_exist(user_id: str):
    result = pillbox_db.find_one({"_id": user_id})
    return True if len(result) else False


@app.exception_handler(StarletteHttpException)
def error_handler(request: Request, _):
    print(request.url)
    return JSONResponse(
        status_code=404,
        content={"error": "not found"}
    )

@app.get('/pillbox/users')
def get_user(request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        return {"result": "Unauthoriazation"}
    user_doc = pillbox_db.find_one({"_id": user_id})
    user_doc = json.loads(json_util.dumps(user_doc))
    return {"result": "ok", "datas": user_doc}

@app.post('/pillbox/users')
def post_user(user: User, request: Request):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthoriazation"}

    if is_exist(user_id):
        return {"result": "already exists"}

    user_doc = {'_id': user_id, 'blood_pressure': user.blood_pressure,
                'is_pregnancy': user.is_pregnancy, 'is_diabetes': user.is_diabetes}
    pillbox_db.insert_one(user_doc)
    return {"result": "ok"}

@app.patch('/pillbox/users')
def put_user(user: User, request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        return {"result": "Unauthoriazation"}
    if not is_exist(user_id):
        return {"result": "not exist User"}

    # todo if not updated?
    result = pillbox_db.update_one({"_id": user_id}, {"$set": user.__dict__})

    if result.matched_count < 0:
        return {"result": "not updated"}
    else:
        return {"result": "ok"}

@app.get('/pillbox/users/pill_histories')
def get_pill_histories(request: Request, name: str = None, all_histories: bool = False,
                       only_ended_histories: bool = False):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthoriazation"}

    if not is_exist(user_id):
        return {"result": "No User Data"}

    if all_histories and only_ended_histories:
        return {"result": "choose one parameter from all_histories and only_ended_histories"}

    match = {"$match": {}}
    if name is not None:
        match["$match"]["pill_histories.name"] = name
    if not all_histories:
        match["$match"]["pill_histories.end_date"] = {"$gte": datetime.utcnow()}
    elif only_ended_histories:
        match["$match"]["pill_histories.end_date"] = {"$lt": datetime.utcnow()}

    group = {"$group": {"_id": "$_id", "datas": {"$addToSet": "$pill_histories"}}}

    results_out = pillbox_db.aggregate([{"$match": {"_id": user_id}},
                                        {"$unwind": "$pill_histories"},
                                        match,
                                        group,
                                        {"$project": {"_id": 0}}
                                        ])
    results = json.loads(json_util.dumps(results_out))
    results = results[0]['datas'] if len(results) > 0 else []
    return {"result": "ok", "datas": results}

@app.get('/pillbox/users/pill_histories/{history_id}')
def get_pill_history_by_id(request: Request, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}
    
    history_id = ObjectId(history_id)

    result_out = pillbox_db.find_one({"_id": user_id, 
                                      "pill_histories._id": history_id})
    if len(result_out) < 0:
        return {"result": f"there is no data with {history_id}"}

    results = json.loads(json_util.dumps(result_out))
    result = [result for result in results['pill_histories'] if result['_id']['$oid'] == str(history_id)][0]

    return {"result": "ok", "datas": result}

# 검증 및 request body 확인 코드 필요
@app.post('/pillbox/users/pill_histories')
def post_pill_history(request: Request, pill_history: PillHistory):
    user_id = get_user_id(request.scope)

    print(pill_history)

    if user_id is None:
        return {"result": "Unauthorization"}

    # 복용기록의 이름이 공백이거나 전달이 안된 경우
    pill_history.name = pill_history.name.strip()
    if pill_history.name is None or len(pill_history.name) < 0:
        return {"result": "Need history name"}
    
    if pill_history.end_date is None or pill_history.start_date is None:
        return {"result": "Need start_date or end_date"}
    
    if pill_history.end_date <= pill_history.start_date:
        return {"result": "start_date less then end_date"}

    if pill_history.pills is None or len(pill_history.pills) < 0:
        return {"result": "Need pill list"}

    # 이름이 같은 복용기록을 처리하기 위한 과정
    duplicated_history = pillbox_db.find_one({"_id": user_id, "pill_histories.name": pill_history.name})
    if duplicated_history is not None:
        return {"result": "pill history already exists"}

    pill_history_dict = pill_history.__dict__
    pill_history_dict["_id"] = ObjectId()

    pillbox_db.update_one({"_id": user_id}, {"$push": {"pill_histories": pill_history_dict}})

    return {"result": "ok"}

# 검증 및 request body 확인 코드 필요
@app.patch('/pillbox/users/pill_histories/{history_id}')
def update_pill_history_by_id(request: Request, pill_history: PillHistory, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}
    history_id = ObjectId(history_id)

    # 들어온 날짜가 유요하지 않으면 에러 반환
    if pill_history.end_date is not None and pill_history.start_date is not None:
        # pill_history.end_date가 pill_history보다 크면 유요하다.
        if pill_history.end_date <= pill_history.start_date:
            return {"result": "start_date must be less then end_date"}

    elif pill_history.start_date is not None:
        # pill_histories.start_date가 end_date on documents 보다 크면 유효하다.
        result = pillbox_db.find_one({"_id": user_id, "pill_histories._id": history_id,
                                      "pill_histories.end_date": {"$lt": pill_history.start_date}})
        if result is None:
            return {"result": "start_date must be less then end_date"}

    elif pill_history.end_date is not None:
        # pill_histories.end_date가 start_date on document보다 크면 유효하다.
        result = pillbox_db.find_one({"_id": user_id, "pill_histories._id": history_id,
                                      "pill_histories.start_date": {"$gt": pill_history.end_date}})
        if result is None:
            return {"result": "end_date must be greater than start_date"}

    if pill_history.pills is not None and len(pill_history.pills) < 0:
        return {"result": "Need pill list"}

    update_query = pill_history.__dict__
    update_query = {"pill_histories.$."+k: v for k, v in update_query.items() if v is not None}

    result = pillbox_db.update_one({"_id": user_id, "pill_histories._id": history_id}, {"$set": update_query})
    if result.modified_count == 0:
        return {"result": "not updated"}

    return {"result": "ok"}

@app.delete('/pillbox/users/pill_histories/{history_id}')
def delete_pill_history_by_id(request: Request, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}

    history_id = ObjectId(history_id)

    history = pillbox_db.find_one({"_id": user_id, "pill_histories._id": history_id})

    if len(history) < 0:
        return {"result": "There is no data"}

    pillbox_db.update_one({"_id": user_id}, {"$pull": {"pill_histories": {"_id": history_id}}})

    return {"result": "ok"}

@app.get('/pillbox/pills/{item_seq}', response_class=HTMLResponse)
async def get_pill_data(item_seq: str = ""):
    html_404 = """
<html>
    <body>
        알맞은 item_seq가 아닙니다.
    </body>
</html>
    """
    html = """
<html>
    <body>
        <h1>{name}</h1>
        <p>효능</p>
        {effect}
        <p>사용법</p>
        {use_method}
        <p>주의사항</p>
        {warning_message}
    </body>
</html>
    """
    query = """
query MyQuery($item_seq: Int!) {
  pb_pill_info(where: {item_seq: {_eq: $item_seq}}) {
    name
    use_method
    warning_message
    effect
  }
}
    """
    variable = {"item_seq": item_seq}
    hasura_endpoint = os.environ.get('HASURA_ENDPOINT_URL')
    if len(item_seq) != 9:
        return HTMLResponse(content=html_404, status_code=404)

    # python 3.8이라 문제가 생기는 듯
    async with aiohttp.ClientSession() as session:
        async with session.post(hasura_endpoint, data={"query": query, "variables": variable}) as response:
            if response.start != 200:
                return HTMLResponse("""dddd""")
            body = await response.json()
            if "error" in body.items():
                return HTMLResponse("""error""")
            body = body["data"]["pb_pill_info"][0]
            html = html.format(body['name'], body['effect'], body['use_method'], body['warning_message'])
    return HTMLResponse(html)


handler = Mangum(app)
