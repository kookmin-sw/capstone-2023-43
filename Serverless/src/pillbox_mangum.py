import os
from pytz import UTC
import json
from datetime import datetime, timedelta
import aiohttp
import asyncio
from pydantic import BaseModel
from pydantic.error_wrappers import ValidationError
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from starlette.requests import Request
from mangum import Mangum
from pymongo import MongoClient
from pymongo import errors
from bson import ObjectId, json_util
from bson.errors import InvalidId


# graphql query define section
MIX_TABOO_QUERY = '''query validation($item_seqs: [Int]!, $mixture_item_seq: Int!) {
  pb_mix_taboo(where: {_and: [{item_seq: {_in: $item_seqs}}, {mixture_item_seq: {_eq: $mixture_item_seq}}]}) {
    item_seq
    mixture_item_seq
    prohibited_content
  }
}'''


TABOO_CASE_QUERY = '''query taboo_list($item_seq: Int!) {
    pb_pill_info_by_pk(item_seq: $item_seq)
}
'''


# Model define section
class PillHistoryOut(BaseModel):
    id: str
    name: str
    pills: list[int]
    start_date: datetime
    end_date: datetime

    @staticmethod
    def from_dict(json_dict: dict[str, any]):
        '''
            inputs data from bson to json dict
        '''
        id_ = json_dict['_id']['$oid']
        name = json_dict['name']
        pills = json_dict['pills']
        start_date = json_dict['stat_date']['$date']
        end_date = json_dict['end_date']['$date']
        return PillHistoryOut(id=id_, name=name, pills=pills, start_date=start_date, end_date=end_date)


class PillHistoryPatch(BaseModel):
    name: str | None = None
    pills: list[int] | None = None
    start_date: datetime | None = None
    end_date: datetime | None = None


class PillHistoryPost(BaseModel):
    name: str
    pills: list[int]
    start_date: datetime
    end_date: datetime


class UserOut(BaseModel):
    id: str
    blood_pressure: int
    is_diabetes: bool
    is_pregnancy: bool
    pill_histories: list[PillHistoryOut]

    @staticmethod
    def from_dict(json_dict: dict[str, any]):
        id_ = json_dict['id']
        blood_pressure = json_dict['blood_pressure']
        is_diabetes = json_dict['is_diabetes']
        is_pregnancy = json_dict['is_pregnancy']
        pill_histories = [PillHistoryOut(pill_history) for pill_history in json_dict['pill_histories']]
        return UserOut(id=id_, blood_pressure=blood_pressure, is_diabetes=is_diabetes,
                       is_pregnancy=is_pregnancy, pill_histories=pill_histories)


class UserPost(BaseModel):
    blood_pressure: int = None
    is_diabetes: bool = False
    is_pregnancy: bool = False


class UserPatch(BaseModel):
    blood_pressure: int | None = None
    is_diabetes: bool | None = False
    is_pregnancy: bool | None = False


class Validation(BaseModel):
    pills: list[int]
    start_date: datetime = datetime.utcnow()
    end_date: datetime = datetime.utcnow() + timedelta(days=10)


class Result(BaseModel):
    result: str
    data: str | UserOut | list[PillHistoryOut] | PillHistoryOut


# mongodb Connection section

host = os.environ.get('MONGODB_HOST')
username = os.environ.get('MONGODB_USERNAME')
password = os.environ.get('MONGODB_PASSWORD')
authSource = os.environ.get('MONGODB_AUTHSOURCE')

client = MongoClient(host, username=username, port=27017, password=password, authSource=authSource)
pillbox_db = client['pillbox']['pillbox']


# asgi section
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


@app.get('/pillbox/users', response_model=Result)
def get_user(request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        raise HTTPException(status_code=401)
    user_doc = pillbox_db.find_one({"_id": user_id})
    if user_doc is None:
        raise HTTPException(status_code=404, detail="user not found")
    user_doc = json.loads(json_util.dumps(user_doc))
    try:
        user = UserOut(user_doc)
    except KeyError as key_error:
        raise HTTPException(status_code=500, detail="internal error key error") from key_error
    except ValidationError as valid:
        print(valid)
        raise HTTPException(status_code=500, detail="internal error") from valid

    return Result(result="ok", data=user)


@app.post('/pillbox/users', status_code=201)
def post_user(user: UserPost, request: Request):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(status_code=401, detail="Unauthoized")

    if is_exist(user_id):
        raise HTTPException(status_code=400, detail="already exist")

    user_doc = {'_id': user_id, 'blood_pressure': user.blood_pressure,
                'is_pregnancy': user.is_pregnancy, 'is_diabetes': user.is_diabetes}
    pillbox_db.insert_one(user_doc)
    return Result(result="ok")


@app.patch('/pillbox/users')
def put_user(user: UserPatch, request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        raise HTTPException(status_code=401)
    if not is_exist(user_id):
        raise HTTPException(status_code=400, detail="not exist")

    pillbox_db.update_one({"_id": user_id}, {"$set": user.__dict__})

    return Result(result="ok")


@app.post('/pillbox/users/validation')
def validation(request: Request, valid: Validation):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}

    if not is_exist(user_id):
        return {"result": "No User Data"}

    if validation.end_date <= validation.start_date:
        return {"result": "start_date must be less than end_date"}

    # 요청의 복용기간내에 존재하는 복용기록의 의약품들의 품목기준코드를 가져오는 aggregate pipeline
    pipeline: list[dict[str, any]] = [{"$match": {"_id": user_id}}]
    pipeline.append({"$unwind": "$pill_histories"})
    pipeline.append({"$unwind": "$pill_histories.pills"})
    pipeline.append({"$match": {"pill_histories.end_date": {"$gte": valid.start_date},
                                "pill_histories.start_date": {"$lte": valid.end_date}}})
    pipeline.append({"$group": {"_id": "$_id", "pills": {"$push": "$pill_histories.pills"}}})

    result_out = pillbox_db.aggregate(pipeline=pipeline)

    pills = [result for result in result_out]
    print(pills)

    if len(pills) > 0:
        pills = pills[0]
    else:
        return {"result": "ok"}

    if 'pills' not in pills.keys() or len(pills['pills']) == 0:
        return {"result": "ok"}
    pills = pills['pills']
    return {"result": "ok", "datas": pills}


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
    # todo 반환 코드를 다시 짜야할 듯
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
@app.post('/pillbox/users/pill_histories', status_code=201)
def post_pill_history(request: Request, pill_history: PillHistoryPost):
    user_id = get_user_id(request.scope)

    print(pill_history)

    if user_id is None:
        return {"result": "Unauthorization"}

    # 복용기록의 이름이 공백이거나 전달이 안된 경우
    pill_history.name = pill_history.name.strip()
    if pill_history.name is None or len(pill_history.name) < 0:
        return {"result": "Need history name"}

    if pill_history.end_date is None or pill_history.start_date is None:
        return {"result": "Need start_date and end_date"}

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

    return {"result": "ok", "id": str(pill_history_dict["_id"])}


# 검증 및 request body 확인 코드 필요
@app.patch('/pillbox/users/pill_histories/{history_id}')
def update_pill_history_by_id(request: Request, pill_history: PillHistoryPatch, history_id: str):
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
        result = pillbox_db.find_one({"_id": user_id, "pill_histories":
                                      {"$elemMatch":
                                       {"_id": history_id, "end_date": {"$gt": pill_history.start_date}}}})
        if result is None:
            return {"result": "start_date must be less then end_date"}

    elif pill_history.end_date is not None:
        # pill_histories.end_date가 start_date on document보다 크면 유효하다.
        result = pillbox_db.find_one({"_id": user_id, "pill_histories":
                                      {"$elemMatch":
                                       {"_id": history_id, "start_date": {"$lt": pill_history.end_date}}}})
        if result is None:
            return {"result": "end_date must be greater than start_date"}

    if pill_history.pills is not None and len(pill_history.pills) < 0:
        return {"result": "Need pill list"}

    if pill_history.name is not None:
        # history_id는 다른데 이름은 같은 기록을 찾는다.
        result = pillbox_db.find_one({"_id": user_id, "pill_histories":
                                      {"$elemMatch": {"_id": {"$ne": history_id}, "name": pill_history.name}}})
        if result is not None:
            return {"result": "history name already exist"}

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
async def get_pill_data(item_seq: int = 0):
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
    query = """query pill($item_seq: Int!) {
    pb_pill_info(where: {item_seq: {_eq: $item_seq}}) {
        name
        use_method
        warning_message
        effect
}}"""
    variable = {"item_seq": item_seq}
    hasura_endpoint = os.environ.get('HASURA_ENDPOINT_URL')
    if len(str(item_seq)) != 9:
        return HTMLResponse(content=html_404, status_code=404)

    # python 3.8이라 문제가 생기는 듯
    async with aiohttp.ClientSession() as session:
        async with session.post(hasura_endpoint, json={"query": query, "variables": variable}) as response:
            if response.status != 200:
                return HTMLResponse("""dddd""")
            body = await response.json()
            if "errors" in body.items():
                return HTMLResponse("""error""")
            data = body["data"]["pb_pill_info"][0]
            html = html.format(name=data['name'], effect=data['effect'],
                               use_method=data['use_method'], warning_message=data['warning_message'])
    return HTMLResponse(html)


handler = Mangum(app)
