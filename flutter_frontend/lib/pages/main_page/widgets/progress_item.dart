import 'package:flutter/material.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProgressItem extends HookConsumerWidget {
  const ProgressItem({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(HttpResponseServiceProvider).list;
    final cnt = useState(ref.read(HttpResponseServiceProvider).getTodaycnt());
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
              cnt.value == 0
                  ? list.length == cnt.value
                      ? Text(
                          '0%',
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        )
                      : Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        )
                  : Text(
                      '${(((cnt.value - list.length) / cnt.value) * 100).toInt()}%',
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
                value: cnt.value == 0
                    ? 1
                    : list.length == cnt.value
                        ? 0
                        : ((cnt.value - list.length) / cnt.value),
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
                '시에 복약예정',
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
