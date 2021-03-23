import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wine/screen/chat_screen.dart';
import 'package:wine/screen/search_screen.dart';
import 'package:wine/screen/settings_screen.dart';
import 'package:wine/map/wine_shop_map.dart';
import 'package:wine/socialLogin/kakaoLogin.dart';


void main() => runApp(WineApp(from_search: false));

class WineApp extends StatelessWidget {
  final bool from_search;

  const WineApp({ Key key, this.from_search }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print('sana: $from_search');
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
      home: MyHomePage(from_search: from_search),
    );
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
          ChatScreen(),
          //SettingsScreen()
          KakaoLogin()
        ],
        index: _selectedIndex,
      ),

    );
  }
}

GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
final BottomNavigationBar navigationBar = globalKey.currentWidget;
