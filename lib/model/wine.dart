import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wine/util/http.dart';

class Wine {
  String wineName;
  String wineImageURL;

  Wine(this.wineName, this.wineImageURL);

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(json['wineName'], json['wineImage']);
  }
}

class PostViewModel {

  Future<List<Wine>> searchByKeyword([String search_keyword = ""]) async {
    if (search_keyword == "") {
      return [];
    }

    var response = await http_get(header: null, path: 'api/product/search/'+search_keyword);
    List responseJson = response;

    Map<String, dynamic> find_manaully = {
      'wineName': '결과에 와인이 없는 경우 여기를 터치해주세요',
      'wineImage': 'http://images.vivino.com/thumbs/default_label_150x200.jpg'
    };
    // responseJson.insert(0, find_manaully);
    responseJson.add(find_manaully);


    return responseJson.map((post) => new Wine.fromJson(post)).toList();
  }
}
