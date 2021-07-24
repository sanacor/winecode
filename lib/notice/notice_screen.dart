import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {



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

            ],
          ),
        )
    );
  }
}
