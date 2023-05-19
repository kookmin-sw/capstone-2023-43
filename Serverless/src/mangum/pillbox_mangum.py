import os
import json
from datetime import datetime, timedelta, time
import asyncio
from pytz import UTC
import aiohttp
from dateutil.relativedelta import relativedelta
from pydantic import BaseModel
from pydantic.error_wrappers import ValidationError
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse
from starlette.requests import Request
from mangum import Mangum
import motor.motor_asyncio
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
    pb_pill_info_by_pk(item_seq: $item_seq) {
        item_seq,
        taboo_case
    }
}
'''

# docs/src/PillBoxDBSchema 참조
# 병용금기, 특정나이 금기(성인 미만), 임신여부, 노인 금기만 다룸
TABOO_CASE = {0x001: 'mix taboo', 0x002: 'certen age group', 0x004: 'pregnancy',
              0x020: 'elders'}

HASURA_ENDPOINT = os.environ.get('HASURA_ENDPOINT_URL')


class PresetTimeOut(BaseModel):
    id: str
    name: str
    time: str

    @staticmethod
    def from_dict(json_dict):
        id_ = json_dict['_id']['$oid']
        name = json_dict['name']
        time_ = json_dict['time']
        return PresetTimeOut(id=id_, name=name, time=time_)


class PresetTimePost(BaseModel):
    name: str
    time: str


class PresetTimePatch(BaseModel):
    name: str | None = None
    time: str | None = None


# Model define section
class PillHistoryOut(BaseModel):
    id: str
    name: str
    pills: list[int]
    start_date: datetime
    end_date: datetime
    preset_times: list[str]

    @staticmethod
    def from_dict(json_dict: dict[str, any]):
        '''
            inputs data from bson to json dict
        '''
        id_ = json_dict['_id']['$oid']
        name = json_dict['name']
        pills = json_dict['pills']
        start_date = json_dict['start_date']['$date']
        end_date = json_dict['end_date']['$date']
        preset_times = [preset_time_id for preset_time_id in json_dict['preset_times']]
        return PillHistoryOut(id=id_, name=name, pills=pills,
                              start_date=start_date, end_date=end_date, preset_times=preset_times)


class PillHistoryPatch(BaseModel):
    name: str | None = None
    pills: list[int] | None = [1]
    start_date: datetime | None = None
    end_date: datetime | None = None
    preset_times: list[str] | None = [1]


class PillHistoryPost(BaseModel):
    name: str
    pills: list[int]
    start_date: datetime
    end_date: datetime
    preset_times: list[str]


class UserOut(BaseModel):
    id: str
    name: str
    gender: str
    birthday: str
    blood_pressure: int
    is_diabetes: bool
    is_pregnancy: bool
    pill_histories: list[PillHistoryOut]
    preset_times: list[PresetTimeOut]

    @staticmethod
    def from_dict(json_dict: dict[str, any]):
        id_ = json_dict['_id']
        name = json_dict['name']
        gender = json_dict['gender']
        birthday = json_dict['birthday']['$date']
        blood_pressure = json_dict['blood_pressure']
        is_diabetes = json_dict['is_diabetes']
        is_pregnancy = json_dict['is_pregnancy']
        if len(json_dict['pill_histories']) > 0:
            pill_histories = [PillHistoryOut.from_dict(pill_history) for pill_history in json_dict['pill_histories']]
        else:
            pill_histories = []
        if len(json_dict['preset_times']) > 0:
            preset_times = [PresetTimeOut.from_dict(preset_time) for preset_time in json_dict['preset_times']]
        else:
            preset_times = []

        return UserOut(id=id_, name=name, gender=gender, birthday=birthday, blood_pressure=blood_pressure,
                       is_diabetes=is_diabetes, is_pregnancy=is_pregnancy, pill_histories=pill_histories,
                       preset_times=preset_times)


class UserPost(BaseModel):
    name: str
    gender: str
    birthday: datetime
    blood_pressure: int
    is_diabetes: bool
    is_pregnancy: bool


class UserPatch(BaseModel):
    name: str | None = None
    gender: str | None = None
    birthday: datetime | None = None
    blood_pressure: int | None = None
    is_diabetes: bool | None = None
    is_pregnancy: bool | None = None


class Validation(BaseModel):
    pills: list[int]
    start_date: datetime = datetime.utcnow()
    # 대부분의 처방전이 3일치 라는 것을 염두하고 처리함
    end_date: datetime = datetime.utcnow() + timedelta(days=3)


class MixTaboo(BaseModel):
    item_seq: int
    mixture_item_seq: int
    prohibited_content: str

    @staticmethod
    def from_dict(json_dict: dict):
        item_seq = json_dict['item_seq']
        mixture_item_seq = json_dict['mixture_item_seq']
        prohibited_content = json_dict['prohibited_content']
        return MixTaboo(item_seq=item_seq, mixture_item_seq=mixture_item_seq, prohibited_content=prohibited_content)


class ValidationOut(BaseModel):
    mix_taboos: list[MixTaboo] | None
    taboo_case: list[str] | None


# mongodb Connection section
host = os.environ.get('MONGODB_HOST')
username = os.environ.get('MONGODB_USERNAME')
password = os.environ.get('MONGODB_PASSWORD')
authSource = os.environ.get('MONGODB_AUTHSOURCE')

client = motor.motor_asyncio.AsyncIOMotorClient(host, username=username, port=27017,
                                                password=password, authSource=authSource)
pillbox_db = client['pillbox']['pillbox']


# asgi section
app = FastAPI()


def get_user_id(scope):
    try:
        user_id = scope['aws.event']['requestContext']['authorizer']['claims']['sub']
    except KeyError:
        user_id = None
    return user_id


async def is_exist(user_id: str) -> bool:
    result = await pillbox_db.find_one({"_id": user_id})
    return True if result is not None else False


def get_age(birthday: datetime) -> int:
    return relativedelta(datetime.utcnow(), birthday).years


async def get_pills(user_id: str) -> list[int]:
    # 요청의 복용기간내에 존재하는 복용기록의 의약품들의 품목기준코드를 가져오는 aggregate pipeline
    pipeline: list[dict[str, any]] = [{"$match": {"_id": user_id}}]
    pipeline.append({"$unwind": "$pill_histories"})
    pipeline.append({"$unwind": "$pill_histories.pills"})
    pipeline.append({"$match": {"pill_histories.end_date": {"$gte": datetime.utcnow()},
                                "pill_histories.start_date": {"$lte": datetime.utcnow()}}})
    pipeline.append({"$group": {"_id": "$_id", "pills": {"$push": "$pill_histories.pills"}}})

    result_out = pillbox_db.aggregate(pipeline=pipeline)

    result_out = [result async for result in result_out]

    if len(result_out) > 0:
        pills = result_out[0]['pills']
    else:
        return []

    print(pills)
    return pills


async def mix_taboo_valid(pills: list[int], pill: int) -> list[MixTaboo]:
    async with aiohttp.ClientSession() as session:
        async with session.post(HASURA_ENDPOINT, json={'query': MIX_TABOO_QUERY,
                                                       'variables': {'item_seqs': pills,
                                                                     'mixture_item_seq': pill}}) as response:
            print(response.request_info)
            if response.status != 200:
                print('Hasura endpoint error, mix_taboo_valid')
                print(await response.json())
                raise HTTPException(500, 'internal error')

            body = await response.json()

            if "errors" in body.items():
                print("query error")
                raise HTTPException(500, 'internal error')

            datas = body['data']['pb_mix_taboo']

            if len(datas) > 0:
                mix_taboos = [MixTaboo.from_dict(mix_taboo) for mix_taboo in datas]
                return mix_taboos
            return []


async def dur_check(pill: int, user: dict) -> list[str]:
    async with aiohttp.ClientSession() as session:
        async with session.post(HASURA_ENDPOINT, json={'query': TABOO_CASE_QUERY,
                                                       'variables': {'item_seq': pill}}) as response:
            print(response.request_info)
            if response.status != 200:
                print('Hasura endpoint error, dur_check')
                print(await response.json())
                raise HTTPException(500, 'internal error')

            body = await response.json()
            if "errors" in body.items():
                raise HTTPException(500, 'internal error')

            data = body['data']['pb_pill_info_by_pk']

            if data is None:
                raise HTTPException(404, 'item_seq is not in db')

            taboo_list: list[str] = []

            # 사용자에게 해당된 주의 사항만 taboo_list에 추가하여 반환한다.
            for bit, message in TABOO_CASE.items():
                add_message_flag = False
                if data['taboo_case'] & bit == bit:
                    if user['is_pregnancy'] and message == 'pregnancy':
                        add_message_flag = True
                    if get_age(user['birthday']) < 19 and message == 'certen age group':
                        add_message_flag = True
                    if get_age(user['birthday']) >= 65 and message == 'elders':
                        add_message_flag = True
                if add_message_flag:
                    taboo_list.append(message)

            return taboo_list


@app.get('/pillbox/users')
async def get_user(request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        raise HTTPException(status_code=401)
    user_doc = await pillbox_db.find_one({"_id": user_id})
    if user_doc is None:
        raise HTTPException(status_code=404, detail="user not found")
    user_doc = json.loads(json_util.dumps(user_doc))
    try:
        user = UserOut.from_dict(user_doc)
    except KeyError as key_error:
        print(key_error)
        raise HTTPException(status_code=500, detail="internal error key error") from key_error
    except ValidationError as valid:
        print(valid)
        raise HTTPException(status_code=500, detail="internal error") from valid

    return {"result": "ok", "data": user}


@app.get('/pillbox/users/pills')
async def get_users_pills(request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        raise HTTPException(status_code=401)
    user_doc = await pillbox_db.find_one({"_id": user_id})

    if user_doc is None:
        raise HTTPException(status_code=404, detail="user not found")

    pills = await get_pills(user_id)

    return {"result": "ok", "data": pills}


@app.post('/pillbox/users', status_code=201)
async def post_user(user: UserPost, request: Request):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(status_code=401, detail="Unauthorized")

    if user.gender == 'M' and user.is_pregnancy:
        raise HTTPException(status_code=400, detail='human male cannot get pregnant')

    if user.gender not in ['M', 'F']:
        raise HTTPException(status_code=400, detail='choose gender male or female')

    if user.birthday.replace(tzinfo=UTC) >= datetime.utcnow().replace(tzinfo=UTC):
        raise HTTPException(status_code=400, detail='birth day error')

    if user.blood_pressure not in [-1, 0, 1]:
        raise HTTPException(status_code=400, detail='choose blood_pressure state [high(1), normal(0), low(-1)]')

    user.name = user.name.strip()

    if len(user.name) < 0:
        raise HTTPException(status_code=400, detail="user name is blank")

    user_doc = user.__dict__
    user_doc['_id'] = user_id
    user_doc['pill_histories'] = []
    user_doc['preset_times'] = []

    try:
        await pillbox_db.insert_one(user_doc)
    except errors.DuplicateKeyError as exc:
        raise HTTPException(status_code=409, detail="user already exist") from exc

    return {"result": "ok"}


@app.patch('/pillbox/users')
async def patch_user(user: UserPatch, request: Request):
    user_id = get_user_id(request.scope)
    if user_id is None:
        raise HTTPException(status_code=401)
    if not is_exist(user_id):
        raise HTTPException(status_code=404, detail="user not found")

    default_count = 0
    for v in user.__dict__.values():
        if v is None:
            default_count += 1

    if default_count == len(user.__dict__.values()):
        raise HTTPException(status_code=400, detail='give any data')

    if user.gender is not None and user.gender not in ['M', 'F']:
        raise HTTPException(status_code=400, detail='choose gender male or female')

    user_in_db = await pillbox_db.find_one({'_id': user_id}, {"gender": 1, "is_pregnancy": 1})
    if user.gender is None or user.is_pregnancy is None:
        if user_in_db['gender'] == 'M' and user.is_pregnancy:
            raise HTTPException(status_code=400, detail='human male cannot get pregnant')

        if user_in_db['gender'] == 'F' and user_in_db['is_pregnancy'] and user.gender == 'M':
            raise HTTPException(status_code=400, detail='human male cannot get pregnant.')

    if user.gender == 'M' and user.is_pregnancy:
        raise HTTPException(status_code=400, detail='human male cannot get pregnant')

    if user.blood_pressure not in [None, -1, 0, 1]:
        raise HTTPException(status_code=400, detail='choose in [1, 0, -1]')

    if user.birthday is not None and user.birthday.replace(tzinfo=UTC) >= datetime.utcnow().replace(tzinfo=UTC):
        raise HTTPException(status_code=400, detail='birth day error')

    user_dict = {k: v for k, v in user.__dict__.items() if v is not None}

    await pillbox_db.update_one({"_id": user_id}, {"$set": user_dict})

    return {"result": "ok"}


@app.get('/pillbox/users/preset_times')
async def get_users_preset_time(request: Request):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(status_code=401)

    result = await pillbox_db.find_one({"_id": user_id}, {"preset_times": 1})

    if result is None:
        raise HTTPException(status_code=404)

    result = json.loads(json_util.dumps(result))

    preset_times = result['preset_times']
    preset_times = [PresetTimeOut.from_dict(preset_time) for preset_time in preset_times]

    return {"result": "ok", "data": preset_times}


@app.get('/pillbox/users/preset_times/{preset_time_id}')
async def get_users_preset_time_by_id(request: Request, preset_time_id: str):
    user_id = get_user_id(request)

    if user_id is None:
        raise HTTPException(status_code=401)

    try:
        result = await pillbox_db.find_one({"_id": user_id, "preset_times._id": ObjectId(preset_time_id)},
                                           {"preset_times": 1})
    except Exception as exc:
        raise HTTPException(400, "error of id") from exc

    if result is None:
        raise HTTPException(status_code=404)

    result = json.loads(json_util.dumps(result))

    preset_times = result['preset_times']

    preset_time = [item for item in preset_times if item['_id']['$oid'] == preset_time_id][0]

    preset_time: PresetTimeOut = PresetTimeOut.from_dict(preset_time)
    print(type(preset_time))

    return {"result": "ok", "data": preset_time}


@app.post('/pillbox/users/preset_times')
async def post_users_preset_time(request: Request, preset_time: PresetTimePost):
    user_id = get_user_id(request)

    if user_id is None:
        raise HTTPException(status_code=401)

    result = await pillbox_db.find_one({"_id": user_id, "preset_times.name": preset_time.name})

    if result is not None:
        raise HTTPException(400, "already exist name")

    try:
        time.fromisoformat(preset_time.time)
    except ValueError as exc:
        raise HTTPException(400, "need right time format(ISO)") from exc

    preset_time_dict = preset_time.__dict__
    preset_time_dict["_id"] = ObjectId()
    await pillbox_db.update_one({"_id": user_id}, {'$push': {"preset_times": preset_time_dict}})

    return {"result": "ok", "data": str(preset_time_dict["_id"])}


@app.patch('/pillbox/users/preset_times/{preset_time_id}')
async def patch_users_preset_time(request: Request, preset_time_id: str, preset_time: PresetTimePatch):
    user_id = get_user_id(request)

    if preset_time.name is None and preset_time.time is None:
        raise HTTPException(400, "need any data")

    if user_id is None:
        raise HTTPException(status_code=401)
    try:
        preset_time_id = ObjectId(preset_time_id)
    except TypeError as type_error:
        raise HTTPException(400, "invalid preset time id") from type_error

    if preset_time.name is not None:
        result = await pillbox_db.find_one({"_id": user_id,
                                            "preset_times.name": preset_time.name,
                                            "preset_times._id": {"$ne": preset_time_id}})

        if result is not None:
            raise HTTPException(400, "already exist name")

    if preset_time.time is not None:
        try:
            time.fromisoformat(preset_time.time)
        except ValueError as exc:
            raise HTTPException(400, "need right time format(ISO)") from exc

    update_query = {"preset_times.$." + k: v for k, v in preset_time.__dict__.items() if v is not None}
    result = await pillbox_db.update_one({"_id": user_id, "preset_times._id": preset_time_id}, {'$set': update_query})

    if result.matched_count < 0:
        raise HTTPException(404, "not found")

    return {"result": "ok"}


@app.delete('/pillbox/users/preset_times/{preset_time_id}')
async def delete_users_preset_time(request: Request, preset_time_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException("Unauthorization")

    try:
        preset_time_id = ObjectId(preset_time_id)
    except TypeError as type_error:
        raise HTTPException(400, "invalid preset time id") from type_error

    preset_time = await pillbox_db.find_one({"_id": user_id, "preset_times._id": preset_time_id})

    if preset_time is None:
        raise HTTPException(404, "There is no data")

    await pillbox_db.update_one({"_id": user_id}, {"$pull": {"preset_times": {"_id": preset_time_id}}})

    return {"result": "ok"}


@app.post('/pillbox/users/validation')
async def validation(request: Request, valid: Validation):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(401, "Unauthorized")

    if not is_exist(user_id):
        raise HTTPException(400, "user not fount")

    if valid.end_date <= valid.start_date:
        raise HTTPException(400, "start_date must be less than end_date")

    if valid.pills is None or len(valid.pills) == 0:
        raise HTTPException(400, "need pills")

    for pill in valid.pills:
        if len(str(pill)) != 9:
            raise HTTPException(400, f"need valid item_seq {pill}")

    # 요청의 복용기간내에 존재하는 복용기록의 의약품들의 품목기준코드를 가져오는 aggregate pipeline
    pipeline: list[dict[str, any]] = [{"$match": {"_id": user_id}}]
    pipeline.append({"$unwind": "$pill_histories"})
    pipeline.append({"$unwind": "$pill_histories.pills"})
    pipeline.append({"$match": {"pill_histories.end_date": {"$gte": valid.start_date},
                                "pill_histories.start_date": {"$lte": valid.end_date}}})
    pipeline.append({"$group": {"_id": "$_id", "pills": {"$push": "$pill_histories.pills"}}})

    result_out = pillbox_db.aggregate(pipeline=pipeline)

    result_out = [result async for result in result_out]

    if len(result_out) > 0:
        pills = result_out[0]['pills']
    else:
        pills = []
    print(pills)

    user = pillbox_db.find_one({"_id": user_id}, {'is_pregnancy': 1, 'birthday': 1})

    check_validation = [mix_taboo_valid(pills + valid.pills[:-1], valid.pills[-1]), dur_check(valid.pills[-1], user)]
    results = await asyncio.gather(*check_validation)

    print(results[0])

    if len(results[0]) != 0 or len(results[1]) != 0:
        return {"result": "not ok", "mix_taboos": results[0], "taboo_case": results[1]}
    return {"result": "ok"}


@app.get('/pillbox/users/pill_histories')
async def get_pill_histories(request: Request, name: str = None, all_histories: bool = False,
                             only_ended_histories: bool = False):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(401, "Unauthoriazed")

    if not await is_exist(user_id):
        raise HTTPException(404, "user not found")

    if all_histories and only_ended_histories:
        raise HTTPException(400, "choose one parameter from all_histories and only_ended_histories")

    match = {"$match": {}}
    if name is not None:
        match["$match"]["pill_histories.name"] = name
    if not all_histories:
        match["$match"]["pill_histories.end_date"] = {"$gte": datetime.utcnow()}
        match["$match"]["pill_histories.start_date"] = {"$lte": datetime.utcnow()}
    elif only_ended_histories:
        match["$match"]["pill_histories.end_date"] = {"$lt": datetime.utcnow()}

    group = {"$group": {"_id": "$_id", "datas": {"$addToSet": "$pill_histories"}}}

    results_out = pillbox_db.aggregate([{"$match": {"_id": user_id}},
                                        {"$unwind": "$pill_histories"},
                                        match,
                                        group,
                                        {"$project": {"_id": 0}}
                                        ])

    if results_out is None:
        return {"result": "ok"}

    results = [result async for result in results_out]

    if len(results) == 0:
        raise HTTPException(404, "not found pill histories")

    results = results[0]

    results = json.loads(json_util.dumps(results_out))
    results = results[0]['datas'] if len(results) > 0 else []
    if len(results) > 0:
        return {"result": "ok", "data": [PillHistoryOut.from_dict(result) for result in results]}

    return {"result": "ok"}


@app.get('/pillbox/users/pill_histories/{history_id}')
async def get_pill_history_by_id(request: Request, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(401, "Unauthoriazed")

    if not is_exist(user_id):
        raise HTTPException(404, "user not found")

    try:
        history_id = ObjectId(history_id)
    except InvalidId as invalid_id:
        raise HTTPException(400, "pass invalid history id") from invalid_id

    result_out = await pillbox_db.find_one({"_id": user_id,
                                            "pill_histories._id": history_id})
    if result_out is None:
        raise HTTPException(404, f"there is no data with {history_id}")

    results = json.loads(json_util.dumps(result_out))
    result = [result for result in results['pill_histories'] if result['_id']['$oid'] == str(history_id)][0]

    if len(results) == 0:
        raise HTTPException(404, "user pill history not found")

    return {"result": "ok", "data": PillHistoryOut.from_dict(result)}


# 검증 및 request body 확인 코드 필요
@app.post('/pillbox/users/pill_histories', status_code=201)
async def post_pill_history(request: Request, pill_history: PillHistoryPost):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException(401, "Unauthorization")

    if not await is_exist(user_id):
        raise HTTPException(404, "user not found")

    # 복용기록의 이름이 공백이거나 전달이 안된 경우
    pill_history.name = pill_history.name.strip()
    if len(pill_history.name) < 0:
        raise HTTPException(400, "Need history name")

    if pill_history.end_date <= pill_history.start_date:
        raise HTTPException(400, "start_date less then end_date")

    if len(pill_history.pills) <= 0:
        raise HTTPException(400, "Need pill list")

    for pill in pill_history.pills:
        if len(str(pill)) != 9:
            raise HTTPException(400, f"Invalid item_seq {pill}")

    # 이름이 같은 복용기록을 처리하기 위한 과정
    duplicated_history = await pillbox_db.find_one({"_id": user_id, "pill_histories.name": pill_history.name})
    if duplicated_history is not None:
        raise HTTPException(409, "pill history already exists")

    preset_time_id_list = [ObjectId(preset_time_id) for preset_time_id in pill_history.preset_times]
    is_preset_time_exist = await pillbox_db.find_one({"_id": user_id, "preset_times._id":
                                                        {"$all": preset_time_id_list}})

    if is_preset_time_exist is None:
        raise HTTPException(400, "preset_time_id not exist")

    pill_history_dict = pill_history.__dict__
    pill_history_dict["_id"] = ObjectId()

    await pillbox_db.update_one({"_id": user_id}, {"$push": {"pill_histories": pill_history_dict}})

    return {"result": "ok", "data": str(pill_history_dict["_id"])}


# 검증 및 request body 확인 코드 필요
@app.patch('/pillbox/users/pill_histories/{history_id}')
async def update_pill_history_by_id(request: Request, pill_history: PillHistoryPatch, history_id: str):
    user_id = get_user_id(request.scope)

    default_count = 0
    for k, v in pill_history.__dict__.items():
        if k in ['pills', 'preset_times']:
            if v[0] == 1:
                default_count += 1
        else:
            if v is None:
                default_count += 1

    if default_count == len(pill_history.__dict__.keys()):
        raise HTTPException(400, "give any data")

    if user_id is None:
        raise HTTPException(401, "Unauthorization")
    try:
        history_id = ObjectId(history_id)
    except TypeError as type_error:
        raise HTTPException(400, "invalid history id") from type_error

    # 들어온 날짜가 유요하지 않으면 에러 반환
    if pill_history.end_date is not None and pill_history.start_date is not None:
        # pill_history.end_date가 pill_history보다 크면 유요하다.
        if pill_history.end_date <= pill_history.start_date:
            raise HTTPException(400, "start_date must be less then end_date")

    elif pill_history.start_date is not None:
        # pill_histories.start_date가 end_date on documents 보다 크면 유효하다.
        result = await pillbox_db.find_one({"_id": user_id, "pill_histories":
                                            {"$elemMatch":
                                                {"_id": history_id, "end_date": {"$gt": pill_history.start_date}}}})
        if result is None:
            raise HTTPException(400, "start_date must be less then end_date")

    elif pill_history.end_date is not None:
        # pill_histories.end_date가 start_date on document보다 크면 유효하다.
        result = await pillbox_db.find_one({"_id": user_id, "pill_histories":
                                            {"$elemMatch":
                                                {"_id": history_id, "start_date": {"$lt": pill_history.end_date}}}})
        if result is None:
            raise HTTPException(400, "end_date must be greater than start_date")

    if pill_history.pills is None or len(pill_history.pills) <= 0:
        raise HTTPException(400, "Need pill list")

    if pill_history.pills == [1]:
        pill_history.pills = None

    if pill_history.pills is not None:
        for pill in pill_history.pills:
            if len(str(pill)) != 9:
                raise HTTPException(400, f"Invalid item_seq {pill}")

    if pill_history.name is not None:
        # history_id는 다른데 이름은 같은 기록을 찾는다.
        result = await pillbox_db.find_one({"_id": user_id, "pill_histories":
                                            {"$elemMatch": {"_id": {"$ne": history_id}, "name": pill_history.name}}})
        if result is not None:
            raise HTTPException(400, "history name already exist")

    if pill_history.preset_times != [1]:
        try:
            preset_time_id_list = [ObjectId(preset_time_id) for preset_time_id in pill_history.preset_times]
        except TypeError as type_error:
            raise HTTPException(400, "invalid preset time id") from type_error
        is_preset_time_exist = await pillbox_db.find_one({"_id": user_id,
                                                          "preset_times._id": {"$all": preset_time_id_list}})

        if is_preset_time_exist is None:
            raise HTTPException(400, "preset_time_id not exist")

    update_query = pill_history.__dict__
    update_query = {"pill_histories.$."+k: v for k, v in update_query.items() if v is not None}

    await pillbox_db.update_one({"_id": user_id, "pill_histories._id": history_id}, {"$set": update_query})

    return {"result": "ok"}


@app.delete('/pillbox/users/pill_histories/{history_id}')
async def delete_pill_history_by_id(request: Request, history_id: str):
    user_id = get_user_id(request.scope)

    if user_id is None:
        raise HTTPException("Unauthorization")

    try:
        history_id = ObjectId(history_id)
    except TypeError as type_error:
        raise HTTPException(400, "invalid history id") from type_error

    history = await pillbox_db.find_one({"_id": user_id, "pill_histories._id": history_id})

    if history is None:
        raise HTTPException(404, "There is no data")

    await pillbox_db.update_one({"_id": user_id}, {"$pull": {"pill_histories": {"_id": history_id}}})

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
    if len(str(item_seq)) != 9:
        return HTMLResponse(content=html_404, status_code=404)

    # python 3.8이라 문제가 생기는 듯
    async with aiohttp.ClientSession() as session:
        async with session.post(HASURA_ENDPOINT, json={"query": query, "variables": variable}) as response:
            if response.status != 200:
                print("hasura end point error, get_pill_data")
                raise HTTPException(500, "internal error")
            body = await response.json()
            data = body["data"]["pb_pill_info"]
            if data is None or len(data) == 0:
                return HTMLResponse(html_404, status_code=404)
            data = data[0]
            html = html.format(name=data['name'], effect=data['effect'],
                               use_method=data['use_method'], warning_message=data['warning_message'])
    return HTMLResponse(html)


handler = Mangum(app)
