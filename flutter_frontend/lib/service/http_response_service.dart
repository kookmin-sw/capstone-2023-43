import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/schdule_data.dart';

enum ResposeStage { notready, ready, loading, finish, error }

//서비스 스켈레톤 코드 -> url 및 동작 도큐멘테이션을 받는대로 데이터 생성
class HttpResponseService extends ChangeNotifier {
  late final url = 'url을 여기에...';
  late var OauthToken;
  late List<SchduleData> data;
  ResposeStage stage = ResposeStage.notready;

  HttpResponseService();

  void initResponse() {
    //response 에 필요한 코드 작성...

    stage = ResposeStage.ready;
    notifyListeners();
  }

  // fetch -> 서버에서 복용기록을 가져옴.
  void fetch() {}

  // fetchMore -> 추가적으로 서버에서 데이터를 더 가져옴. pagnation 관련 기능
  void fetchMore() {}

  // postData -> 데이터를 서버로 보냄.
  void postData() {}

  // updateData -> 이미 있는 데이터를 업데이트함.
  void updateData() {}

  // deleteData -> 데이터 고로시.
  void deleteData() {}
}

// final HttpResponseServiceProvider =
//     ChangeNotifierProvider<HttpResponseService>((ref) => HttpResponseService());
