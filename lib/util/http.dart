import 'package:dio/dio.dart';

var BACK_END_HOST = 'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/';


Future<dynamic> http_get({header, String path}) async {
  try {
    var response = await Dio().get(BACK_END_HOST+path);
    print(response);
    if (response.statusCode == 200) {
      return response.data;

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