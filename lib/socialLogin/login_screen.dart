import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:wine/util/http.dart';
import 'package:flutter/gestures.dart';
import 'package:wine/webview/webview_screen.dart';
import 'package:device_info/device_info.dart';
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => _loginWithKakaoTalk(), // needed
                            child: Image.asset(
                              "images/kakao_login_medium_narrow.png",
                              //width: 100,
                              //fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            child: SignInWithAppleButton(
                              text: "Apple로 로그인",
                              onPressed: () async {
                                final credential =
                                    await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                );
                                print(
                                    "=========== Apple Apple Apple Apple ============");
                                print(credential);
                                _loginWithApple(credential);
                                // _issueJWTandLogin("appleToken");

                                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                              },
                            ),
                            width: 100,
                            height: 43,
                            padding: const EdgeInsets.only(left: 95, right: 95),
                          ),
                          Container(
                            width: 100,
                            height: 62,
                            margin: EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 95, right: 95),
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[900],
                                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text('비회원으로 시작하기', style: TextStyle(fontSize: 18),),
                            onPressed: () => _startByGuest(),
                          ),)
                        ],
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

  _issueKakaoAccessToken(String authCode) async {
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

  _loginWithKakaoTalk() async {
    if (_isKakaoTalkInstalled) {
      try {
        var code = await AuthCodeClient.instance.requestWithTalk();
        await _issueKakaoAccessToken(code);
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
        await _issueKakaoAccessToken(code);
      } catch (e) {
        print(e);
      }
    }
  }
  _startByGuest() async {
    if (!(await _registerGuest())) {
      final snackBar = SnackBar(content: Text("회원가입 실패"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await _issueJWTandLoginByGuest();
  }

  _loginWithApple(AuthorizationCredentialAppleID credential) async {
    if (!(await _registerUserInfoWithApple(credential))) {
      final snackBar = SnackBar(content: Text("회원가입 실패"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await _issueJWTandLoginByApple(credential);
  }

  Future<bool> _registerUserInfoWithKakao(String? accessToken) async {
    var signUpBody = {'userIdentifier': 'compatibleForApple'};//애플로그인과 호환성을 위해 Body 담음
    try {
      var response = await http_post(
          header: null, path: 'v1/signup/kakao?accessToken=' + accessToken!,
          body:signUpBody
      );
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

  Future<bool> _registerGuest() async {
    try {
      String? userIdentifier = await getDeviceId();
      var signUpBody = {'userIdentifier': userIdentifier};
      var response = await http_post(
          header: null,
          path: 'v1/signup/guest?accessToken=' + 'trash_token'!,
          body: signUpBody);
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

  Future<bool> _registerUserInfoWithApple(
      AuthorizationCredentialAppleID credential) async {
    try {
      var signUpBody = {'userIdentifier': credential.userIdentifier};
      var response = await http_post(
          header: null,
          path: 'v1/signup/apple?accessToken=' + 'trash_token'!,
          body: signUpBody);
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

  _issueJWTandLoginByApple(AuthorizationCredentialAppleID credential) async {
    // var url =
    //     "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/v1/signin/kakao?accessToken=" +
    //         accessToken;
    try {
      // var response = await http.post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      // var JsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));

      print('toooken');
      var fcm_token = await FirebaseMessaging.instance.getToken();
      print(fcm_token);
      var signUpBody = {'fcmToken': fcm_token, 'userIdentifier': credential.userIdentifier};

      var response = await http_post(
          header: null, path: 'v1/signin/apple?accessToken=fake_token', body: signUpBody);

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

  _issueJWTandLoginByGuest() async {
    // var url =
    //     "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/v1/signin/kakao?accessToken=" +
    //         accessToken;
    try {
      // var response = await http.post(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      // var JsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));

      print('toooken');
      var fcm_token = await FirebaseMessaging.instance.getToken();
      print(fcm_token);
      String? userIdentifier = await getDeviceId();
      var signUpBody = {'fcmToken': fcm_token, 'userIdentifier': userIdentifier};

      var response = await http_post(
          header: null, path: 'v1/signin/guest?accessToken=fake_token', body: signUpBody);

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

  Future<String?> getDeviceId () async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }

  }
}
