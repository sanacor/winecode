import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryDetail.dart';

class InquiryTile extends StatelessWidget {
  InquiryTile(this._inquiryInfo);

  final InquiryInfo _inquiryInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_inquiryInfo.comment),
      subtitle: Text("${_inquiryInfo.wine}"),
      trailing: Text(_inquiryInfo.state),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InquiryDetail(inquiryInfo: _inquiryInfo)));
      },
    );
  }
}

class InquiryInfo {
  String id;
  String wine;
  String shop;
  String comment;
  String state;
  /*
   {
        "id": "987-326-436",
        "shop": "저스트와인",
        "wine": "Game Of Thrones pinor Noir",
        "state": "답변 완료",
        "content": "재고 충분합니다. 궁금한 사항 연락주세요:)"
    },
   */

  InquiryInfo({this.id, this.shop, this.wine, this.comment, this.state});

  factory InquiryInfo.fromJson(Map<String,dynamic> json){
    return InquiryInfo(
      id : json['id'],
      shop: json['shop'],
      wine: json['wine'],
      comment: json['content'],
      state: json['state'],
    );
  }
}

class InQueryEnableIcon extends StatelessWidget {
  InQueryEnableIcon(this._isDone);

  final bool _isDone;

  @override
  Widget build(BuildContext context) {
    if (_isDone)
      return Icon(Icons.done_outline);
    else
      return Icon(Icons.help_outline);
  }
}