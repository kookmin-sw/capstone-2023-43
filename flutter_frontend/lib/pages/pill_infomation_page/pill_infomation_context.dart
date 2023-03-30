import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/base_button.dart';
import '../../widgets/base_item.dart';

class PillInfomationContext extends HookWidget {
  final String name;
  final String entpName;
  const PillInfomationContext({
    super.key,
    required this.name,
    required this.entpName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Container(
          height: 100.w,
          width: 100.w,
          color: Colors.grey,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    entpName,
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            BaseButton(
              text: '약 추가',
              color: Colors.amber,
              icon: Icon(
                Icons.medication,
                size: 18.w,
              ),
              onTap: () {},
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        BaseItem(
          color: Colors.red,
          child: Column(
            children: [
              Text(
                '현재 먹고 있는 약과 같이 복용금지된 약이에요!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 50,
                color: Colors.grey,
              )
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        BaseItem(
          color: Colors.orange,
          child: Column(
            children: [
              Text(
                '이런 분들은 약 사용에 주의해 주세요!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: 50.h,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        BaseItem(
          child: Column(
            children: const [
              Text('main descript'),
            ],
          ),
        ),
      ],
    );
  }
}
