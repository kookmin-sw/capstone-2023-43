import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/main_page/widgets/main_context_page.dart';
import 'package:flutter_frontend/pages/main_page/widgets/progress_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/schedule_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/toggle_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 나중에 서비스가 생성되면 HookWidget 에서 HookConsumerWidget으로 변경 필요.
class MainPage extends HookWidget {
  const MainPage({super.key});

  Widget? getToggleSwitch(
    context,
    index,
  ) {
    return index == 0
        ? Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ProgressItem(),
          )
        : Padding(
            padding: EdgeInsets.only(bottom: 20.h, left: 20.w, right: 20.w),
            child: ToggleButton(
              width: 350.w,
              firstName: '오늘 일정',
              secondName: '내일 일정',
              onTapFirst: () {},
              onTapSecond: () {},
            ),
          );
  }

  Widget? listTakeList(
    context,
    index,
    itemList, [
    Function(DismissDirection)? onDismissed,
  ]) {
    return onDismissed != null
        ? Dismissible(
            key: UniqueKey(),
            onDismissed: onDismissed,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: ScheduleItem(
                status: '복약 예정',
                time: '${itemList.value[index]}:00',
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ScheduleItem(
              status: '복약 완료',
              time: '${itemList.value[index - 1]}:00',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final itemsBefore = useState(List<int>.generate(3, (i) => i + 6));
    final itemsAfter = useState(List<int>.generate(4, (i) => i + 1));
    return BaseWidget(
      body: CustomScrollView(
        slivers: [
          // 앱바 -> MainContextPage 로 정리
          const MainContextPage(),
          // 패딩 -> 실버 리스트 -> 빌더보다는 동시에 빌드되는 children으로 바꾸는게 편할듯
          SliverPadding(
            padding: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => getToggleSwitch(context, index),
                childCount: 2,
              ),
            ),
          ),

          // 약 복용 리스트
          SliverPadding(
            padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      listTakeList(context, index, itemsBefore, (Direction) {
                        itemsAfter.value = [
                          ...itemsAfter.value,
                          itemsBefore.value[index]
                        ]..sort();

                        itemsBefore.value = [
                          ...itemsBefore.value..removeAt(index)
                        ];
                      }),
                  childCount: itemsBefore.value.length),
            ),
          ),

          // 약 복용후 리스트
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
                      : listTakeList(context, index, itemsAfter),
                  childCount: itemsAfter.value.length + 1),
            ),
          ),
        ],
      ),
    );
  }
}