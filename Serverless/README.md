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

## Cognito 인증테스트

`aws cognito-idp initiate-auth --auth-flow USER_PASSWORD_AUTH --auth-parameters USERNAME="pillboxtest",PASSWORD="<암호>" --client-id <client_id>`

여기서 나온 idToken이랑 AccessToken 잘 보관할것

`curl -H 'Authorization: Bearer <idToken>' https://~~~~~~~~~~~~~`
이렇게 하면 cognito 인증 되서 넘어감

