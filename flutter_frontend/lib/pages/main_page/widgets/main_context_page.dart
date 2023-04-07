import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/base_button.dart';
import '../../add_pill_page/add_pill_page.dart';
import '../../pill_infomation_page/pill_infomation.dart';
import '../../search_pill_page/search_pill_page.dart';

class MainContextPage extends HookWidget {
  const MainContextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: (200.w) + 50,
      backgroundColor: const Color.fromRGBO(11, 106, 227, 1),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          alignment: Alignment.bottomCenter,
          // decoration: const BoxDecoration(
          //   color: Color(0xff0b6ae3),
          // ),
          child: Padding(
            padding: EdgeInsets.only(bottom: 50.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseButton(
                  icon: Icon(
                    Icons.calendar_month,
                    size: 16.w,
                  ),
                  text: '달력보기',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PillInfomationPage(
                          itemSeq: 202005623,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 20.w),
                BaseButton(
                  icon: Icon(
                    Icons.add,
                    size: 16.w,
                  ),
                  text: '먹고있는 약 추가하기',
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPillPage()));
                  },
                ),
                SizedBox(width: 20.w),
                BaseButton(
                    icon: Icon(
                      Icons.search,
                      size: 16.w,
                    ),
                    text: '약 검색하기',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchPillPage()));
                    }),
              ],
            ),
          ),
        ),
      ),
      title: Text(
        'PillBox',
        style: TextStyle(fontSize: 16.w),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.w),
                topRight: Radius.circular(50.w),
              )),
          width: double.maxFinite,
          height: 30.h,
        ),
      ),
    );
  }
}
