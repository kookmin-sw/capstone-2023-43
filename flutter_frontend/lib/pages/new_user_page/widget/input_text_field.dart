import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TimeTextField extends HookWidget {
  final TextEditingController controller;
  final MaskTextInputFormatter formatter;
  final String hint;

  TimeTextField(
      {required this.controller, required this.formatter, required this.hint});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(11, 106, 227, 1)),
          borderRadius: BorderRadius.circular(15.0.h)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 3.h),
        child: TextField(
          controller: controller,
          inputFormatters: [formatter],
          style: TextStyle(
            fontSize: 20.sp,
            // fontWeight: FontWeight.w700,
            color: Color.fromRGBO(11, 106, 227, 1),
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 20.sp,
              // fontWeight: FontWeight.w700,
              color: Color.fromRGBO(11, 106, 227, 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
