'''
    크롤러 스크립트에서 공톹적으로 사용되는 요소를 기록해놓음
'''
import os
from dotenv import load_dotenv

load_dotenv() # .env파일에서 환경변수 읽기

# open API
NUM_OF_ROWS: int = 100
TASK_PER_ONCE: int = 5

# 식약청에서 제공하는 API들의 기본 URL
base_url: str = 'http://apis.data.go.kr/1471000'

# 환경 변수에 APITOKEN로 불러온다
# params로 넘길때 한번 인코딩되기에 디코딩된 키로 넘긴다.
token: str = os.getenv('APITOKEN')


# 대한민국약전의 제제 총직을 참고하여 경구 투여하는 약물만 추려내었다.
# https://nedrug.mfds.go.kr/pbp/CCEKP12/selectPopupList?phcpaLclasCode=EKP2#
# 제로 끝나거나 제외된다.
# CHART 키에서 약의 형태를 필터할때 쓰인다.

charts_suffix: tuple[str] = (
    '정제', '나제', '코팅제', '당의정', '다층정', '유핵제', '내핵제'
    '구강붕해제', '캡슐제', '과립제', '산제', '다제', '환제', '시럽제', '엑스제',
)

charts: tuple[str] = (
    '코팅', '당의정', '다층정', '유핵', '내핵제',
    '구강붕해', '캡슐', '과립', '시럽', '엑스',
)

full_charts: tuple[str] = charts_suffix + charts
