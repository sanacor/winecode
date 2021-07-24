import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryTile.dart';
import 'package:wine/model/notice.dart';
import 'dart:io' show Platform;

import 'package:wine/util/http.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {

  Future<List<Notice>> _fetchNoticeData() async {
    //return [new Notice(ntcTitle: "Test")];
    var response = await http_get(header: null, path: 'api/notice/list');
    List responseJson = response['list'];
    return responseJson.map((notice) => new Notice.fromJson(notice)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                  ),
                  SizedBox(width: 100),
                  Container(
                      padding: EdgeInsets.only(top: 15),
                      alignment: Alignment.topCenter,
                      child: Text(
                        '공지사항',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  ),
                ],
              ),
          Expanded(
            child: FutureBuilder<List<Notice>>(
                initialData: [],
                future: _fetchNoticeData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    print("Test");
                    return MyExpansionTileList(snapshot.data!);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.red[900]!)
                      ),
                    );
                  }
                }),
          ),
            ],
          ),
        )
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<Notice> elementList;

  MyExpansionTileList(this.elementList);

  List<Widget> _getChildren() {
    List<Widget> children = [];
    elementList.forEach((element) {
      children.add(
        new ExpansionTile(
            title: Text(element.ntcTitle!),
            children: [
              Text(element.ntcContents!),
            ],
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _getChildren(),
    );
  }
}