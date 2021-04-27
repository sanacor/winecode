import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;

var BACK_END_HOST = 'https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/inquiry';


Future<dynamic> http_get({header, String path}) async {
  final storage = FlutterSecureStorage();
  String jwt = await storage.read(key: 'jwt');
  print('JWT Token: $jwt');
  print(BACK_END_HOST+path);

  try {
    var response = await Dio().get(
        BACK_END_HOST,
        // BACK_END_HOST+path,
        options: Options(
          headers: {
            "X-AUTH-TOKEN" : jwt,
          },
        )
    );
    print(response);
    if (response.statusCode == 200) {
      // return response.data;
      return response;

    }

  } catch (e) {
    print(e);
  }
}

// 추가 구현 필요
Future<dynamic> http_post({header, String path, String body}) async {
  try {
    var response = await Dio().post(BACK_END_HOST+path);
    print(response);
    if (response.statusCode == 200) {
      return response.data;

    }

  } catch (e) {
    print(e);
  }
}

// 추가 구현 필요
Future<dynamic> http_delete(url, path, header) async {
  try {
    var response = await Dio().delete(BACK_END_HOST+path);
    print(response);
    if (response.statusCode == 200) {
      return response.data;

    }

  } catch (e) {
    print(e);
  }
}