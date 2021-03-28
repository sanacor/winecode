
import 'dart:js';
import 'dart:ui';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Colors.white70,
        centerTitle: true,
        elevation: 0.0
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: LoadSettingTile(context),
      )
    );
  }

  List<Widget> LoadSettingTile(BuildContext context){
    List<ListTile> widgetList = [];
    widgetList.add(ListTile(leading: Icon(Icons.quick_contacts_dialer), title: Text('내 정보'),onTap:() => _tapCallback(context),));
    widgetList.add(ListTile(leading: Icon(Icons.wine_bar),title: Text('관심 와인 내역'),));
    widgetList.add(ListTile(leading: Icon(Icons.timer),title: Text('예약 내역 확인'),));
    widgetList.add(ListTile(leading: Icon(Icons.batch_prediction),title: Text('공지사항'),));
    widgetList.add(ListTile(leading: Icon(Icons.question_answer),title: Text('자주 묻는 질문'),));
    widgetList.add(ListTile(leading: Icon(Icons.android_outlined),title: Text('앱 설정'),));

    return widgetList;
  }

  void _tapCallback(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("선택"),
            content : Text("항목을 선택했습니다.")
          );
        }
        );
  }


}