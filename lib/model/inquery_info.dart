import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class InquiryInfo {
  String wineName;
  String wineCompany;
  List<String> wineShops;

  InquiryInfo(this.wineName, this.wineCompany, this.wineShops);

  InquiryInfo.fromJson(Map<String, dynamic> json)
      : wineName = json['wineName'],
        wineCompany = json['wineCompany'],
        wineShops = json['shops'];

  Map<String, dynamic> toJson() =>
      {
        'wineName': wineName,
        'wineCompany' : wineCompany,
        'shops': wineShops,
      };
}


