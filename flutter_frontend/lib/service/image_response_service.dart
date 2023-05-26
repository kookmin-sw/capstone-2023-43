import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_parser/http_parser.dart';

class DioResponseService extends ChangeNotifier {
  final url = 'http://64.110.79.49:8081/inference';
  late final int token;
  late File imageFile;
  List<int> inference = [];
  Dio dio = Dio();

  void initDio(File image) {
    dio.options.contentType = 'multipart/form-data';
    imageFile = File(image.path);
  }

  Future<void> requestDio() async {
    inference = [];
    FormData _formData;

    final MultipartFile _file = MultipartFile.fromFileSync(imageFile.path,
        contentType: MediaType("image", "png"));
    _formData = FormData.fromMap({"image": _file});

    await dio.post(url, data: _formData).then((response) {
      if (response.statusCode == 200) {
        print(response.data);
        for (var data in response.data["item_seqs"]) {
          inference.add(int.parse(data));
        }
      }
    });
  }
}

final dioResponseServiceProvider =
    ChangeNotifierProvider<DioResponseService>((ref) => DioResponseService());
