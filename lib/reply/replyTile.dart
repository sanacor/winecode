import 'package:flutter/material.dart';
import 'package:wine/reply/replying.dart';


class replyTile extends StatelessWidget {
  replyTile(this._replyInfo);

  final replyInfo _replyInfo;

  @override
  Widget build(BuildContext context) {
    print('shit-1001');
    print(_replyInfo.reply.runtimeType);
    print(_replyInfo.reply.toString());
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_replyInfo.wine_image, fit: BoxFit.fill),
      ),
      title: Text(_replyInfo.wine_name.toString()),
      // subtitle: Text("${_replyInfo.reply.toString()}"),
      // trailing: Text(_replyInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Replying()));
      },
    );
  }
}

class replyInfo {
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

  replyInfo({this.id, this.reply, this.wine_id, this.wine_name, this.wine_image});

  factory replyInfo.fromJson(Map<String,dynamic> json){
    print('nooo-001');
    return replyInfo(
      id : json['reply_id'],
      reply: json['reply'],
      wine_id: json['wine_id'],
      wine_name: json['wine_name'],
      wine_image: json['wine_image']
    );
  }
}
