import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class CaseTakeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BaseItem(
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
    );
  }
}
