import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/schdule_data.dart';

enum ResposeStage { notready, ready, loading, finish, error }

//서비스 스켈레톤 코드 -> url 및 동작 도큐멘테이션을 받는대로 데이터 생성
class HttpResponseService extends ChangeNotifier {
  final url = 'https://g1rj1dd4j1.execute-api.ap-northeast-2.amazonaws.com/dev';
  late String token;
  late List<SchduleData> data;
  ResposeStage stage = ResposeStage.notready;
  late Map<String, dynamic> user;

  HttpResponseService();
  void setToken(_token) {
    token = _token;
  }

  // 서비스 초기화... 유저 정보 가져오기.
  void initResponse(auth) async {
    const endPoint = "endpoint";
    final response = await http.get(
      Uri.parse(url + endPoint),
      headers: {HttpHeaders.authorizationHeader: token},
    );

    //리스폰스 statue에 따른 처리
    // 웬만한 response는 200으로 옴 -> body에 따른 데이터 처리 필요
    if (response.statusCode == 200) {
      user = jsonDecode(response.body);
    } else {
      stage = ResposeStage.error;
      notifyListeners();
      return;
    }

    //user의 복용정보를 가져온다.
    user['pill_histories']
        .foreach((history) => data.add(SchduleData.fromMap(history)));

    //정상적으로 로드 완료;
    stage = ResposeStage.ready;
    notifyListeners();

    //response 에 필요한 코드 작성...
  }

  // fetch -> 서버에서 복용기록을 가져옴.
  void fetch() async {
    const endPoint = "endpoint";
  }

  // fetchMore -> 추가적으로 서버에서 데이터를 더 가져옴. pagnation 관련 기능
  void fetchMore() {}

  // postData -> 데이터를 서버로 보냄.
  // header 에 'Content-Type' : 'application/json' 꼭 붙히기
  // 웬만한 response는 200으로 오나, 새로 작성한 데이터 같은 경우 201로 온다
  void postData() {}

  // updateData -> 이미 있는 데이터를 업데이트함.
  // header 에 'Content-Type' : 'application/json' 꼭 붙히기
  // 웬만한 response는 200으로 오나, 새로 작성한 데이터 같은 경우 201로 온다
  void updateData() {}

  // deleteData -> 데이터 고로시.
  void deleteData() {}
}

final HttpResponseServiceProvider =
    ChangeNotifierProvider<HttpResponseService>((ref) => HttpResponseService());
