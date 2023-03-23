import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_frontend/pages/main_page/widgets/progress_item.dart';
import 'package:flutter_frontend/pages/main_page/widgets/schedule_item.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 나중에 서비스가 생성되면 HookWidget 에서 HookConsumerWidget으로 변경 필요.
class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 175,
            backgroundColor: const Color.fromRGBO(11, 106, 227, 1),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  color: Color(0x0B6AE3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseButton(
                        icon: const Icon(Icons.calendar_month),
                        text: '달력보기',
                        onTap: () => print('clicked!'),
                      ),
                      const SizedBox(width: 20),
                      BaseButton(
                        icon: const Icon(Icons.add),
                        text: '먹고있는 약 추가하기',
                        onTap: () => print('clicked!'),
                      ),
                      const SizedBox(width: 20),
                      BaseButton(
                        icon: const Icon(Icons.search),
                        text: '약 검색하기',
                        onTap: () => print('clicked!'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('PillBox'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                width: double.maxFinite,
                height: 30,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => index == 0
                    ? const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ProgressItem(),
                      )
                    : const Padding(
                        padding:
                            EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: BaseItem(child: Text("picker_Item")),
                      ),
                childCount: 2,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  // message 구현을 위한 모델 필요 -> isMessage?
                  (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ScheduleItem(
                          status: '복약 완료',
                          time: '${index + 8}:00',
                        ),
                      ),
                  childCount: 4),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 50),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  // message 구현을 위한 모델 필요 -> isMessage?
                  (context, index) => index == 0
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Center(
                            child: Text(
                              '오늘도 열심히 드시고 계시네요! 💪 ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(165, 165, 165, 1),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
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
