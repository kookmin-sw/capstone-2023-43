import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/add_pill_page/add_pill_page.dart';
import 'package:flutter_frontend/pages/login_page/login_page.dart';
import 'package:flutter_frontend/pages/main_page/main_page.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_frontend/service/grapgql_config.dart';
import 'package:flutter_frontend/service/pb_graph_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_frontend/amplifyconfiguration.dart';

PbGraphQlClient gq = PbGraphQlClient();
void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configure();
  }

  void _configure() async {
    final auth = AmplifyAuthCognito();

    try {
      Amplify.addPlugins([auth]);
      await Amplify.configure(amplifyconfig);
      print('Successfully configured Amplify 🎉');
    } catch (e) {
      print(e);
    }
  }

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
              '/main': (context) => const MainPage(),
            },
            theme: ThemeData(
                fontFamily: 'NotoSansKR',
                scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1)),
            home: const ProviderScope(child: LoginPage()),
          ),
        );
      },
    );
  }
}
