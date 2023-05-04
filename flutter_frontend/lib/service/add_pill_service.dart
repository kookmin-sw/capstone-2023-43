import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/model/pill_infomation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 서비스에 추가되어야 하는 약 데이터가 변경되어야함
// Pillinformation -> list<PillInfomation>
// 복용약 추가의 내용에서 약의 추가가 약 단일의 것이 아닌 처방전 기준으로 가야하기 때문.
enum AddPillState {
  nonAdd,
  addPill,
  selectPill,
}

class AddPillService extends ChangeNotifier {
  // 5.2 -> pillinformaion 단일 개채 -> 리스트로 교체.
  late List<PillInfomation> pills = [];
  var stage = AddPillState.nonAdd;

  void addPill(PillInfomation item) {
    pills.add(PillInfomation.fromMap(item.toMap()));
    stage = AddPillState.addPill;
    notifyListeners();
  }

  void changeSelectState() {
    stage = AddPillState.selectPill;
  }

  // 서비스 상태 초기화
  // 콜렉션 초기화, isSearched 상태 초기화.
  void initState() {
    pills.clear();
    stage = AddPillState.nonAdd;
    notifyListeners();
  }
}

final AddPillServiceProvider =
    ChangeNotifierProvider<AddPillService>((ref) => AddPillService());
