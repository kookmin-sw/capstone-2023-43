import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/service/add_pill_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddPillPage extends HookConsumerWidget {
  const AddPillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late List<PillInfomation> pills = ref.watch(AddPillServiceProvider).pills;
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
            // 단일 복용약 -> 복수의 복용약으로 변경 필요 컴포넌트 재설계 필수.
            BaseButton(
              text: '여기를 눌러 복용하려는 약 찾기',
              icon: const Icon(Icons.search),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPillPage()));
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pills.length,
                          itemBuilder: (context, index) {
                            return SearchItem(
                              title: pills[index].name,
                              subTitle: pills[index].className,
                              company: pills[index].entpName,
                              isSingleContent: pills.length == 1 ? true : false,
                            );
                          },
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
          ],
        ),
      )),
    );
  }
}
