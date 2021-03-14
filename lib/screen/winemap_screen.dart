import 'dart:ui';
import 'package:flutter/material.dart';


// class WineMapScreen extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('WineMaps'));
//   }
//
// }

class WineMapScreen extends StatefulWidget {
  @override
  _WineMapScreenState createState() => _WineMapScreenState();
}

class _WineMapScreenState extends State<WineMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('wineMap'),
      )
    );
  }
}
