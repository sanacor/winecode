import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';


class Replying extends StatelessWidget {
  final inquiryController = TextEditingController();
  Wine wine_item = Wine('', '');


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
                      '와인 문의 하기',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
            GestureDetector(
                onTap: (){
                  wine_item.wineName = inquiryController.text;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InqueryMapScreen(wineItem: wine_item)));

                },
                child: new Container(
                    padding: EdgeInsets.only(top: 15, right: 15),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '다음',
                      style: TextStyle(fontSize: 17),

                    ))
            )
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
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
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
                  hintText: '답변 내용을 입력 해주세요:)',
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
