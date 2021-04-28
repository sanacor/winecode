import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:wine/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wine/reply/reply_screen.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Center(
            child: Column(children: <Widget>[
              Container(height: Platform.isAndroid ? 10 : 1 ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        text: '나의 페이지',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Expanded(child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: LoadSettingTile(context),
                  ))
            ])));
  }

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
      leading: Icon(Icons.add_business_outlined),
      title: Text('사장님 메뉴'),
      onTap: () => _storeOwner(context),
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
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            MyHomePage()));
  }

  void _storeOwner(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReplyScreen()));
  }

}
