import os
from fastapi import FastAPI
from starlette.requests import Request
from starlette.responses import JSONResponse
from mangum import Mangum
from starlette.exceptions import HTTPException as StarletteHttpException
from pymongo import MongoClient
from pydantic import BaseModel
from typing import Union, List
from bson import json_util
import json
import time


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
    return scope['aws.event']['requestContext']['authorizer']['claims']['sub']

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
    print(request.headers)
    print(request.scope['aws.event'])
    user_id = get_user_id(request.scope)
    user_doc = pillbox_db.find_one({"_id": user_id})
    return {"result": "ok", "datas": [user_doc]}

@app.post('/pillbox/users')
def post_user(user: User, request: Request):
    user_id = get_user_id(request.scope)
    if is_exist(user_id):
        return {"result": "already exists"}

    user_doc = {'_id': user_id, 'blood_pressure': user.blood_pressure,
                'is_pregnancy': user.is_pregnancy, 'is_diabetes': user.is_diabetes}
    pillbox_db.insert_one(user_doc)
    return {"result": "ok"}

@app.put('/pillbox/users')
def put_user(user: User, request: Request):
    user_id = get_user_id(request.scope)
    if not is_exist(user_id):
        return {"result": "not exist User"}

    result = pillbox_db.update_one({"_id": user_id}, {"$set": user.__dict__})

    return {"result": "ok"}

@app.get('/pillbox/users/pill_histories')
def get_pill_histories(request: Request, name: str = ''):
    user_id = get_user_id(request.scope)

    match = {"$match": {}}
    if len(name) > 0:
        match["$match"]["pill_histories.name"] = name
    
    group = {"$group": {"_id": "$_id", "datas":{"$addToSet": "$pill_histories"}}}

    results_out = pillbox_db.aggregate([{"$match": {"_id": user_id}},
                                        {"$unwind": "$pill_histories"},
                                        match,
                                        group,
                                        {"$project": {"_id": 0,"datas._id": 0}}
                                        ])
    results = json.loads(json_util.dumps(results_out))
    results = results[0]['datas'] if len(results) > 0 else []
    return {"msg": "ok", 'datas': results}

# @app.get('/pillbox/users/pill_histories/:history_id')


handler = Mangum(app)
