import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/image_result.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_result_list.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_frontend/service/image_response_service.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_page.dart';
import 'image_crop.dart';

class SearchPillPage extends HookConsumerWidget {
  const SearchPillPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSearched = useState(false);
    final textController = useTextEditingController(text: '');
    final picker = ImagePicker();
    var photos = useState(<File>[]);

    return BaseWidget(
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                                ),
                              ),
                            );
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
            GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                              cameras:
                                  ref.read(HttpResponseServiceProvider).cameras,
                              aftertake: (XFile value) async {
                                if (value == null) return;
                                final length = await value.length() / 1024;
                                log('Picked File Size in KB $length');
                                await cropAndResizeFile(
                                  file: File(value.path),
                                  aspectRatio: 1,
                                  width: 224,
                                  quality: 100,
                                ).then((val) async {
                                  final length = await val.length() / 1024;
                                  ref
                                      .read(dioResponseServiceProvider)
                                      .initDio(val);
                                  photos.value = [File(val.path)];
                                });

                                await ref
                                    .read(dioResponseServiceProvider)
                                    .requestDio()
                                    .then((value) {
                                  Navigator.pop(context);
                                });
                              },
                            )));
                // final img = await picker.pickImage(source: ImageSource.camera);
              },
              child: Container(
                height: 50.h,
                width: 300.h,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(15.h)),
                child: Center(child: Text("카메라를 이용해서 약을 찾아보세요!")),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            photos.value.isEmpty
                ? Text('')
                : Image.file(File(photos.value[0].path)),
            SizedBox(
              height: 20.h,
            ),
            photos.value.isEmpty
                ? SizedBox()
                : BaseButton(
                    text: "이 사진을 이용해서 약 찾아보기!",
                    color: Color.fromRGBO(11, 106, 227, 1),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageResult();
                      }));
                    },
                  )
          ],
        ),
      ),
    );
  }
}
