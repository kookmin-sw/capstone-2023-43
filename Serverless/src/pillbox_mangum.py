from fastapi import FastAPI, APIRouter
from starlette.requests import Request
from starlette.responses import JSONResponse
from mangum import Mangum
from starlette.exceptions import HTTPException as StarletteHttpException

app = FastAPI()

@app.exception_handler(StarletteHttpException)
def error_handler(request: Request, exc):
    print(request.url)
    return JSONResponse(
        status_code=404,
        content={"error": "not found"}
    )

@app.get("/pillbox/test")
def hello_world(request: Request):
    print(request.url)
    return {"aws": "5678"}

@app.post("/pillbox")
def hello_world(request: Request):
    print(request.url)
    return {"aws": "1234"}

handler = Mangum(app)