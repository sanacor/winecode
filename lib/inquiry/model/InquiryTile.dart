import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryDetail.dart';

class InquiryTile extends StatelessWidget {
  InquiryTile(this._inquiryInfo);

  final InquiryInfo _inquiryInfo;

  @override
  Widget build(BuildContext context) {
    print('shit-1001');
    print(_inquiryInfo.reply.runtimeType);
    print(_inquiryInfo.reply.toString());
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_inquiryInfo.wine_image, fit: BoxFit.fill),
      ),
      title: Text(_inquiryInfo.wine_name.toString()),
      // subtitle: Text("${_inquiryInfo.reply.toString()}"),
      // trailing: Text(_inquiryInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InquiryDetail(wine_name: _inquiryInfo.wine_name, inquiryInfo: _inquiryInfo.reply)));
      },
    );
  }
}

class InquiryInfo {
  String id;
  String wine_name;
  String wine_id;
  // List<Map<String, String>> reply;
  List<dynamic> reply;
  String wine_image;
  /*
   {
        "id": "987-326-436",
        "shop": "저스트와인",
        "wine": "Game Of Thrones pinor Noir",
        "state": "답변 완료",
        "content": "재고 충분합니다. 궁금한 사항 연락주세요:)"
    },
   */

  InquiryInfo({this.id, this.reply, this.wine_id, this.wine_name, this.wine_image});

  factory InquiryInfo.fromJson(Map<String,dynamic> json){
    print('nooo-001');
    return InquiryInfo(
      id : json['inquiry_id'],
      reply: json['reply'],
      wine_id: json['wine_id'],
      wine_name: json['wine_name'],
      wine_image: json['wine_image']
    );
  }
}
