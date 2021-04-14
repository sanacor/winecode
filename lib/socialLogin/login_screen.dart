import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert' show jsonEncode, utf8;

import 'package:wine/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginScreen> {
  bool _isKakaoTalkInstalled = false;
  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(height: Platform.isAndroid ? 10 : 1 ),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        text: '로그인',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Padding(padding: const EdgeInsets.all(50)),
                  Center(
                    child: InkWell(
                      onTap: _loginWithTalk,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.6,
                        height: MediaQuery.of(context).size.height*0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              '카카오톡으로 로그인',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w900,
                                fontSize: 20
                              ),
                            )
                          ]
                        )
                      )
                    )
                  ),
                ],
              ),
            )
          )
      ),
    );
    /*
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: RaisedButton(
          child: const Text("Login"),
          onPressed: _loginWithTalk,
        ),
      ),
    );
    */
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


  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      //print("AccessToken : " + token.accessToken);
      await _registerUserInfoWithKakao(token.accessToken);
      await _loginWithKakao(token.accessToken);
      try {
        User user = await UserApi.instance.me();
        //print(user.toString());
        Fluttertoast.showToast(
            msg: user.properties['nickname'] + "님 반갑습니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
      await storage.write(
          key: "jwt",
          value: JsonResponse['data']);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MyHomePage()));
    } catch (e) {
      print(e);
    }
  }

}
