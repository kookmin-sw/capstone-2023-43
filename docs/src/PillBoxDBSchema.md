# PillBoxDBSchema 세부 설명

## User

### **id**

UUID

### **blood_pressure**

* 고
* 저

### **pregnancy**

  임신부

### **is_diabetes**

  당뇨여부

## pill_info

### **item_seq**

  품목기준코드
  9자리 숫자코드

### **name**

  품목명

### **entp_name**

  제조사

### **etc_otc_name**

  전문의약품, 일반의약품

### **class_name**

  약 분류 (etc: 항히스타민제, 소염제)

### **image_url**

  낱알 사진
  낱알만 사진을 가지고 있음
  제제총칙에 따라 경구투여 하는 제제 중

### **taboo_case**

비트마스크 기법을 이용하여 처리

코드 순서는 의약품안전사용서비스(DUR) 순서를 따른다

적합성 검사는 병용 금기, 특정연령금기, 임부금기, 노인금기만 다룬다.

* 병용 금기 : A = 0x001
* 특정연령 금기 : B = 0x002
* 임부 금기 : C = 0x004
* 용량 금기 : D = 0x008
* 투여기간 금기 : E = 0x010
* 노인금기 : F = 0x020
* 효능군 중복 : G = 0x040
* 분할주의 : H = 0x080
* 첨가제주의 : I = 0x100
* 당뇨금기 : J = 0x200 (DUR 이외)
* 혈압 : K = 0x400 (DUR 이외)

## mix_taboo

병용금기 약물의 쌍

### **mix_taboo.item_seq**

비교할 약물 품목기준코드

### **mixture_item_seq**

병용금기 약물 품목기준코드

### **prohibited_content**

금기 사유
