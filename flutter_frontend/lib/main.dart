import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/add_pill_page/add_pill_page.dart';
import 'package:flutter_frontend/pages/main_page/main_page.dart';
import 'package:flutter_frontend/pages/main_page/widgets/pill_infomation.dart';
import 'package:flutter_frontend/pages/search_pill_page/search_pill_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(500, 860),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Flutter Demo',
          initialRoute: '/',
          theme: ThemeData(
              fontFamily: 'NotoSansKR',
              scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1)),
          home: const MainPage(),
        );
      },
    );
  }
}
