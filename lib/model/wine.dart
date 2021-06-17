import 'package:wine/util/http.dart';


class Wine {
  String? wineName;
  String? inqContents;
  String? wineImageURL;
  String? wineCompany;
  String? wineType;
  String? wineCountry;
  String? wineRegion;

  Wine({this.wineName ="", this.wineImageURL="", this.wineCompany="", this.wineType="", this.wineCountry="", this.wineRegion=""});

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(wineName: json['wineName'],
        wineImageURL: json['wineImage'],
        wineCompany : json['wineCompany'],
        wineType : json['wineType'],
        wineCountry: json['wineCountry'],
        wineRegion: json['wineRegion']
    );
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
      'wineImage': 'http://images.vivino.com/thumbs/default_label_150x200.jpg',
      'wineCompany' : '',
      'wineRegion': '',
      'wineCountry':''
    };
    responseJson.insert(0, findManaully);
    responseJson.add(findManaully);


    return responseJson.map((post) => new Wine.fromJson(post)).toList();
  }
}
