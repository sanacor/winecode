import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;

var BACK_END_HOST = 'https://api.winefi.site/';
// var BACK_END_HOST = 'http://192.168.0.9:8080/';

// var BACK_END_HOST =
//     'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/';

Future<dynamic> http_get({header, String? path}) async {
  final storage = FlutterSecureStorage();
  String? jwt = await storage.read(key: 'access_token');

  var url = BACK_END_HOST + path!;

  print('JWT $jwt');
  print(BACK_END_HOST + path);

  var response;

  try {
    response = await http.get(Uri.parse(Uri.encodeFull(url)), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + jwt!
    });

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print(responseJson);
      return responseJson;
    } else {
      var responseCode = _getResponseCode(responseJson);
      if (responseCode == null) throw Exception("Failed to HTTP GET");

      if (responseCode == -9999) {
        //이미 가입된 회원
        return responseJson;
      } else if (responseCode == -9998) {
        //만료된 Access Token
        print("만료된 Access Token");
        if (await _reissueAccessToken())
          return await http_get(header: header, path: path);
        else
          return responseJson;
      } else if (responseCode == -9997) {
        //TODO 만료된 Refresh Token(아예 로그아웃 처리)
        return responseJson;
      } else if (responseCode == -1008) {
        print("No Result!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        return responseJson;
      } else {
        throw Exception('Failed to HTTP GET(2)');
      }
    }
  } catch (ex) {
    print(ex);
  }
}

Future<dynamic> http_post(
    {header, String? path, Map<String, dynamic>? body}) async {
  final storage = FlutterSecureStorage();
  String? jwt = await storage.read(key: 'access_token');

  print(BACK_END_HOST + path!);
  print('JWT $jwt');
  print(body);

  var url = BACK_END_HOST + path;
  String expiredTokenUrl = BACK_END_HOST + "exception/expiredtoken";
  var response;

  try {
    if (jwt == null) {
      response = await http.post(
        Uri.parse(Uri.encodeFull(url)),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          //Authorization 헤더가 있는 경우 Spring Security에서 무조건 검증하기 때문에 포함하면 안됨
          //signin, signup할 때 post사용하므로 꼭 필요한 코드
        },
        body: convert.jsonEncode(body),
      );
    } else {
      response = await http.post(
        Uri.parse(Uri.encodeFull(url)),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwt,
        },
        body: convert.jsonEncode(body),
      );
    }

    print(response.headers['location'].toString());
    if (response.body.isNotEmpty && response.statusCode == 200) {
      //Response가 비어있지 않고 정상응답인 경우
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      return responseJson;
    } else if (!response.body.isNotEmpty &&
        response.statusCode == 302 &&
        response.headers['location'].toString() == expiredTokenUrl) {
      // HTTP 라이브러리에서 HTTP POST가 redirect 되는 경우 302 응답을 받음(Postman이나 Swagger에서는 발생하지 않는 문제)
      // 302 응답을 받는 경우 response body는 비어있어서 URL과 응답코드로 액세스 토큰 만료 여부를 판단
      if (await _reissueAccessToken()) {
        //AccessToken 재발급
        return await http_post(
            header: header, path: path, body: body); //HTTP POST 재시도
      }
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      var responseCode = _getResponseCode(responseJson);
      if (responseCode == null) throw Exception("Failed to HTTP POST");
      if (responseCode == -9999) {
        //이미 가입된 회원
        return responseJson;
      } else if (responseCode == -9997) {
        //TODO 만료된 Refresh Token(아예 로그아웃 처리)
        return responseJson;
      } else {
        throw Exception("Failed to HTTP POST(2)");
      }
    }
  } catch (ex) {
    print(ex);
  }
}

dynamic _getResponseCode(dynamic responseJson) {
  var responseCode = responseJson['code'];
  if (responseCode != null) {
    return responseCode;
  } else {
    return null;
  }
}

Future<bool> _reissueAccessToken() async {
  final storage = FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'access_token');
  String? refreshToken = await storage.read(key: 'refresh_token');

  var url = BACK_END_HOST + 'api/token/refresh?refreshToken=' + refreshToken!;

  print(url);

  var response;

  try {
    response = await http.get(
      Uri.parse(Uri.encodeFull(url)),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + accessToken!
      },
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      print(responseJson);
      await storage.write(
          key: "access_token", value: responseJson['data']['access_token']);
      return true;
    } else {
      return false;
    }
  } catch (ex) {
    print(ex);
    return false;
  }
}

// 추가 구현 필요
Future<dynamic> http_delete(url, path, header) async {
  final storage = FlutterSecureStorage();
  String? jwt = await storage.read(key: 'access_token');

  print(BACK_END_HOST + path);
}

Future<List<String>?> getUserRoles() async {
  var response = await http_get(header: null, path: 'api/user');

  print(response);

  final res = (response['data']['user']['roles'] as List)
      ?.map((e) => e as String)
      ?.toList();

  return res;
}

Future<String?> getNickname() async {
  var response = await http_get(header: null, path: 'api/user');

  print(response['data']['profile']['uspNickname']);

  return response['data']['profile']['uspNickname'];
}
