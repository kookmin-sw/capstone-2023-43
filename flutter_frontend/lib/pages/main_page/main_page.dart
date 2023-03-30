import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_frontend/pages/add_pill_page/add_pill_page.dart';
import 'package:flutter_frontend/pages/main_page/widgets/progress_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/schedule_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/toggle_button.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pill_infomation_page/pill_infomation.dart';
import '../search_pill_page/search_pill_page.dart';

// 나중에 서비스가 생성되면 HookWidget 에서 HookConsumerWidget으로 변경 필요.
class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                              builder: (context) => PillInfomationPage(
                                itemSeq: '1111',
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPillPage()));
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
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => index == 0
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: ProgressItem(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.h, left: 20.w, right: 20.w),
                        child: ToggleButton(
                          width: 350.w,
                          firstName: '오늘 일정',
                          secondName: '내일 일정',
                          onTapFirst: () {},
                          onTapSecond: () {},
                        ),
                      ),
                childCount: 2,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  // message 구현을 위한 모델 필요 -> isMessage?
                  (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: ScheduleItem(
                          status: '복약 완료',
                          time: '${index + 8}:00',
                        ),
                      ),
                  childCount: 4),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(50.w, 10.h, 50.w, 50.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  // message 구현을 위한 모델 필요 -> isMessage?
                  (context, index) => index == 0
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Center(
                            child: Text(
                              '오늘도 열심히 드시고 계시네요! 💪 ',
                              style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(165, 165, 165, 1),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: ScheduleItem(
                            status: '복약 예정',
                            time: '${index + 8}:00',
                          ),
                        ),
                  childCount: 3),
            ),
          ),
        ],
      ),
    );
  }
}
