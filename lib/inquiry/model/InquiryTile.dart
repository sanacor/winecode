import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryDetail.dart';

class InquiryTile extends StatelessWidget {
  InquiryTile(this._inquiryInfo);

  final InquiryInfo _inquiryInfo;

  @override
  Widget build(BuildContext context) {
    print(_inquiryInfo.reply.runtimeType);
    print(_inquiryInfo.reply.toString());
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(_inquiryInfo.inqPdtImage, fit: BoxFit.fill),
      ),
      title: Text(_inquiryInfo.inqPdtName.toString()),
      // subtitle: Text("${_inquiryInfo.reply.toString()}"),
      // trailing: Text(_inquiryInfo.reply.toString()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InquiryDetail(inqPdtName: _inquiryInfo.inqPdtName, replyInfo: _inquiryInfo.reply)));
      },
    );
  }
}

class InquiryInfo {
  int inqId;
  int inqUserMsrl;
  String inqPdtName;
  String inqPdtImage;
  String inqPdtCompany;
  String inqContents;
  String inqTime;
  List<dynamic> reply;

  InquiryInfo({this.inqId, this.inqUserMsrl, this.inqPdtName, this.inqPdtImage, this.inqPdtCompany, this.inqContents, this.inqTime, this.reply });

  factory InquiryInfo.fromJson(Map<String,dynamic> json){
    return InquiryInfo(
      inqId : json['inqId'],
      inqUserMsrl: json['inqUserMsrl'],
      inqPdtName: json['inqPdtName'],
      inqPdtImage: 'https://i.ibb.co/yQjhY5p/Screen-Shot-2021-04-15-at-10-52-11-PM.png',
      inqPdtCompany: json['inqPdtCompany'],
      inqContents: json['inqContents'],
      inqTime: json['inqTime'],
      reply: json['reply']
    );
  }
}
