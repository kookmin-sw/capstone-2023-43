import 'package:flutter/material.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../widgets/base_widget.dart';

class MoreInformation extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var detailedHtml = ref.watch(HttpResponseServiceProvider).detailHTML;
    return BaseWidget(
      body: SingleChildScrollView(
          child: Center(
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
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "복용 시 주의사항",
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              detailedHtml != ''
                  ? Html(
                      shrinkWrap: true,
                      data: detailedHtml,
                    )
                  : CircularProgressIndicator()
            ],
          ),
        ),
      )),
    );
  }
}
