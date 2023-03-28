import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/search_pill_page/dummy_model.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../pill_infomation_page/pill_infomation.dart';

class SearchPillPage extends HookWidget {
  const SearchPillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isSearched = useState(false);
    final textController = useTextEditingController(text: '');
    final dummySearchItem = [
      for (int i = 0; i < 15; i++)
        DummyModel(
            title: 'title $i', subTitle: 'sub_title $i', company: 'company$i')
    ];

    return BaseWidget(
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 28.sp,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: '먹고있는 약을 입력하세요',
                        ),
                      ),
                      Align(
                        alignment: const Alignment(1, 0),
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            isSearched.value = true;
                            print(textController.text);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            isSearched.value
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '검색결과',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: dummySearchItem.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SearchItem(
                                  title: dummySearchItem[index].title,
                                  subTitle: dummySearchItem[index].subTitle,
                                  company: dummySearchItem[index].company,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PillInfomationPage(
                                                  title: dummySearchItem[index]
                                                      .title,
                                                  company:
                                                      dummySearchItem[index]
                                                          .company,
                                                )));
                                  },
                                );
                              }),
                        ),
                      ],
                    ),
                  )
                : const Text('not searched'),
          ],
        ),
      ),
    );
  }
}
