import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_result_list.dart';
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
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) {
                          print(textController.text);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchResultList(
                                        search: textController.text,
                                      )));
                        },
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
                            print(textController.text);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchResultList(
                                          search: textController.text,
                                        )));
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
            const Text('not searched'),
          ],
        ),
      ),
    );
  }
}
