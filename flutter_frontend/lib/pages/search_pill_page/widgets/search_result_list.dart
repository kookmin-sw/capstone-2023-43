import 'package:flutter/material.dart';
import 'package:flutter_frontend/generated/graphql_api.dart';
import 'package:flutter_frontend/pages/search_pill_page/widgets/search_item.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../widgets/base_widget.dart';
import '../../pill_infomation_page/pill_infomation.dart';
import '../dummy_model.dart';

class SearchResultList extends HookWidget {
  final String search;
  const SearchResultList({
    super.key,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController();
    final searchText = useState(search);
    final query = SearchPillListQuery(
        variables:
            SearchPillListArguments(searchName: '%' + searchText.value + '%'));
    return Query(
      options: QueryOptions(
        document: query.document,
        variables: query.variables.toJson(),
      ),
      builder: (result, {fetchMore, refetch}) {
        textController.text = searchText.value;
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
                                searchText.value = textController.text;
                                if (result.hasException &&
                                    searchText.value == textController.text) {
                                  refetch!();
                                }
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PillInfomationPage(
                                                    itemSeq: data[index]
                                                        ['item_seq'])));
                                  },
                                );
                              }),
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
