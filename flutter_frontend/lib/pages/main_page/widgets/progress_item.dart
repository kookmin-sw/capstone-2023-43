import 'package:flutter/material.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressItem extends StatelessWidget {
  const ProgressItem({super.key});
  @override
  Widget build(BuildContext context) {
    return BaseItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '복약관리',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'percent%',
                style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),
              Text(
                '복약완료',
                style: TextStyle(
                  fontSize: 16.w,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: 0.7,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff0B6AE3)),
                backgroundColor: Color(0xffD6D6D6),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Time',
                style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff0B6AE3)),
              ),
              Text(
                '후 복약예정',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
