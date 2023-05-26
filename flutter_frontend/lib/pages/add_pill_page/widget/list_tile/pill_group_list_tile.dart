import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PillGroupListItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String company;
  final int index;

  const PillGroupListItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.company,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      minLeadingWidth: 10.w,
      leading: Text(
        "$index",
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
      ),
      title: Text(
        title,
        maxLines: 1,
        style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            overflow: TextOverflow.ellipsis),
      ),
      subtitle: Text(
        company,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16.sp,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
