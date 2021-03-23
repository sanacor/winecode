import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class KakaoLogin extends StatefulWidget {
  KakaoLogin({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KakaoLoginState createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;
  String userInfo = '';

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
      print("AccessToken : " + token.accessToken);
      /*
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginDone()),
      );
       */
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

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e);
    }
  }

  logOutTalk() async {
    try {
      var code = await UserApi.instance.logout();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kakao Flutter SDK Login"),
        actions: [],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
                child: Text("Login with Talk"),
                onPressed:
                    _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao),
            RaisedButton(
              child: Text("Logout"),
              onPressed: logOutTalk,
            ),
            Text(userInfo),
          ],
        ),
      ),
    );
  }
}