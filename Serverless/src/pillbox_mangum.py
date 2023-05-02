import os
from fastapi import FastAPI
from starlette.requests import Request
from starlette.responses import JSONResponse
from mangum import Mangum
from starlette.exceptions import HTTPException as StarletteHttpException
from pymongo import MongoClient
from pydantic import BaseModel
from bson import ObjectId
from typing import Union, List
from bson import json_util
import json
from datetime import datetime


class PillHistory(BaseModel):
    pills: Union[List[int], None] = None
    start_date: Union[str, None] = ""
    end_date: Union[str, None] = ""

class User(BaseModel):
    blood_pressure: Union[int, None] = 0
    is_diabetes: Union[bool, None] = False
    is_pregnancy: Union[bool, None] = False
    pill_histories: Union[List[PillHistory], None] = []


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
    return {"result": "ok", "datas": [user_doc]}

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

@app.put('/pillbox/users')
def put_user(user: User, request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        return {"result": "Unauthoriazation"}
    if not is_exist(user_id):
        return {"result": "not exist User"}

    result = pillbox_db.update_one({"_id": user_id}, {"$set": user.__dict__})

    return {"result": "ok"}

@app.get('/pillbox/users/pill_histories')
def get_pill_histories(request: Request, name: str = None, all_histories: bool = False, only_ended_histories: bool = False):
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
    if not all_histories and not only_ended_histories:
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
def get_pill_histories_by_id(request: Request, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}

    result_out = pillbox_db.find_one({"_id": user_id, 
                                      "pill_histories._id": ObjectId(history_id)})

    results = json.loads(json_util.dumps(result_out))
    result = [result for result in results['pill_histories'] if result['_id']['$oid'] == history_id][0]

    return {"result": "ok", "datas": result}

@app.post('/pillbox/users/pill_histories')
def post_pill_histories(request: Request, pill_history: PillHistory):
    pass

@app.put('/pillbox/users/pill_histories/{history_id}')
def update_pill_histories_by_id(request: Request, pill_history: PillHistory, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        return {"result": "Unauthorization"}
    
    if not is_exist(user_id):
        return {"result": "No User Data"}



handler = Mangum(app)
