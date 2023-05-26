import 'package:flutter/material.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressItem extends HookConsumerWidget {
  final int listCnt;
  final int hisCnt;
  const ProgressItem({super.key, required this.hisCnt, required this.listCnt});

  double getPecentage() {
    if (listCnt == hisCnt) return 0;
    if (hisCnt == 0) return 1;
    return (hisCnt - listCnt) / hisCnt;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                '${(getPecentage() * 100).toInt()}%',
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
          SizedBox(
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: getPecentage(),
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
              if (DateTime.now().hour < 9)
                Text(
                  '9',
                  style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0B6AE3)),
                )
              else if (DateTime.now().hour < 13)
                Text(
                  '12',
                  style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0B6AE3)),
                )
              else if (DateTime.now().hour < 19)
                Text(
                  '19',
                  style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0B6AE3)),
                )
              else if (DateTime.now().hour < 23)
                Text(
                  '23',
                  style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff0B6AE3)),
                ),
              Text(
                '시 복약예정',
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
