import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/main_page/main_page.dart';

import 'demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'NotoSansKR',
          scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1)),
      home: const MainPage(),
    );
  }
}
