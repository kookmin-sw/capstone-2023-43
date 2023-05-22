import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_item.dart';

class ProhibitTakeView extends HookWidget {
  List<dynamic>? pills;
  String status;

  ProhibitTakeView({
    this.pills,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItem(
      color: status != "ok" && pills!.isNotEmpty ? Colors.red : Colors.green,
      child: Column(
        children: [
          Text(
            status != "ok" && pills!.isNotEmpty
                ? '현재 먹고 있는 약과 같이 복용금지된 약이에요!'
                : "다른 약이랑 먹어도 괜찮아요!",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          status != "ok" && pills!.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Text(
                      "▶ " + pills![index],
                      style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    );
                  },
                  itemCount: pills!.length,
                )
              : Container()
        ],
      ),
    );
  }
}
