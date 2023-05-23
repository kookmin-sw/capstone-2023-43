import 'package:flutter/material.dart';
import 'package:flutter_frontend/generated/graphql_api.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/sub_page/more_inoformation.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/widgets/case_take_view.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/widgets/prohibit_take_view.dart';
import 'package:flutter_frontend/service/add_pill_service.dart';
import 'package:flutter_frontend/service/http_response_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/pill_infomation.dart';
import '../../widgets/base_button.dart';
import '../../widgets/base_item.dart';

class PillInfomationContext extends HookConsumerWidget {
  final int itemSeq;
  const PillInfomationContext({super.key, required this.itemSeq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var valData = ref.watch(HttpResponseServiceProvider).valData;
    final query = PillInfomationQuery(
        variables: PillInfomationArguments(itemSeq: itemSeq));
    return Query(
      options: QueryOptions(
        document: query.document,
        variables: query.variables.toJson(),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) return Text(result.exception.toString());
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var data = result.data!['pb_pill_info_by_pk'];
        print(data["image_url"]);

        return Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 200.h,
              // width: 100.w,
              //color: Colors.grey,
              child: data["image_url"].contains("https://")
                  ? Image.network(
                      data["image_url"],
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.h),
                          color: Colors.amber,
                        ),
                        child: Center(
                            child: Text(
                          "이미지가 제공되지 않는 페이지 입니다!",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.white),
                        )),
                      ),
                    ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${result.data!['pb_pill_info_by_pk']['name']}',
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      Text(
                        '${result.data!['pb_pill_info_by_pk']['entp_name']}',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                ref.read(AddPillServiceProvider).stage ==
                        AddPillState.selectPill
                    ? BaseButton(
                        text: '약 추가',
                        color: Colors.amber,
                        icon: Icon(
                          Icons.medication,
                          size: 18.w,
                        ),
                        onTap: () {
                          ref
                              .read(AddPillServiceProvider)
                              .addPill(PillInfomation(
                                itemSeq: data['item_seq'] ?? 'none',
                                className: data['clss_name'] ?? 'none',
                                entpName: data['entp_name'] ?? 'none',
                                etcOtcCode: data['etc_otc_code'] ?? 'none',
                                imageUrl: data['image_url'] ?? 'none',
                                name: data['name'] ?? 'none',
                              ));
                          Navigator.popUntil(
                              context, ModalRoute.withName('/add'));
                        },
                      )
                    : Spacer(),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            // 복용금지 뷰
            valData.isNotEmpty
                ? ProhibitTakeView(
                    status: valData["result"],
                    pills: valData["mix_taboos"],
                  )
                : Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15.h)),
                  ),
            SizedBox(
              height: 20.h,
            ),
            // 복용주의 뷰
            valData.isNotEmpty
                ? CaseTakeView(
                    status: valData["result"],
                    pills: valData["taboo_case"],
                  )
                : Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15.h)),
                  ),
            SizedBox(
              height: 20.h,
            ),
            // 복용 정보 use_method 뷰 띄어주기
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (buildContext) {
                  return MoreInformation();
                }));
                ref
                    .read(HttpResponseServiceProvider)
                    .getDetailHtml(data['item_seq']);
              },
              child: BaseItem(
                child: Stack(
                  children: [
                    Text(
                      "복용시 주의사항",
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w700),
                    ),
                    Align(
                      alignment: Alignment(1, 0),
                      child: Icon(Icons.arrow_right),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
