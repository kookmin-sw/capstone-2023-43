import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class CaseTakeView extends HookWidget {
  List<int>? pills;

  CaseTakeView({
    this.pills,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItem(
      color: pills != null ? Colors.yellow : Colors.green,
      child: Column(
        children: [
          Text(
            pills != null ? '현재 먹고 있는 약과 같이 복용금지된 약이에요!' : "약을 복용해도 부작용이 없어요!",
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
