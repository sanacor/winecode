import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class InqueryInfo {
  String wineName;
  List<String> wineShops;

  InqueryInfo(this.wineName, this.wineShops);

  InqueryInfo.fromJson(Map<String, dynamic> json)
      : wineName = json['wineName'],
        wineShops = json['shops'];

  Map<String, dynamic> toJson() =>
      {
        'wineName': wineName,
        'shops': wineShops,
      };
}


