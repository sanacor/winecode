import 'package:wine/util/http.dart';


class Wine {
  String wineName;
  String inqContents;
  String wineImageURL;

  Wine(this.wineName, this.wineImageURL);

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(json['wineName'], json['wineImage']);
  }
}


class PostViewModel {

  Future<List<Wine>> searchByKeyword([String searchByKeyword = ""]) async {
    if (searchByKeyword == "") {
      return [];
    }

    var response = await http_get(header: null, path: 'api/product/search/'+searchByKeyword);
    List responseJson = response['list'];

    Map<String, dynamic> findManaully = {
      'wineName': '결과에 와인이 없는 경우 여기를 터치해주세요',
      'wineImage': 'http://images.vivino.com/thumbs/default_label_150x200.jpg'
    };
    responseJson.insert(0, findManaully);
    responseJson.add(findManaully);


    return responseJson.map((post) => new Wine.fromJson(post)).toList();
  }
}
