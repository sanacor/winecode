import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wine/search/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wine/settings/settings_screen.dart';
import 'package:wine/inquiry/Inquiry_screen.dart';


import 'package:wine/map/wine_shop_map.dart';
import 'package:provider/provider.dart';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:wine/socialLogin/login_screen.dart';

// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel  channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



Future<void> main() async {
  KakaoContext.clientId = "ca40c6c8ce91488eb2134298e99bbdee";
  KakaoContext.javascriptClientId = "b17c77211acfdb44a6e6d6a91310cd44";


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  print('============================ FirebaseMessaging.onMessage.listen');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  // await FirebaseMessaging.instance
  //     .setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.instance.getToken().then((value){
    print("======= FirebaseMessaging getToken: "+value!);
  });

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Profile>(
          create: (final BuildContext context) {
            return Profile();
          },
        )
      ],
      child: WineApp(),
    ),
  );
}

class WineApp extends StatelessWidget {

  const WineApp({ Key? key }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<Profile>(
      builder: (final BuildContext context, final Profile profile, final Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wine',
          theme: ThemeData(
            primarySwatch: Colors.blue!,
            accentColor: Colors.blueGrey!,
            secondaryHeaderColor: Colors.blueGrey[600]!,
            backgroundColor: Colors.grey[200]!,
            textTheme: GoogleFonts.latoTextTheme(
              Theme.of(context).textTheme!,
            ),
          ),
          home: MyHomePage(),
        );
      },
    ) ;

  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// SingleTickerProviderStateMixin 클래스는 애니메이션을 처리하기 위한 헬퍼 클래스
// 상속에 포함시키지 않으면 탭바 컨트롤러를 생성할 수 없다.
// mixin은 다중 상속에서 코드를 재사용하기 위한 한 가지 방법으로 with 키워드와 함께 사용
class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  static int _selectedIndex = 0;


  // Push Notification




  static final storage = new FlutterSecureStorage(); //flutter_secure_storage 사용을 위한 초기화 작업

  // 컨트롤러는 TabBar와 TabBarView 객체를 생성할 때 직접 전달
  late TabController controller;

  List<Widget> _pages = [SearchScreen(),    WineMapScreen(),    InquiryScreen(),    SettingsScreen()];

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    // SingleTickerProviderStateMixin를 상속 받아서
    // vsync에 this 형태로 전달해야 애니메이션이 정상 처리된다.
    controller = TabController(vsync: this, length: 4);
    firebaseCloudMessaging_Listeners();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkJWT();
    });


  }

  // initState 함수의 반대.
  // 위젯 트리에서 제거되기 전에 호출. 멤버로 갖고 있는 컨트롤러부터 제거.
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  _checkJWT() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    String? jwt = await storage.read(key: "access_token");
    print(jwt);

    //jwt가 없는 경우 로그인 페이지로 이동
    if (jwt == null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              LoginScreen()));
    } else {
      /*
      Fluttertoast.showToast(
          msg: "로그인 정보 있음",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
       */
    }
  }

  void firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOS_Permission();

    // _firebaseMessaging.getToken().then((token){
    //   print('fcm token:'+token);
    // });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('on message $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('on resume $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('on launch $message');
    //   },
    // );
  }

  void iOS_Permission() {
    // _firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true)
    // );
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings)
    // {
    //   print("Settings registered: $settings");
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: _pages,
      ),
      bottomNavigationBar: Material(
        child:  Container(
          // decoration: bottomNavi elevation 효과
          decoration: BoxDecoration(
            color: Colors.red[900],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              // bottomLeft: Radius.circular(10),
              // bottomRight: Radius.circular(10)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 9), // changes position of shadow
              ),
            ],
          ),
          child: TabBar(
            controller: controller,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.black54,
            // labelColor: Colors.black,
            tabs: <Widget> [
              Tab(icon: Icon(Icons.search), text: "검색"),
              Tab(icon: Icon(Icons.room_outlined), text: "지도"),
              Tab(icon: Icon(Icons.chat_outlined), text: "문의"),
              Tab(icon: Icon(Icons.settings_outlined), text: "설정"),
            ],
          ),
        ),
      )
    );
  }
}

// GlobalKey? globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
// final BottomNavigationBar navigationBar = globalKey!.currentWidget;
