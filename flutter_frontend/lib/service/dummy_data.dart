import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';

class DummyData {
  static void loadJson() async {
    final rawData = await rootBundle.loadString('0.json');
    final jsonData = await json.decode(rawData);
  }
}
