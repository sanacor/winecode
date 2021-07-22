import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/image/image_upload.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/util/http.dart';

class ReviewRegister extends StatefulWidget {
  Wine? wineItem;

  ReviewRegister({this.wineItem});

  @override
  _ReviewRegisterState createState() => _ReviewRegisterState();
}

class _ReviewRegisterState extends State<ReviewRegister> {
  final wineNameController = TextEditingController();

  var inquiryContentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _registerReview() async {
    var response = await http_post(header: null, path: 'api/creator/review'/*, body: wineInquiry.toJson()*/);

    if (response['success'] == true) {
      final snackBar = SnackBar(content: Text("리뷰등록 완료!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("리뷰등록 실패!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.wineItem!.wineName != "") {
      wineNameController.text =
          widget.wineItem!.wineCompany! + " " + widget.wineItem!.wineName!;
    }
    // return Container(color: Colors.red,);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                ),
                Container(
                    padding: EdgeInsets.only(top: 15),
                    alignment: Alignment.topCenter,
                    child: Text(
                      '와인 리뷰 정보 등록',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                ),
                GestureDetector(
                    onTap: () => _registerReview(),
                    child: new Container(
                        padding: EdgeInsets.only(top: 15, right: 15),
                        alignment: Alignment.topCenter,
                        child: Text(
                          '등록',
                          // style: TextStyle(fontSize: 17),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.red[900]),
                        )
                    )
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.wineItem!.wineCompany!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(widget.wineItem!.wineName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                            text: widget.wineItem!.wineType!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 15),
                            children: [
                              TextSpan(
                                  text: " From ",
                                  style:
                                  TextStyle(fontWeight: FontWeight.normal)),
                              TextSpan(
                                text: widget.wineItem!.wineRegion!,
                              ),
                              TextSpan(
                                text: " · ",
                              ),
                              TextSpan(
                                text: widget.wineItem!.wineCountry!,
                              ),
                            ]),
                      ),
                    ],
                  ),
                )
              ],
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
              padding: EdgeInsets.only(left: 15, right: 15),
              child: TextField(
                controller: wineNameController,
                obscureText: false,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: '와인 이름을 입력해주세요:)',
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
            height: 100,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: TextField(
              controller: inquiryContentsController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              obscureText: false,
              decoration: InputDecoration(
                // border: OutlineInputBorder(),
                hintText: '문의하실 내용을 입력해주세요:)',
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
      ),
    );
  }
}
