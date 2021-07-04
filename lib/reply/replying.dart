import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/util/http.dart';


class Replying extends StatelessWidget {
  // 아직 답변이 필요한 문의의 답변하기 페이지
  final inquiryController = TextEditingController();
  final replyController = TextEditingController();
  Wine? wine_item = Wine();
  var reply = new Map();

  Replying(Map<String, dynamic>? reply) {
    this.reply = reply!;
    this.wine_item!.wineName = reply['inquiry']['inqPdtName'];
    print(this.wine_item!.wineName);
  }

  // set reply(Map<String, dynamic> reply) {}

  @override
  Widget build(BuildContext context) {

    inquiryController.text = wine_item!.wineName!;
    // return Container(color: Colors.red,);
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    child: Text(
                      '와인 답변 하기',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                GestureDetector(
                    onTap: () async {
                      // wine_item.wineName = inquiryController.text;
                      var snackBar = await _onReplyTap();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      Navigator.of(context).pop();
                    },
                    child: new Container(
                        padding: EdgeInsets.only(top: 15, right: 15),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '완료',
                          style: TextStyle(fontSize: 17),
                        )))
              ],
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: inquiryController,
                obscureText: false,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: '와인 이름',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Text(this.reply['inquiry']['inqContents'],
                  style: TextStyle(fontSize: 17, height: 1.2)),
            ),
            Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                )),
            Container(
              height: 400,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: replyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: '답변 내용을 입력 해주세요:)',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                ),
              ),
            )
          ],
        )),
      )),
    );

  }


  dynamic _onReplyTap() async {
    Map<String, dynamic>? a =
    {
      'rlyId': reply['reply']['rlyId'].toString(),
      'rlyContents': replyController.text
    };


    var response = await http_post(header: null, path: 'api/retail/reply', body: a);

    if (response['success'] == true) {
      return SnackBar(content: Text("답변 보내기 완료!"));
    } else {
      return SnackBar(content: Text("답변 보내기 실패!"));
    }
  }
}
