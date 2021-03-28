import 'package:flutter/material.dart';

class InqueryTile extends StatelessWidget {
  InqueryTile(this._inqueryInfo);

  final InqueryInfo _inqueryInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_inqueryInfo.comment),
      subtitle: Text("${_inqueryInfo.wine}"),
      trailing: InQueryEnableIcon(_inqueryInfo.state),
    );
  }
}

class InqueryInfo {
  int id;
  String wine;
  String shop;
  String comment;
  bool state;
  /*
   {
        "id": "987-326-436",
        "shop": "저스트와인",
        "wine": "Game Of Thrones pinor Noir",
        "state": "답변 완료",
        "content": "재고 충분합니다. 궁금한 사항 연락주세요:)"
    },
   */

  InqueryInfo({this.id, this.shop, this.wine, this.comment, this.state});

  factory InqueryInfo.fromJson(Map<String,dynamic> json){
    return InqueryInfo(
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