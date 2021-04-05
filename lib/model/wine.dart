import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Wine {
  String wineName;
  String wineImageURL;

  Wine(this.wineName, this.wineImageURL);

  factory Wine.fromJson(Map<String, dynamic> json) { return Wine(json['wineName'], json['wineImage']); }


}

class PostViewModel {
  String url = "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/product/search/";

  Future<List<Wine>> searchByKeyword([String search_keyword = ""]) async {
    if (search_keyword == "") {
      return [];
    }

    
    
    final response = await http.get(this.url + search_keyword);
    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);

      print(responseJson);

      return responseJson.map((post) => new Wine.fromJson(post)).toList(); }
    else {
      throw Exception('Failed to load post'); }
  }
}




