import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPillService extends ChangeNotifier {
  late PillInfomation pill;
  bool isSearched = false;

  void addPill(PillInfomation item) {
    pill = PillInfomation.fromMap(item.toMap());
    isSearched = true;
    notifyListeners();
  }

  void initState() {
    isSearched = false;
  }
}

final AddPillServiceProvider =
    ChangeNotifierProvider<AddPillService>((ref) => AddPillService());
