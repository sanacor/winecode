import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;

var BACK_END_HOST =
    'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/';

Future<dynamic> http_get({header, String path}) async {
  final storage = FlutterSecureStorage();
  String jwt = await storage.read(key: 'jwt');
  var url = BACK_END_HOST + path;

  print('JWT $jwt');
  print(BACK_END_HOST + path);

  try {
    var response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "X-AUTH-TOKEN": jwt
    });

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      return responseJson;
    } else {
      throw Exception('Failed to HTTP GET');
    }
  } catch (ex) {
    print(ex);
  }
}

// 추가 구현 필요
Future<dynamic> http_post(
    {header, String path, Map<String, dynamic> body}) async {
  final storage = FlutterSecureStorage();
  String jwt = await storage.read(key: 'jwt');

  print(BACK_END_HOST + path);
  print(body);

  var url = BACK_END_HOST + path;
  var response;

  try {
    response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-AUTH-TOKEN": jwt
      },
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print(responseJson);
      return responseJson;
    } else {
      throw Exception('Failed to HTTP POST');
    }
  } catch (ex) {
    print(ex);
  }
}

// 추가 구현 필요
Future<dynamic> http_delete(url, path, header) async {
  final storage = FlutterSecureStorage();
  String jwt = await storage.read(key: 'jwt');

  print(BACK_END_HOST + path);
}
