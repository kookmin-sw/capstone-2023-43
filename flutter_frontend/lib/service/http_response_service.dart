import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
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
  List<SchduleData> wholedata = [];
  List<PresetTime> presetTime = [];
  List<PillTakeList> list = [];
  List<PillTakeList> daylist = [];
  late Map<String, dynamic> valData = {};
  ResposeStage stage = ResposeStage.notready;
  late User user;
  late String errMsg;
  late List<CameraDescription> cameras;

  HttpResponseService();

  void setToken(token) {
    idToken = "";
    idToken = token;
  }

  int getTodaycnt() {
    int result = 0;
    for (var history in data) {
      result += history.presetTimes.length;
    }
    return result;
  }

  String getTodayKey(Map<String, List<dynamic>> timestamp) {
    final today = DateTime.now();
    String result = "";
    for (var key in timestamp.keys) {
      var date = DateTime.parse(key);

      if (date.year == today.year &&
          date.month == today.month &&
          date.day == today.day) {
        result = key;
        break;
      }
    }

    return result;
  }

  String getKeyByDay(Map<String, List<dynamic>> timestamp, DateTime day) {
    String result = "";
    for (var key in timestamp.keys) {
      var date = DateTime.parse(key);

      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        result = key;
        break;
      }
    }

    return result;
  }

  void generateList() {
    list = [];
    for (var t in presetTime) {
      var id = t.id;
      var Templist = data.where((element) => element.presetTimes.contains(id));

      for (var item in Templist) {
        var today = getTodayKey(item.timeStamp);
        if (today == "") continue;
        if (item.timeStamp[today]!.contains(id) == false) {
          list.add(
              PillTakeList(name: item.name, historyId: item.id, presetId: id));
        }
      }
    }
  }

  void generateListbyDay(DateTime day) {
    daylist = [];
    for (var t in presetTime) {
      var id = t.id;
      var Templist =
          wholedata.where((element) => element.presetTimes.contains(id));

      for (var item in Templist) {
        var today = getKeyByDay(item.timeStamp, day);
        if (today == "") continue;
        if (item.timeStamp[today]!.contains(id) == false) {
          daylist.add(
              PillTakeList(name: item.name, historyId: item.id, presetId: id));
        }
      }
    }
  }

  int checkpillConsume(DateTime day) {
    bool hasNoPillhis = true;
    //var result = <PillTakeList>[];
    for (var t in presetTime) {
      var id = t.id;
      var Templist =
          wholedata.where((element) => element.presetTimes.contains(id));
      for (var item in Templist) {
        var today = getKeyByDay(item.timeStamp, day);
        if (today == "") continue;
        hasNoPillhis = false;
        if (item.timeStamp[today]!.contains(id) == false) {
          return 1;
        }
      }
    }

    if (hasNoPillhis)
      return 0;
    else
      return 2;
  }

  // 서비스 초기화... 유저 정보 가져오기.
  Future<void> initResponse() async {
    stage = ResposeStage.loading;
    late Map<String, dynamic> body;
    const endPoint = "/pillbox/users";
    bool isExistUser = true;
    cameras = await availableCameras();
    await http.get(
      Uri.parse(url + endPoint),
      headers: {"Authorization": "Bearer " + idToken},
    ).then((response) {
      if (response.statusCode == 200) {
        body = jsonDecode(utf8.decode(response.bodyBytes));
        // print(body);
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
        data = [];
        for (var history in body['data']['pill_histories']) {
          data.add(SchduleData.fromMap(history));
        }
      }

      if (body['data']['preset_times'] != null) {
        presetTime = [];
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

  Future<void> postTimePreset(
    String morningDate,
    String lunchDate,
    String dinnerDate,
    String nightDate,
  ) async {
    const endPoint = "/pillbox/users/preset_times";

    List<Map<String, String>> listPreset = [
      {"name": "아침", "time": morningDate},
      {"name": "점심", "time": lunchDate},
      {"name": "저녁", "time": dinnerDate},
      {"name": "자기전", "time": nightDate},
    ];

    for (Map<String, String> preset in listPreset) {
      stage = ResposeStage.loading;
      await http
          .post(
        Uri.parse(url + endPoint),
        headers: {
          HttpHeaders.authorizationHeader: idToken,
          HttpHeaders.contentTypeHeader: "application/json"
        },
        body: json.encode(preset),
      )
          .then((response) {
        if (response.statusCode != 201) {
          stage = ResposeStage.error;
          print("somthing courred error. response canceled");
          return;
        }
      });
    }

    stage = ResposeStage.loading;
    await http.get(
      Uri.parse(url + endPoint),
      headers: {
        HttpHeaders.authorizationHeader: idToken,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var body = json.decode(utf8.decode(response.bodyBytes));
        print(presetTime);
        if (body != null) {
          for (var preset in body["data"]) {
            presetTime.add(PresetTime.fromMap(preset));
          }
        }
      } else {
        stage = ResposeStage.error;
        print("somthing courred error. response canceled");
        return;
      }
    });

    print(presetTime);
    stage = ResposeStage.ready;
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
        .then((response) async {
      if (response.statusCode == 201) {
        log("upload!");

        await http.get(
          Uri.parse(url + endPoint),
          headers: {
            HttpHeaders.authorizationHeader: idToken,
          },
        ).then((response) {
          if (response.statusCode == 200) {
            data.clear();
            final body = json.decode(utf8.decode(response.bodyBytes));
            if (body['data'] != null) {
              for (var history in body['data']) {
                data.add(SchduleData.fromMap(history));
              }
            }
            log("update coomplete!");
            stage = ResposeStage.ready;
          }
        });
      } else if (response.statusCode == 400) {
        log("something happend!");
        var detail = jsonDecode(utf8.decode(response.bodyBytes));
        errMsg = detail["detail"];
        stage = ResposeStage.error;
        return;
      }
    });

    generateList();
    notifyListeners();
  }

  Future<void> getWholeHistory() async {
    const endPoint = "/pillbox/users/pill_histories?ended_histories=true";
    stage = ResposeStage.loading;
    await http.get(
      Uri.parse(url + endPoint),
      headers: {
        HttpHeaders.authorizationHeader: idToken,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        if (body['data'] != null) {
          wholedata.clear();
          for (var history in body['data']) {
            wholedata.add(SchduleData.fromMap(history));
          }
          stage = ResposeStage.ready;
        }
      }
    });
  }

  // updateData -> 이미 있는 데이터를 업데이트함.
  // header 에 'Content-Type' : 'application/json' 꼭 붙히기
  // 웬만한 response는 200으로 오나, 새로 작성한 데이터 같은 경우 201로 온다
  void updateData(int index) async {
    final endPoint =
        "/pillbox/users/pill_histories/${list[index].historyId}/timestamps";

    Map<String, String> request = {
      "date_key": "",
      "preset_time_id": list[index].presetId,
    };

    final targetHistory =
        data.where((element) => element.id == list[index].historyId);

    final timestamp = targetHistory.first.timeStamp;
    request["date_key"] = getTodayKey(timestamp);

    await http
        .post(Uri.parse(url + endPoint),
            headers: {
              HttpHeaders.authorizationHeader: idToken,
              HttpHeaders.contentTypeHeader: "application/json"
            },
            body: json.encode(request))
        .then((response) {
      if (response.statusCode == 200) {
        log("update success");
        data
            .where((element) => element.id == list[index].historyId)
            .first
            .timeStamp[request["date_key"]]
            ?.add(request["preset_time_id"]);

        log("${data.where((element) => element.id == list[index].historyId).first}");
        generateList();
        notifyListeners();
      } else {
        log("fail request! ${response.statusCode}");
      }
    });
  }

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
