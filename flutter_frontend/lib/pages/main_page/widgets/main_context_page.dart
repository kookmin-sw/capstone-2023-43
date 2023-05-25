import 'package:flutter/material.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/base_button.dart';
import '../../calender_page/calender_page.dart';
import '../../search_pill_page/search_pill_page.dart';

class MainContextPage extends HookConsumerWidget {
  const MainContextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      expandedHeight: (200.w) + 50,
      backgroundColor: const Color.fromRGBO(11, 106, 227, 1),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          alignment: Alignment.bottomCenter,
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
                  onTap: () async {
                    if (ref.read(HttpResponseServiceProvider).stage ==
                        ResposeStage.loading) return;

                    await ref
                        .read(HttpResponseServiceProvider)
                        .getWholeHistory();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalenderPage()),
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
                    Navigator.pushNamed(context, '/add');
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
