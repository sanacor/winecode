import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;
import 'dart:convert' show utf8;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isKakaoTalkInstalled = false;
  String userInfo = '';

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
      leading: Icon(Icons.login),
      title: Text('카카오톡 로그인'),
      onTap: () => _loginWithTalk(),
    ));

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

  void _tapCallback(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text("선택"), content: Text("항목을 선택했습니다."));
        });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print("AccessToken : " + token.accessToken);
      await _registerUserInfoWithKakao(token.accessToken);
      await _loginWithKakao(token.accessToken);
      /*
      try {
        User user = await UserApi.instance.me();
        print(user.toString());
        setState(() {
          userInfo = user.toString() + "\n\nAccessToken : "
              + token.accessToken + "\n\nRefreshToken : " + token.refreshToken;
        });
      } on KakaoAuthException catch (e) {} catch (e) {}
       */
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

  _registerUserInfoWithKakao(String accessToken) async {
    var url =
        "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/v1/signup/kakao?accessToken=" + accessToken;
    try {
      var response = await http
          .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      var JsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      //TODO 여기서 응답코드에 따라서 로그인으로 넘어갈지 회원가입으로 갈지 결정??
      print(JsonResponse);
    } catch (e) {
      print(e);
    }
  }

  _loginWithKakao(String accessToken) async {
    var url =
        "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/v1/signin/kakao?accessToken=" + accessToken;
    try {
      var response = await http
          .post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      var JsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));
      //TODO 발급받은 JWT를 Secure Storage에 저장해둬야 함
      print(JsonResponse);
    } catch (e) {
      print(e);
    }
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
