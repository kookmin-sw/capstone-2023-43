import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleItem extends HookWidget {
  final String time;
  final String status;
  const ScheduleItem({super.key, required this.time, required this.status});
  @override
  Widget build(BuildContext context) {
    return BaseItem(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                time,
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
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Text('Row $index');
            },
          )
        ],
      ),
    );
  }
}
