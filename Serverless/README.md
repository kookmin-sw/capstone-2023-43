# PillBox 서버리스 백엔드

# ARN 및 기타 정보 git 업로드 금지

## 요구사항

nodejs

sererless framework

aws cli

## 인증

AWS IAM `aws-cli` 계정 사용

## 환경변수

`.pillbox_environment` 파일 사용

## HTTP API 관리

`serverless.yml`의 `functions`에 추가

`handler`는 `경로/파이썬모듈.함수` 형태로 작성