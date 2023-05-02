import 'package:flutter/material.dart';
import 'package:flutter_frontend/generated/graphql_api.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/widgets/case_take_view.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/widgets/prohibit_take_view.dart';
import 'package:flutter_frontend/service/add_pill_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../model/pill_infomation.dart';
import '../../widgets/base_button.dart';
import '../../widgets/base_item.dart';

class PillInfomationContext extends HookConsumerWidget {
  final int itemSeq;
  const PillInfomationContext({super.key, required this.itemSeq});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 100.w,
              width: 100.w,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${result.data!['pb_pill_info_by_pk']['name']}',
                        style: TextStyle(
                            fontSize: 24.sp, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${result.data!['pb_pill_info_by_pk']['entp_name']}',
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                BaseButton(
                  text: '약 추가',
                  color: Colors.amber,
                  icon: Icon(
                    Icons.medication,
                    size: 18.w,
                  ),
                  onTap: () {
                    ref.read(AddPillServiceProvider).addPill(PillInfomation(
                          className: data['clss_name'] ?? 'none',
                          entpName: data['entp_name'] ?? 'none',
                          etcOtcCode: data['etc_otc_code'] ?? 'none',
                          imageUrl: data['image_url'] ?? 'none',
                          name: data['name'] ?? 'none',
                        ));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            // 복용금지 뷰
            ProhibitTakeView(),
            SizedBox(
              height: 20.h,
            ),
            // 복용주의 뷰
            CaseTakeView(),
            SizedBox(
              height: 20.h,
            ),
            // 복용 정보 use_method 뷰 띄어주기
            BaseItem(
              child: Html(
                shrinkWrap: true,
                data: data['use_method'],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            // 복용 정보 warning_message 뷰 띄어주기
            BaseItem(
              child: Html(
                shrinkWrap: true,
                data: data['warning_message'],
              ),
            ),
          ],
        );
      },
    );
  }
}
