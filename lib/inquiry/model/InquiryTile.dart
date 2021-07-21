import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryDetail.dart';

class InquiryTile extends StatelessWidget {
  InquiryTile(this._inquiryInfo);

  final InquiryInfo? _inquiryInfo;

  @override
  Widget build(BuildContext context) {
    print(_inquiryInfo!.reply.runtimeType);
    print(_inquiryInfo!.reply.toString());
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_inquiryInfo!.inqPdtImage!, fit: BoxFit.fill),
      ),
      title: Text(_inquiryInfo!.inqPdtName.toString()),
      subtitle: Text(_inquiryInfo!.inqTime.toString()),
      trailing: Text(_inquiryInfo!.getCnt()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InquiryDetail(inqPdtName: _inquiryInfo!.inqPdtName, replyInfo: _inquiryInfo!.reply, inquiryInfo: _inquiryInfo,)));
      },
    );
  }
}

class InquiryInfo {
  int? inqId;
  int? inqUserMsrl;
  String? inqPdtName;
  String? inqPdtImage;
  String? inqPdtCompany;
  String? inqContents;
  String? inqTime;
  List<dynamic>? reply;

  InquiryInfo({this.inqId, this.inqUserMsrl, this.inqPdtName, this.inqPdtImage, this.inqPdtCompany, this.inqContents, this.inqTime, this.reply });

  factory InquiryInfo.fromJson(Map<String,dynamic> json){
    return InquiryInfo(
      inqId : json['inqId'],
      inqUserMsrl: json['inqUserMsrl'],
      inqPdtName: json['inqPdtName'],
      inqPdtImage: json['inqImgUrl'],
      inqPdtCompany: json['inqPdtCompany'],
      inqContents: json['inqContents'],
      inqTime: json['inqTime'],
      reply: json['reply']
    );
  }

  String getCnt() {
    int totCnt = 0;
    int repliedCnt = 0;
    reply?.forEach((replyElement) {
      totCnt += 1;
      if(replyElement['rlyStatus'] == "Replied")
        repliedCnt += 1;
    });
    if(repliedCnt == 0)
      return "답변대기중";
    else if(repliedCnt == totCnt)
      return "답변완료";
    else
      return repliedCnt.toString() + "/" + totCnt.toString();
  }
}
