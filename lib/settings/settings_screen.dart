
import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool _isKakaoTalkInstalled = false;
  String userInfo = '';

  List<Widget> LoadSettingTile(BuildContext context){
    List<ListTile> widgetList = [];
    widgetList.add(ListTile(leading: Icon(Icons.quick_contacts_dialer), title: Text('내 정보'),onTap:() => _tapCallback(context),));
    widgetList.add(ListTile(leading: Icon(Icons.wine_bar),title: Text('관심 와인 내역'),));
    widgetList.add(ListTile(leading: Icon(Icons.timer),title: Text('예약 내역 확인'),));
    widgetList.add(ListTile(leading: Icon(Icons.batch_prediction),title: Text('공지사항'),));
    widgetList.add(ListTile(leading: Icon(Icons.question_answer),title: Text('자주 묻는 질문'),));
    widgetList.add(ListTile(leading: Icon(Icons.android_outlined),title: Text('앱 설정'),));
    widgetList.add(ListTile(leading: Icon(Icons.login), title: Text('카카오톡 로그인'),onTap:() => _loginWithTalk(),));

    return widgetList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    KakaoContext.clientId = 'ca40c6c8ce91488eb2134298e99bbdee';
    _initKakaoTalkInstalled();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
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

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print("AccessToken : " + token.accessToken);
      try {
        User user = await UserApi.instance.me();
        print(user.toString());
        setState(() {
          userInfo = user.toString() + "\n\nAccessToken : "
              + token.accessToken + "\n\nRefreshToken : " + token.refreshToken;
        });
      } on KakaoAuthException catch (e) {} catch (e) {}
    } catch (e) {
      print("error on issuing access token: $e");
    }
  }

  _loginWithTalk() async {
    if (_isKakaoTalkInstalled) {
      try {
        var code = await AuthCodeClient.instance.requestWithTalk();
        await _issueAccessToken(code);
      } catch (e) {
        print(e);
      }
    } else {
      //카톡이 깔려있지 않으면 웹으로 진행
      Fluttertoast.showToast(
          msg: "카카오톡이 설치되어있지 않습니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      try {
        //Not Working
        var code = await AuthCodeClient.instance.request();
        await _issueAccessToken(code);
      } catch (e) {
        print(e);
      }
    }
  }

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
}