import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class ProhibitTakeView extends HookWidget {
  List<int>? pills;

  ProhibitTakeView({
    this.pills,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItem(
      color: pills != null ? Colors.red : Colors.green,
      child: Column(
        children: [
          Text(
            pills != null ? '현재 먹고 있는 약과 같이 복용금지된 약이에요!' : "다른 약이랑 먹어도 괜찮아요!",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          pills != null
              ? Container(
                  height: 50,
                  color: Colors.grey,
                )
              : Container()
        ],
      ),
    );
  }
}
