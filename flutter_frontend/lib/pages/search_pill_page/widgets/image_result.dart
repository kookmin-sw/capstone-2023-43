import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_frontend/service/image_response_service.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../generated/graphql_api.graphql.dart';
import '../../../model/pill_infomation.dart';
import '../../../service/add_pill_service.dart';
import '../../../service/http_response_service.dart';
import '../../pill_infomation_page/pill_infomation.dart';

class ImageResult extends HookConsumerWidget {
  const ImageResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var itemSeqs = ref.read(dioResponseServiceProvider).inference;
    final cnt = useState(0);
    final query = SearchPillListIdsQuery(
        variables: SearchPillListIdsArguments(item_seqs: itemSeqs));

    // TODO: implement build
    return Query(
      options: QueryOptions(
        document: query.document,
        variables: query.variables.toJson(),
      ),
      builder: (result, {fetchMore, refetch}) {
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
                    Text(
                      "이미지 검색결과",
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
                if (result.hasException)
                  Text(result.exception.toString())
                else if (result.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  Expanded(
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
                            itemCount: result.data!['pb_pill_info'].length,
                            itemBuilder: (BuildContext context, int index) {
                              final data = result.data!['pb_pill_info'];
                              return SearchItem(
                                title: data[index]['name'],
                                subTitle: data[index]['class_name'] ?? 'none',
                                company: data[index]['entp_name'],
                                onTap: () {
                                  List<int> items = [];
                                  items.add(data[index]['item_seq']);
                                  if (ref.read(AddPillServiceProvider).stage ==
                                      AddPillState.selectPill) {
                                    for (PillInfomation pill in ref
                                        .read(AddPillServiceProvider)
                                        .pills) {
                                      items.add(pill.itemSeq);
                                    }
                                  }
                                  ref
                                      .read(HttpResponseServiceProvider)
                                      .postValidation(items);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PillInfomationPage(
                                          itemSeq: data[index]['item_seq']),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
