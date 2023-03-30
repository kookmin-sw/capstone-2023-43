import 'package:flutter/material.dart';
import 'package:flutter_frontend/generated/graphql_api.graphql.dart';
import 'package:flutter_frontend/pages/pill_infomation_page/pill_infomation_context.dart';
import 'package:flutter_frontend/widgets/base_button.dart';
import 'package:flutter_frontend/widgets/base_item.dart';
import 'package:flutter_frontend/widgets/base_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PillInfomationPage extends HookWidget {
  final String itemSeq;
  const PillInfomationPage({
    required this.itemSeq,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final query = PillInfomationQuery(
        variables: PillInfomationArguments(itemSeq: itemSeq));
    return BaseWidget(
      body: SingleChildScrollView(
        child: Query(
          options: QueryOptions(
            document: query.document,
            variables: query.variables.toJson(),
          ),
          builder: (result, {fetchMore, refetch}) {
            return Center(
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
                          "약 정보",
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                    if (result.isLoading)
                      CircularProgressIndicator()
                    else if (result.hasException)
                      Text(result.exception.toString())
                    else
                      PillInfomationContext(
                        name: result.data!['pb_pill_info']['name'],
                        entpName: result.data!['pb_pill_info']['entp_name'],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
