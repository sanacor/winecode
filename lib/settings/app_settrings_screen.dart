import 'package:flutter/material.dart';
import 'package:wine/main.dart';
import 'dart:io' show Platform;

class AppSettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  bool _pushToggled = true;
  bool _vibeToggeld = true;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("test appbar"),
        ),
        body: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
          Container(height: Platform.isAndroid ? 10 : 1),
          Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.bottomLeft,
            child: RichText(
              text: TextSpan(
                text: '앱 설정',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
            height: MediaQuery.of(context).size.height / 25,
          ),
          Expanded(
              child: ListView(
            physics: BouncingScrollPhysics(),
            children: _LoadAppSettingTile(context),
          ))
        ]))));
  }

  List<Widget> _LoadAppSettingTile(BuildContext context) {
    List<SwitchListTile> widgetList = [];

    widgetList.add(SwitchListTile(
        title: Text("푸시 알림 설정"),
        value: _pushToggled,
        onChanged: (bool value) {
          setState(() {
            _pushToggled = value;

        });
        },));

    widgetList.add(SwitchListTile(
        title: Text("진동"),
        value: _vibeToggeld,
        onChanged: (bool value) {
          setState(() {
            _vibeToggeld = value;
          });
        }));

    return widgetList;
  }
}
