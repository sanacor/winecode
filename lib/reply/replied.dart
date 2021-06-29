import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';



class Replied extends StatelessWidget {
  // 답변 완료한 문의 상세 페이지
  // reply['reply']
  // reply['inquiry']
  // final inquiryController = TextEditingController();
  Wine wine_item = Wine();
  var reply = new Map();

  Replied(Map<String, dynamic> reply) {
    this.reply = reply;
    this.wine_item = reply['inqPdtName'];
    print('shsh');
  }

  // set reply(Map<String, dynamic> reply) {}


  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red,);
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
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
                      '완료된 와인 답변',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
            // GestureDetector(
            //     onTap: (){
            //       wine_item.wineName = inquiryController.text;
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => InquiryMapScreen(wineItem: wine_item)));
            //
            //     },
            //     child: new Container(
            //         padding: EdgeInsets.only(top: 15, right: 15),
            //         alignment: Alignment.bottomRight,
            //         child: Text(
            //           '다음',
            //           style: TextStyle(fontSize: 17),
            //
            //         ))
            // )
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
                // controller: inquiryController,
                obscureText: false,
                decoration: InputDecoration(
                    // border: OutlineInputBorder(),
                    // hintText: '와인 이름',
                    labelText: this.reply['inquiry']['inqPdtName'],
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),),
              ),
            Container(
              height: 200,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  // hintText: '답변 내용을 입력 해주세요:)',
                  labelText: this.reply['reply']['rlyContents'],
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                ),),
            ),

          ],
        ),
      )),
    );
  }

}
