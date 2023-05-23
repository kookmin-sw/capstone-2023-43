import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/model/pill_take_list.dart';
import 'package:flutter_frontend/model/preset_time.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/schdule_data.dart';
import '../model/user.dart';

enum ResposeStage { notready, ready, loading, finish, error, newUser }

//서비스 스켈레톤 코드 -> url 및 동작 도큐멘테이션을 받는대로 데이터 생성
class HttpResponseService extends ChangeNotifier {
  final url = 'https://g1rj1dd4j1.execute-api.ap-northeast-2.amazonaws.com/dev';
  late String idToken;
  String detailHTML = "";
  List<SchduleData> data = [];
  List<PresetTime> presetTime = [];
  List<PillTakeList> list = [];
  late Map<String, dynamic> valData = {};
  ResposeStage stage = ResposeStage.notready;
  late User user;
  late String errMsg;

  HttpResponseService();

  void setToken(token) {
    idToken = "";
    idToken = token;
  }

  void generateList() {
    list = [];
    for (var t in presetTime) {
      var id = t.id;
      var Templist = data.where((element) => element.presetTimes.contains(id));
      for (var item in Templist) {
        list.add(
            PillTakeList(name: item.name, historyId: item.id, presetId: id));
      }
    }
  }

  // 서비스 초기화... 유저 정보 가져오기.
  Future<void> initResponse() async {
    stage = ResposeStage.loading;
    late Map<String, dynamic> body;
    const endPoint = "/pillbox/users";
    bool isExistUser = true;

    await http.get(
      Uri.parse(url + endPoint),
      headers: {"Authorization": "Bearer " + idToken},
    ).then((response) {
      if (response.statusCode == 200) {
        body = jsonDecode(utf8.decode(response.bodyBytes));
        print(body);
      } else {
        isExistUser = false;
      }

      if (isExistUser == false) {
        print("new user arrived, setting new user!");
        stage = ResposeStage.newUser;
        return;
      }

      //user의 복용정보를 가져온다.
      if (body['data']['pill_histories'] != null) {
        for (var history in body['data']['pill_histories']) {
          data.add(SchduleData.fromMap(history));
        }
      }

      if (body['data']['preset_times'] != null) {
        for (var preset in body['data']['preset_times']) {
          presetTime.add(PresetTime.fromMap(preset));
        }
        print(presetTime);
      }

      generateList();
      //정상적으로 로드 완료;
      stage = ResposeStage.ready;
    });
  }

  Future<void> postNewUser(
    String name,
    String gender,
    DateTime birthday,
    int bloodPressure,
    bool isDiabetes,
    bool isPregnancy,
  ) async {
    user = User(
        name: name,
        gender: gender,
        birthday: birthday,
        bloodPressure: bloodPressure,
        isDiabetes: isDiabetes,
        isPregnancy: isPregnancy);

    const endPoint = "/pillbox/users";

    await http
        .post(
      Uri.parse(url + endPoint),
      headers: {
        HttpHeaders.authorizationHeader: idToken,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: user.toJson(),
    )
        .then((response) {
      if (response.statusCode == 201) {
        stage = ResposeStage.ready;
        print("success to upload new user! aahoy!");
        // 새로운 유저는 데이터X, 따라서 공백의 데이터 리스트를 만들어 준다.
        data = [];
      } else {
        stage = ResposeStage.error;
        print("somthing courred error. response canceled");
      }
    });
  }

  // fetch -> 서버에서 복용기록을 가져옴.
  Future<void> fetch() async {
    const endPoint = "/pillbox/user/pill_histories";
    await http.get(Uri.parse(url + endPoint), headers: {
      HttpHeaders.authorizationHeader: "Bearer " + idToken,
    }).then((response) => {if (response.statusCode == 200) {} else {}});
  }

  // fetchMore -> 추가적으로 서버에서 데이터를 더 가져옴. pagnation 관련 기능
  void fetchMore() {}

  // postData -> 데이터를 서버로 보냄.
  // header 에 'Content-Type' : 'application/json' 꼭 붙히기
  // 웬만한 response는 200으로 오나, 새로 작성한 데이터 같은 경우 201로 온다
  Future<void> postData(SchduleData body) async {
    const endPoint = "/pillbox/users/pill_histories";

    stage = ResposeStage.loading;
    await http
        .post(
      Uri.parse(url + endPoint),
      headers: {
        HttpHeaders.authorizationHeader: idToken,
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: body.toJson(),
    )
        .then((response) {
      if (response.statusCode == 201) {
        print("update complete!");
        stage = ResposeStage.ready;
        data.add(body);
      } else if (response.statusCode == 400) {
        print("something happend!");
        var detail = jsonDecode(utf8.decode(response.bodyBytes));
        errMsg = detail["detail"];
        stage = ResposeStage.error;
      }
    });

    generateList();
    notifyListeners();
  }

  // updateData -> 이미 있는 데이터를 업데이트함.
  // header 에 'Content-Type' : 'application/json' 꼭 붙히기
  // 웬만한 response는 200으로 오나, 새로 작성한 데이터 같은 경우 201로 온다
  void updateData() {}

  // deleteData -> 데이터 고로시.
  void deleteData() {}

  void getDetailHtml(int itemseq) async {
    detailHTML = "";
    notifyListeners();
    const endPoint = "/pillbox/pills/";
    bool isExistUser = true;

    await http.get(
      Uri.parse("$url$endPoint$itemseq"),
      headers: {"Authorization": "Bearer " + idToken},
    ).then((response) {
      if (response.statusCode == 200) {
        detailHTML = response.body;
      } else {}
    });

    notifyListeners();
  }

  Future<void> postValidation(List<dynamic> itemSeqs) async {
    valData = {};
    var startDate = DateTime.now();
    var endDate = startDate.add(Duration(days: 1));
    var reqData = {
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "pills": itemSeqs
    };
    print(json.encode(reqData));
    const endPoint = "/pillbox/users/validation";
    await http
        .post(Uri.parse(url + endPoint),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + idToken,
              HttpHeaders.contentTypeHeader: "application/json"
            },
            body: json.encode(reqData))
        .then((response) {
      if (response.statusCode == 200) {
        var body = jsonDecode(utf8.decode(response.bodyBytes));
        valData = Map.from(body);
        notifyListeners();
      }
    });
  }
}

final HttpResponseServiceProvider =
    ChangeNotifierProvider<HttpResponseService>((ref) => HttpResponseService());
