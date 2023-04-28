from fastapi import FastAPI
from starlette.requests import Request
from mangum import Mangum

app = FastAPI()

@app.get("/")
def hello_world(request: Request):
    return {"aws": request.scope["aws"]}

handler = Mangum(app)