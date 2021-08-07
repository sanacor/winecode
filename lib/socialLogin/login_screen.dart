import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:wine/util/http.dart';
import 'package:flutter/gestures.dart';
import 'package:wine/webview/webview_screen.dart';


import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginScreen> {
  bool _isKakaoTalkInstalled = false;
  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
          child: Column(
            children: <Widget>[
              Container(height: Platform.isAndroid ? 10 : 1),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: '로그인',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 40),
                              ),
                            ),
                          ]),
                      InkWell(
                        onTap: () => _loginWithTalk(), // needed
                        child: Image.asset(
                          "images/kakao_login_medium_narrow.png",
                          //width: 100,
                          //fit: BoxFit.cover,
                        ),
                      ),
                      SignInWithAppleButton(
                        onPressed: () async {
                          final credential =
                              await SignInWithApple.getAppleIDCredential(
                            scopes: [
                              AppleIDAuthorizationScopes.email,
                              AppleIDAuthorizationScopes.fullName,
                            ],
                          );
                          print("=========== Apple Apple Apple Apple ============");
                          print(credential);
                          _issueJWTandLogin("appleToken");

                          // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                          // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: RichText(
                          text: TextSpan(
                            text: '회원가입 없이 이용 가능하며 첫 로그인 시 이용약관 및 ',
                            style: TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 13),
                            children: <TextSpan>[
                              TextSpan(
                                text: '개인정보처리방침',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  decorationStyle: TextDecorationStyle.wavy,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                            webTitle: "개인정보처리방침",
                                            webUrl:
                                                "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/privacy.html")));
                                  },
                              ),
                              TextSpan(
                                text: ' 동의로 간주됩니다.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                flex: 1,
              ),
            ],
          ),
        ))),
      ),
    );
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
      AccessTokenResponse? token =
          await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      //print("AccessToken : " + token.accessToken);
      try {
        User user = await UserApi.instance.me();

        final snackBar =
            SnackBar(content: Text(user.properties!['nickname']! + "님 반갑습니다."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (!(await _registerUserInfoWithKakao(token.accessToken))) {
          final snackBar = SnackBar(content: Text("회원가입 실패"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        await _issueJWTandLogin(token.accessToken);
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
      final snackBar = SnackBar(content: Text("카카오톡이 설치되어있지 않습니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      try {
        //Not Working
        var code = await AuthCodeClient.instance.request();
        await _issueAccessToken(code);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> _registerUserInfoWithKakao(String? accessToken) async {
    try {
      var response = await http_post(
          header: null, path: 'v1/signup/kakao?accessToken=' + accessToken!);
      if (response['code'] == 0 ||
          response['code'] == -9999) //정상 가입 또는 이미 가입한 회원
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  _issueJWTandLogin(String accessToken) async {
    // var url =
    //     "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/v1/signin/kakao?accessToken=" +
    //         accessToken;
    try {
      // var response = await http.post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      // var JsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));

      print('toooken');
      var fcm_token = await FirebaseMessaging.instance.getToken();
      print(fcm_token);
      var signUpBody = {'fcmToken': fcm_token};

      var response = await http_post(
          header: null,
          path: 'v1/signin/kakao?accessToken=' + accessToken,
          body: signUpBody);

      print("access_token : " + response['data']['access_token']);
      await storage.write(
          key: "access_token", value: response['data']['access_token']);
      await storage.write(
          key: "refresh_token", value: response['data']['refresh_token']);
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage()));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}
