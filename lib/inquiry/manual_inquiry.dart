import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';

class ManualInquiry extends StatelessWidget {
  final inquiryController = TextEditingController();
  Wine wine_item = Wine('', '');
  var inquiry_text_field = TextEditingController();


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
                    onTap: () {
                      wine_item.wineName = inquiryController.text;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              InqueryMapScreen(wineItem: wine_item)));
                    },
                    child: new Container(
                        padding: EdgeInsets.only(top: 15, right: 15),
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '다음',
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
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 40.0,
              // padding: EdgeInsets.only(left: 15, right: 15),
              child: ListView(
                scrollDirection: Axis.horizontal,
                // spacing: 6.0,
                // runSpacing: 6.0,
                children: <Widget>[
                  _buildChip('재고 있나요?', Color(0xFFff6666)),
                  _buildChip('가격이 궁금해요^^', Color(0xFFff6666)),
                  _buildChip('주차 가능한가요?', Color(0xFFff6666)),
                  _buildChip('영업시간을 알려주세요~', Color(0xFFff6666)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child:
              const Divider(
                height: 20,
                thickness: 1,
                indent: 0,
                endIndent: 0,
              ),
            ),
            Container(
              height: 200,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: inquiry_text_field,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                obscureText: false,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: '문의하실 내용을 입력 해주세요:)',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0x00000000)),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 2),
      child: ActionChip(
        onPressed: () {
            inquiry_text_field.text = inquiry_text_field.text + label + '\n';
        },
        labelPadding: EdgeInsets.all(2.0),
        // avatar: CircleAvatar(
        //   backgroundColor: Colors.white70,
        //   child: Text(label[0].toUpperCase()),
        // ),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
