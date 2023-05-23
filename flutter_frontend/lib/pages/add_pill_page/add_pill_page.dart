import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_frontend/pages/main_page/widgets/toggle_button.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/service/add_pill_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPillPage extends HookConsumerWidget {
  const AddPillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late PillInfomation pill = ref.watch(AddPillServiceProvider).pill;
    bool isSearched = ref.watch(AddPillServiceProvider).isSearched;

    return BaseWidget(
      body: Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 28.w,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "먹고있는 약 추가하기",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            BaseButton(
              text: '여기를 눌러 복용하려는 약 찾기',
              icon: const Icon(Icons.search),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPillPage()));
                ref.read(AddPillServiceProvider).addPill(PillInfomation(
                    name: 'dummy',
                    entpName: 'dummy Company',
                    etcOtcCode: 1122,
                    className: 'dummy',
                    imageUrl: 'none'));
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: 25.w,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: isSearched
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SearchItem(
                          title: pill.name,
                          subTitle: pill.className,
                          company: pill.entpName,
                          isSingleContent: true,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 75.h,
                      child: const Center(
                        child: Text(
                          "복용 하고자 하는 약을 스케쥴에 올려  편리하게 관리하세요!",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xffd2d2d2)),
                        ),
                      )),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                const Text(
                  "복용기간",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50.h,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 50.h,
                      color: Colors.grey,
                    )),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Text(
                  "복용시간",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50.h,
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Container(
                      height: 50.h,
                      color: Colors.grey,
                    )),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50.h,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "복용 주기",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            ToggleButton(
              width: 300.w,
              firstName: "요일",
              secondName: "주기",
              onTapFirst: () {},
              onTapSecond: () {},
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              color: Colors.blueGrey,
              height: 100,
            )
          ],
        ),
      )),
    );
  }
}
