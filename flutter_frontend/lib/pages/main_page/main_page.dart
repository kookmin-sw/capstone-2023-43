import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/schdule_data.dart';
import 'package:flutter_frontend/pages/main_page/widgets/main_context_page.dart';
import 'package:flutter_frontend/pages/main_page/widgets/progress_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/schedule_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/toggle_button.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 나중에 서비스가 생성되면 HookWidget 에서 HookConsumerWidget으로 변경 필요.
class MainPage extends HookConsumerWidget {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(HttpResponseServiceProvider).list;
    var presetTime = ref.watch(HttpResponseServiceProvider).presetTime;
    var data = ref.watch(HttpResponseServiceProvider).data;
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
                (context, index) {
                  var time = presetTime
                      .where((element) => element.id == list[index].presetId);
                  var his = data
                      .where((element) => element.id == list[index].historyId);
                  return Dismissible(
                    key: UniqueKey(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ScheduleItem(
                        cnt: his.first.pills.length,
                        status: list[index].name,
                        time: time.first.name,
                        date: time.first.time,
                      ),
                    ),
                  );
                },
                childCount: list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
