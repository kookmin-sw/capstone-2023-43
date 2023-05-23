import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_frontend/pages/new_user_page/set_preset_page.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'button_toggleable_new_user.dart';

class NewUserPage extends HookConsumerWidget {
  const NewUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var birthdayController = useTextEditingController(text: "");
    var nameController = useTextEditingController(text: "");
    var checkDiabetes = useState(false);
    var checkPregnancy = useState(false);
    var genderToggle = useState([true, false]);
    var bloodPressureToggle = useState([false, true, false]);
    var maskFommater = MaskTextInputFormatter(
      mask: '####/##/##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    return BaseWidget(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(50.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 76.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(11, 106, 227, 1),
                ),
              ),
              Text(
                "서비스를 이용하기위해\n기본정보를 입력해 주세요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(11, 106, 227, 1),
                ),
              ),
              SizedBox(
                height: 85.h,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(11, 106, 227, 1)),
                    borderRadius: BorderRadius.circular(15.0.h)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 3.h),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      fontSize: 20.sp,
                      // fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(11, 106, 227, 1),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "이름",
                      hintStyle: TextStyle(
                        fontSize: 20.sp,
                        // fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(11, 106, 227, 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(11, 106, 227, 1)),
                    borderRadius: BorderRadius.circular(15.0.h)),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 3.h),
                  child: TextField(
                    controller: birthdayController,
                    inputFormatters: [maskFommater],
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      print(birthdayController.text);
                    },
                    style: TextStyle(
                      fontSize: 20.sp,
                      // fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(11, 106, 227, 1),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "생년월일(ex.1999/06/26)",
                      hintStyle: TextStyle(
                        fontSize: 20.sp,
                        // fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(11, 106, 227, 0.5),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ToggleButtons(
                isSelected: genderToggle.value,
                onPressed: (index) {
                  List<bool> newVal = genderToggle.value;
                  for (int i = 0; i < 2; i++) {
                    newVal[i] = i == index;
                  }
                  genderToggle.value = [...newVal];
                },
                selectedBorderColor: Color.fromRGBO(11, 106, 227, 1),
                borderColor: Color.fromRGBO(11, 106, 227, 1),
                selectedColor: Colors.white,
                fillColor: Color.fromRGBO(11, 106, 227, 1),
                color: Color.fromRGBO(11, 106, 227, 1),
                borderRadius: BorderRadius.circular(15.h),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text("남성"),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text("여성"),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              ToggleButtons(
                isSelected: bloodPressureToggle.value,
                onPressed: (index) {
                  List<bool> newVal = bloodPressureToggle.value;
                  for (int i = 0; i < 3; i++) {
                    newVal[i] = i == index;
                  }
                  bloodPressureToggle.value = [...newVal];
                },
                selectedBorderColor: Color.fromRGBO(11, 106, 227, 1),
                borderColor: Color.fromRGBO(11, 106, 227, 1),
                selectedColor: Colors.white,
                fillColor: Color.fromRGBO(11, 106, 227, 1),
                color: Color.fromRGBO(11, 106, 227, 1),
                borderRadius: BorderRadius.circular(15.h),
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text("고혈압"),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text("정상"),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    child: Text("저혈압"),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 17,
                      child: ButtonToggleableNewUser(50.h, () {
                        checkDiabetes.value = !checkDiabetes.value;
                      }, "당뇨병이 있어요", true)),
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                      flex: 17,
                      child: ButtonToggleableNewUser(50.h, () {
                        checkPregnancy.value = !checkPregnancy.value;
                      }, "임신했어요", true)),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              ref.read(HttpResponseServiceProvider).stage ==
                      ResposeStage.loading
                  ? CircularProgressIndicator()
                  : BaseButton(
                      text: "가입하기",
                      color: Color.fromRGBO(11, 106, 227, 1),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp),
                      onTap: () async {
                        if (nameController.text == "") return;
                        if (!maskFommater.isFill()) return;
                        String name = nameController.text;
                        String gender = genderToggle.value[0] ? "M" : "F";
                        int bloodPressure =
                            bloodPressureToggle.value.indexOf(true) - 1;
                        var dateData = birthdayController.text.split('/');
                        DateTime birthday = DateTime.utc(int.parse(dateData[0]),
                            int.parse(dateData[1]), int.parse(dateData[2]));
                        await ref.read(HttpResponseServiceProvider).postNewUser(
                            name,
                            gender,
                            birthday,
                            bloodPressure,
                            checkDiabetes.value,
                            checkDiabetes.value);
                        if (ref.read(HttpResponseServiceProvider).stage ==
                            ResposeStage.ready) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetPresetPage()));
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
