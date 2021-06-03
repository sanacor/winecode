import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class InquiryInfo {
  String wineName;
  String wineCompany;
  List<String> wineShops;
  String inqContents;
  String inqImgUrl;

  InquiryInfo({this.wineName, this.inqContents, this.wineCompany, this.wineShops, this.inqImgUrl});

  InquiryInfo.fromJson(Map<String, dynamic> json)
      : wineName = json['wineName'],
        wineCompany = json['wineCompany'],
        wineShops = json['shops'],
        inqContents = json['inqContents'],
        inqImgUrl = json['inqImgUrl'];


  Map<String, dynamic> toJson() =>
      {
        'wineName': wineName,
        'wineCompany' : wineCompany,
        'shops': wineShops,
        'inqContents': inqContents,
        'inqImgUrl' : inqImgUrl
      };
}


