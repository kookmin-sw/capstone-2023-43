import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/pill_infomation_context.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PillInfomationPage extends HookWidget {
  final int itemSeq;
  const PillInfomationPage({
    required this.itemSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "약 정보",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              PillInfomationContext(
                itemSeq: itemSeq,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
