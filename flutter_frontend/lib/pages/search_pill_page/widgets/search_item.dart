import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final String subTitle;
  final String company;
  final Function()? onTap;
  final bool isSingleContent;

  const SearchItem(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.company,
      this.onTap,
      this.isSingleContent = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          isSingleContent ? null : EdgeInsets.fromLTRB(0, 0, 0, 10.h),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subTitle),
          Text(
            company,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
      trailing: Container(
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(4.0.w),
          child: Text(
            'pill',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
