import 'package:flutter/material.dart';
import 'package:wine/reply/replying.dart';


class ReplyTile extends StatelessWidget {
  ReplyTile(this._replyInfo);

  final ReplyInfo _replyInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_replyInfo.inqPdtName, fit: BoxFit.fill),
      ),
      title: Text(_replyInfo.inqPdtName.toString()),
      // subtitle: Text("${_replyInfo.reply.toString()}"),
      // trailing: Text(_replyInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Replying()));
      },
    );
  }
}

class ReplyInfo {
  String reply;
  String rlyId;
  String rlyInqId;
  String rlyRtlId;
  String rlyRtlName;
  String rlyTime;
  String rlyContents;
  String inqId;
  String rlyStatus;
  String inqUserMsrl;
  String inqPdtName;
  String inqPdtCompany;
  String inqContents;
  String inqTime;

  ReplyInfo({this.rlyId, this.rlyInqId, this.rlyRtlId, this.rlyRtlName, this.rlyStatus, this.rlyTime, this.rlyContents, this.inqId, this.inqUserMsrl, this.inqPdtName, this.inqPdtCompany, this.inqContents, this.inqTime});

  factory ReplyInfo.fromJson(Map<String,dynamic> json){
    print('nooo-001');
    return ReplyInfo(
      rlyId: json['reply']['rlyId'],
      rlyInqId: json['reply']['rlyInqId'],
      rlyRtlId: json['reply']['rlyRtlId'],
      rlyRtlName: json['reply']['rlyRtlName'],
      rlyStatus: json['inquery']['rlyStatus'],
      rlyTime: json['reply']['rlyTime'],
      rlyContents: json['reply']['rlyContents'],
      inqId: json['inquery']['inqId'],
      inqUserMsrl: json['inquery']['inqUserMsrl'],
      inqPdtName: json['inquery']['inqPdtName'],
      inqPdtCompany: json['inquery']['inqPdtCompany'],
      inqContents: json['inquery']['inqContents'],
      inqTime: json['inquery']['inqTime'],

    );
  }
}
