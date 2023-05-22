import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class CaseTakeView extends HookWidget {
  List<dynamic>? pills;
  String status;

  CaseTakeView({
    this.pills,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItem(
      color: status != "ok" && pills!.isNotEmpty ? Colors.orange : Colors.green,
      child: Column(
        children: [
          Text(
            status != "ok" && pills!.isNotEmpty
                ? '이런분들은 약 사용에 주의해 주세요!'
                : "약을 복용해도 부작용이 없어요!",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          status != "ok" && pills!.isNotEmpty
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
