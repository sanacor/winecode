import 'package:flutter/material.dart';


import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wine/main.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final storage = FlutterSecureStorage();

  List<Widget> LoadSettingTile(BuildContext context) {
    List<ListTile> widgetList = [];
    widgetList.add(ListTile(
      leading: Icon(Icons.quick_contacts_dialer),
      title: Text('내 정보'),
      onTap: () => _tapCallback(context),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.wine_bar),
      title: Text('관심 와인 내역'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.timer),
      title: Text('예약 내역 확인'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.batch_prediction),
      title: Text('공지사항'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.question_answer),
      title: Text('자주 묻는 질문'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.android_outlined),
      title: Text('앱 설정'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.logout),
      title: Text('로그아웃'),
      onTap: () => _tapLogout(context),
    ));

    return widgetList;
  }

  void _tapCallback(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text("선택"), content: Text("항목을 선택했습니다."));
        });
  }

  void _tapLogout(BuildContext context) async{
    await storage.delete(key: "jwt");
    Fluttertoast.showToast(
        msg: "로그아웃되어 홈화면으로 이동합니다.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('설정'),
            backgroundColor: Colors.white70,
            centerTitle: true,
            elevation: 0.0),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: LoadSettingTile(context),
        ));
  }
}
