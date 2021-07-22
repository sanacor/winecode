import 'package:wine/util/http.dart';


class Wine {
  int? wineId;
  String? wineName;
  String? inqContents;
  String? wineImageURL;
  String? wineCompany;
  String? wineType;
  String? wineCountry;
  String? wineRegion;

  Wine({this.wineId=0,this.wineName ="", this.wineImageURL="", this.wineCompany="", this.wineType="", this.wineCountry="", this.wineRegion=""});

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(wineId: json['wineId'],
        wineName: json['wineName'],
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
      'wineName': '와인 이름을 직접 입력하여 문의해보세요',
      'wineImage': 'http://images.vivino.com/thumbs/default_label_150x200.jpg',
      'wineCompany' : '',
      'wineRegion': null,
      'wineCountry': null
    };
    responseJson.insert(0, findManaully);
    responseJson.add(findManaully);


    return responseJson.map((post) => new Wine.fromJson(post)).toList();
  }
}
