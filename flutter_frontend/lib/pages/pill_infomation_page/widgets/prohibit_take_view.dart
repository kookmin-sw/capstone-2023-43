import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class ProhibitTakeView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return BaseItem(
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
    );
  }
}
