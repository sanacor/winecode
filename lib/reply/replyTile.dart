import 'package:flutter/material.dart';
import 'package:wine/reply/replying.dart';
import 'package:wine/reply/replied.dart';


class ReplyTile extends StatelessWidget {
  // replying 또는 replied 상세 페이지로 가기전 답변 아이템 하나에 해당하는 위젯
  ReplyTile(this._replyInfo);

  final ReplyInfo? _replyInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_replyInfo!.reply!['inquiry']['inqImgUrl'], fit: BoxFit.fill),
      ),
      title: Text(_replyInfo!.reply!['inquiry']['inqPdtName']),
      subtitle: Text("${getReplyStatus(_replyInfo!.reply!['reply']['rlyStatus'])}", style: getReplyStatusStyle(_replyInfo!.reply!['reply']['rlyStatus']),),
      // trailing: Text(_replyInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) { return _replyInfo!.reply!['reply']['rlyStatus'] == 'Waiting' ? Replying(_replyInfo!.reply) : Replied(_replyInfo!.reply!);}));
      },
    );
  }

  getReplyStatus(status) {
    Map statusMap = {
      'Waiting': '답변 필요',
      'Replied': '답변 완료'
    };

    try {
      return statusMap[status];
    }
    catch(e) {
      return '';
    }
  }

  getReplyStatusStyle(status) {
    Map statusMap = {
      'Waiting': TextStyle(color:Colors.red[900]),
      'Replied': TextStyle(color:Colors.green[900]),
    };

    try {
      return statusMap[status];
    }
    catch(e) {
      return TextStyle(color:Colors.black);
    }
  }
}


class ReplyInfo {
  Map<String, dynamic>? reply;

  ReplyInfo({this.reply});

  factory ReplyInfo.fromJson(Map<String,dynamic> json){

    return ReplyInfo(
        reply: json
    );
  }
}
