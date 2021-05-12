import 'package:flutter/material.dart';
import 'package:wine/reply/replying.dart';
import 'package:wine/reply/replied.dart';


class ReplyTile extends StatelessWidget {
  ReplyTile(this._replyInfo);

  final ReplyInfo _replyInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network('https://i.ibb.co/yQjhY5p/Screen-Shot-2021-04-15-at-10-52-11-PM.png', fit: BoxFit.fill),
      ),
      title: Text(_replyInfo.reply['inquery']['inqPdtName']),
      subtitle: Text("${_replyInfo.reply['reply']['rlyStatus']}"),
      // trailing: Text(_replyInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) { return _replyInfo.reply['reply']['rlyStatus'] == 'Waiting' ? Replying(_replyInfo.reply) : Replied(_replyInfo.reply);}));
      },
    );
  }
}

class ReplyInfo {
  Map<String, dynamic> reply;

  ReplyInfo({this.reply});

  factory ReplyInfo.fromJson(Map<String,dynamic> json){

    return ReplyInfo(
        reply: json
    );
  }
}
