import 'package:calendar_view/calendar_view.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleItem extends HookWidget {
  final String time;
  final String status;
  final int cnt;
  final DateTime date;
  const ScheduleItem(
      {super.key,
      required this.cnt,
      required this.time,
      required this.status,
      required this.date});
  @override
  Widget build(BuildContext context) {
    return BaseItem(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                formatDate(date, [HH, " : ", nn]),
                style: TextStyle(fontSize: 32.sp),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                status,
                style: TextStyle(
                  color: Color.fromRGBO(11, 106, 227, 1),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              Text(
                "복용해야할",
                style: TextStyle(fontSize: 20.sp),
              ),
              Text(
                " $cnt ",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
              ),
              Text(
                "개의 약이 있습니다!",
                style: TextStyle(fontSize: 20.sp),
              )
            ],
          )
        ],
      ),
    );
  }
}
