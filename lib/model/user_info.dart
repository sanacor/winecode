import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class UserInfo {
  String userName;

  UserInfo(this.userName);

  UserInfo.fromJson(Map<String, dynamic> json)
      : userName = json['userName'];


  Map<String, dynamic> toJson() =>
      {
        'userName': userName
      };
}
