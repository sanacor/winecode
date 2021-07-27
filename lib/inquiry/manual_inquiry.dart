import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine/image/image_upload.dart';
import 'package:wine/map/inquiry_map.dart';
import 'package:wine/model/wine.dart';

class ManualInquiry extends StatefulWidget {
  Wine? wineItem;

  ManualInquiry({this.wineItem});

  @override
  _ManualInquiryState createState() => _ManualInquiryState();
}

class _ManualInquiryState extends State<ManualInquiry> {
  GlobalKey<ImageUploadScreenState> _myKey = GlobalKey();

  final wineNameController = TextEditingController();

  var inquiryContentsController = TextEditingController();

  bool _imageUploading = false;

  ImageUploadScreen? _imageUploadScreen;

  @override
  void initState() {
    super.initState();
    _imageUploadScreen = ImageUploadScreen(key:_myKey);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.wineItem!.wineName != "") {
      wineNameController.text =
          //widget.wineItem!.wineCompany! + " " + widget.wineItem!.wineName!;
      widget.wineItem!.wineName!;
    }
    // return Container(color: Colors.red,);
    return Scaffold(
      body: SafeArea(child: Container(
        child: _imageUploading ?
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Colors.red[900]!)
                ),
                SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    text: '잠시만 기다려주세요.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                  ),
                ),
              ],
            )
          )
        : SingleChildScrollView(
            child:Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Container(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 15),
                  alignment: Alignment.topCenter,
                  child: Text(
                    '와인 문의 하기',
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      _imageUploading = true;
                    });
                    if(widget.wineItem!.wineName == "") {
                      //ManualInquiry
                      String imgUrl = await _myKey.currentState!.uploadImage();
                      widget.wineItem!.wineImageURL = imgUrl;
                      widget.wineItem!.wineCompany = "";
                    }
                    widget.wineItem!.wineName = wineNameController.text;
                    widget.wineItem!.inqContents = inquiryContentsController.text;

                    //TODO Delay되는 동안 Loading화면 띄우기
                    Future.delayed(const Duration(milliseconds: 3000), () { //이거 안넣어주면 맵이 초기에 위치를 못찾음
                      setState(() {
                        _imageUploading = false;
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              InquiryMapScreen(wineItem: widget.wineItem)));
                    });
                  },
                  child: new Container(
                      padding: EdgeInsets.only(top: 15, right: 15),
                      alignment: Alignment.topCenter,
                      child: Text(
                        '다음',
                        // style: TextStyle(fontSize: 17),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Colors.red[900]),
                      )))
            ],),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),

            //사용자가 직접 입력하는 경우 업로드 화면, 선택해서 넘어온 경우 와인이미지 보여줌
            widget.wineItem!.wineName == "" ?
            Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 150.0,
                child: _imageUploadScreen
            ) :
            Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 150.0,
                child: Image.network(widget.wineItem!.wineImageURL!)
            )
            ,

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
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 40.0,
              // padding: EdgeInsets.only(left: 15, right: 15),
              child: ListView(
                scrollDirection: Axis.horizontal,
                // spacing: 6.0,
                // runSpacing: 6.0,
                children: <Widget>[
                  _buildChip('재고 있나요?', Colors.red[900]!),
                  _buildChip('가격이 궁금해요^^', Colors.red[900]!),
                  _buildChip('주차 가능한가요?', Colors.red[900]!),
                  _buildChip('영업시간을 알려주세요~', Colors.red[900]!),
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
              height: 300,
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
        )),
      )),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 2),
      child: ActionChip(
        onPressed: () {
            inquiryContentsController.text = inquiryContentsController.text + label + '\n';
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
