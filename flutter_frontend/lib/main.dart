import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/add_pill_page/add_pill_page.dart';
import 'package:flutter_frontend/pages/main_page/main_page.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_frontend/service/grapgql_config.dart';
import 'package:flutter_frontend/service/pb_graph_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

PbGraphQlClient gq = PbGraphQlClient();
void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 860),
      builder: (BuildContext context, Widget? child) {
        return GraphQLProvider(
          client: GraphQLConfig.initCLient(),
          child: MaterialApp(
            title: 'Flutter Demo',
            routes: {
              '/search': (context) => const SearchPillPage(),
              '/add': (context) => const AddPillPage(),
            },
            theme: ThemeData(
                fontFamily: 'NotoSansKR',
                scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1)),
            home: const MainPage(),
          ),
        );
      },
    );
  }
}
