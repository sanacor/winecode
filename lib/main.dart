import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wine/search/search_screen.dart';

import 'package:wine/settings/settings_screen.dart';
import 'package:wine/inquery/inquery_screen.dart';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wine/map/wine_shop_map.dart';
import 'package:provider/provider.dart';

import 'package:wine/settings/settings_screen.dart';
import 'package:wine/inquery/inquery_screen.dart';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_plugin.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:kakao_flutter_sdk/local.dart';
import 'package:kakao_flutter_sdk/push.dart';
import 'package:kakao_flutter_sdk/search.dart';
import 'package:kakao_flutter_sdk/story.dart';
import 'package:kakao_flutter_sdk/talk.dart';
import 'package:kakao_flutter_sdk/template.dart';
import 'package:kakao_flutter_sdk/user.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';


final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


class Profile with ChangeNotifier {
  bool _isAuthentificated = false;

  bool get isAuthentificated {
    return this._isAuthentificated;
  }

  set isAuthentificated(bool newVal) {
    this._isAuthentificated = newVal;
    this.notifyListeners();
  }
}


// void main() => runApp(WineApp(from_search: false));
void main() {
  KakaoContext.clientId = "ca40c6c8ce91488eb2134298e99bbdee";
  KakaoContext.javascriptClientId = "b17c77211acfdb44a6e6d6a91310cd44";

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Profile>(
          create: (final BuildContext context) {
            return Profile();
          },
        )
      ],
      child: WineApp(from_search: false),
    ),
  );
}

class WineApp extends StatefulWidget {
  final bool from_search;//TODO from_search 걷어내야함

  const WineApp({ Key key, this.from_search }) : super(key: key);

  @override
  _WineAppState createState() => _WineAppState();
}

class _WineAppState extends State<WineApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Profile>(
      builder: (final BuildContext context, final Profile profile, final Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wine',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.blueGrey,
            secondaryHeaderColor: Colors.blueGrey[600],
            backgroundColor: Colors.grey[200],
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          home: MyHomePage(from_search: widget.from_search),
          //home: profile.isAuthentificated ? MyHomePage(from_search: widget.from_search) : MyLoginPage(),
        );
      },
    );

  }
}


class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool _isKakaoTalkInstalled = false;
  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: RaisedButton(
          child: const Text("Login"),
          onPressed: _loginWithTalk,
        ),
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
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print("AccessToken : " + token.accessToken);
      await _registerUserInfoWithKakao(token.accessToken);
      await _loginWithKakao(token.accessToken);
      try {
        User user = await UserApi.instance.me();
        print(user.toString());
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
      print(JsonResponse);
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


class MyHomePage extends StatefulWidget {
  bool from_search;
  MyHomePage({Key key, this.from_search=false}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int _selectedIndex = 0;

  static final storage = new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkJWT();
    });
  }

  _checkJWT() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    String jwt = await storage.read(key: "jwt");
    print(jwt);

    //jwt가 없는 경우 로그인 페이지로 이동
    if (jwt == null) {
      Fluttertoast.showToast(
          msg: "로그인 정보가 없어 로그인페이지로 이동합니다.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              MyLoginPage()));
    } else {
      Fluttertoast.showToast(
          msg: "로그인 정보 있음",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print('token:'+token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      print(index);
      widget.from_search = false;
      _selectedIndex = index;
    });
  }

  static const List<BottomNavigationBarItem> _bnbItems =
  <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.search, color: Colors.black),
        title: Text('검색', style: TextStyle(color: Colors.black))
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.room, color: Colors.black),
        title: Text('지도', style: TextStyle(color: Colors.black))
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble, color: Colors.black),
        title: Text('문의', style: TextStyle(color: Colors.black))
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.settings, color: Colors.black),
        title: Text('설정', style: TextStyle(color: Colors.black))
    )
  ];


  @override
  Widget build(BuildContext context) {
    print('sana2 $widget.from_search');
    if (widget.from_search) {
      _selectedIndex = 1;
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: _bnbItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: _onBottomItemTapped,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.blue,


      ),
      body:IndexedStack(
        children: <Widget>[
          SearchScreen(),
          WineMapScreen(),
          inquery_screen(),
          SettingsScreen()
        ],
        index: _selectedIndex,
      ),
    );
  }
}

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
final BottomNavigationBar navigationBar = globalKey.currentWidget;
