import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wine/view/chat.dart';
import 'package:wine/view/winemap.dart';
import 'package:wine/view/search.dart';
import 'package:wine/view/settings.dart';


void main() => runApp(WineApp());

class WineApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _onBottomItemTapped(int index) {
    setState(() {
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

  var _views = [
    Search(),
    WineMap(),
    Chat(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
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
      // body: Center(),
      body: _views[_selectedIndex]
    );
  }
}
