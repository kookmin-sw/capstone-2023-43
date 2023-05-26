import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_frontend/pages/new_user_page/widget/input_text_field.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'button_toggleable_new_user.dart';

class SetPresetPage extends HookConsumerWidget {
  const SetPresetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var morningController = useTextEditingController(text: "");
    var lunchController = useTextEditingController(text: "");
    var dinnerController = useTextEditingController(text: "");
    var nightController = useTextEditingController(text: "");
    var morningMask = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    var lunchMask = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    var dinnerMask = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
    );
    var nightMask = MaskTextInputFormatter(
      mask: '##:##',
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
                "시간설정",
                style: TextStyle(
                  fontSize: 76.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(11, 106, 227, 1),
                ),
              ),
              Text(
                "기본 4가지의 복용 시간을 정해 \n 정기적으로 복용을 관리하세요.\n(정확히 입력하지 않으면 기본 정보가 입력됩니다.)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromRGBO(11, 106, 227, 1),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              TimeTextField(
                  controller: morningController,
                  formatter: morningMask,
                  hint: "아침 시간 설정(기본 09:00)"),
              SizedBox(
                height: 10.h,
              ),
              TimeTextField(
                  controller: lunchController,
                  formatter: lunchMask,
                  hint: "점심 시간 설정(기본 13:00)"),
              SizedBox(
                height: 10.h,
              ),
              TimeTextField(
                  controller: dinnerController,
                  formatter: dinnerMask,
                  hint: "저녁 시간 설정(기본 19:00)"),
              SizedBox(
                height: 10.h,
              ),
              TimeTextField(
                  controller: nightController,
                  formatter: nightMask,
                  hint: "자기전 시간 설정(기본 23:00)"),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              ref.read(HttpResponseServiceProvider).stage ==
                      ResposeStage.loading
                  ? CircularProgressIndicator()
                  : BaseButton(
                      text: "시작하기",
                      color: Color.fromRGBO(11, 106, 227, 1),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp),
                      onTap: () async {
                        if (!morningMask.isFill()) {
                          morningController.text = "09:00";
                        }
                        if (!lunchMask.isFill()) {
                          lunchController.text = "13:00";
                        }
                        if (!dinnerMask.isFill()) {
                          dinnerController.text = "19:00";
                        }
                        if (!nightMask.isFill()) {
                          nightController.text = "23:00";
                        }
                        await ref
                            .read(HttpResponseServiceProvider)
                            .postTimePreset(
                              "${morningController.text}:00",
                              "${lunchController.text}:00",
                              "${dinnerController.text}:00",
                              "${nightController.text}:00",
                            );
                        if (ref.read(HttpResponseServiceProvider).stage ==
                            ResposeStage.ready) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/main');
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
