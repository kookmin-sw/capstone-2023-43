# PillBox

<img width=200px height=200px src="https://github.com/kookmin-sw/capstone-2023-43/blob/main/docs/images/PillBox%20icon.jpg?raw=true">

![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![PyTorch](https://img.shields.io/badge/PyTorch-%23EE4C2C.svg?style=for-the-badge&logo=PyTorch&logoColor=white) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) ![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white) ![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white) ![GraphQL](https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white)

## 프로젝트 소개

* PillBox는 약의 오용을 방지하고 안전한 약 복용을 도와주는 앱입니다.
* 약을 검색하고, 복용약 리스트와 복용 일정을 관리해줍니다.
* 사용자의 나이, 임신여부 등의 상태를 기반으로 복용하지 말아야하는 약을 알려줍니다.
* 2개 이상의 약을 같이 복용할 경우 괜찮은지 알려줍니다.
* 사용자가 설정한 복용시간을 맞추어 알람을 줍니다.
* 약을 먹은 날과 그렇지 않은 날을 시각적으로 보여줍니다.
* 낱알의 약을 사진을 찍어 인공지능이 어떤 약인지 알려줍니다.
* 구강투여하는 제제 중 몇가지를 추려 약에 대한 정보를 알려줍니다.

## Abstract

* PillBox is an app that helps prevent medication misuse and promotes safe medication intake.
* It allows you to search for medications and manage a medication list and intake schedule.
* It informs you about medications that should not be taken based on your age, pregnancy status, and other conditions.
* It advises whether it is safe to take multiple medications together.
* It sets alarms according to the user's specified medication intake times.
* It visually displays the days when medication was taken and when it was not.
* By taking a photo of a pill, the app's artificial intelligence identifies the medication.
* It provides information about certain oral medications to help you understand them better.

## 소개 영상

[![소개영상](https://img.youtube.com/vi/l31WvqrPxOU/0.jpg)](https://youtu.be/l31WvqrPxOU)

## 팀 소개

### 팀 이름

_**2023년 캡스톤 최종 최종_진짜최종_final**_
___

### 팀원 소개 (사전 배열)

<br/>

><img width=300px height=400px src="./docs/images/김재하사진.jpg" alt = "김재하의 사진">

>* 이름 : 김재하
>* 학번 : ****1593
>* 역할 : 프론트엔드와 ML

<br/>

><img width=300px height=300px src="./docs/images/김진석사진.jpg"/>

>* 이름 : 김진석
>* 학번 : ****1600
>* 역할 : PM 및 백엔드와 프론트엔드 보조

<br/>

><img width=300px height=300px src="./docs/images/박종흠사진.jpg" alt = "박종흠의 사진">

>* 이름 : 박종흠
>* 학번 : ****1619
>* 역할 : 백엔드와 ML

<br/>

## 기타

### 공공데이터 사용 목록

#### 식품의약품안전처

* [의약품 제품 허가정보](https://www.data.go.kr/tcs/dss/selectApiDataDetailView.do?publicDataPk=15095677) : 품목이름, 품목기준코드, 전문의약품 여부, 용법, 주의사항, 효능, 제조사
* [의약품 낱알식별 정보](https://www.data.go.kr/data/15057639/openapi.do) : 낱알 사진
* [의약품안전사용서비스(DUR)품목정보](https://www.data.go.kr/data/15059486/openapi.do) : 병용금기, DUR 품목정보 조회
* [인공지능 개발을 위한 알약 이미지 데이터](https://www.data.go.kr/data/15112582/fileData.do) : 인공지능 학습데이터

### 참고자료 목록

* [의약품 안전나라 통칙](https://nedrug.mfds.go.kr/pbp/CCEKP11/selectPopupList?phcpaLclasCode=EKP1)
* [의약품 안전나라 제제 총칙](https://nedrug.mfds.go.kr/pbp/CCEKP12/selectPopupList?phcpaLclasCode=EKP2)
* [식품의약품안전처예규 제40호](https://www.law.go.kr/LSW/admRulInfoP.do?admRulSeq=2000000023507#AJAX)
* [건강보험심사평가원](https://www.hira.or.kr/ra/medi/form.do?pgmid=HIRAA030029000000)
