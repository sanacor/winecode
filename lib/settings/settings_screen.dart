import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:wine/image/image_upload.dart';
import 'package:wine/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wine/reply/reply_screen.dart';
import 'package:wine/util/http.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final storage = FlutterSecureStorage();
  String thumbnailImgUrl = 'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/image/view/53';//비어있는 유저 사진
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
                children: <Widget>[
                  Container(height: Platform.isAndroid ? 10 : 1),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                      text: '설정',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                      ),
                    ),
                  height: MediaQuery.of(context).size.height / 25,
                  ),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: CircleAvatar(
                      backgroundImage:
                      NetworkImage(thumbnailImgUrl),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: RichText(
                      text: TextSpan(
                        text: userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  Expanded(
                      child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: LoadSettingTile(context),
                  )
                  )
    ])));
  }

  List<Widget> LoadSettingTile(BuildContext context) {
    List<ListTile> widgetList = [];
    /*
    widgetList.add(ListTile(
      leading: Icon(Icons.quick_contacts_dialer),
      title: Text('내 정보'),
      onTap: () => _tapCallback(context),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.wine_bar),
      title: Text('관심 와인 내역'),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.timer),
      title: Text('예약 내역 확인'),
    ));
     */
    widgetList.add(ListTile(
      leading: Icon(Icons.batch_prediction),
      title: Text('공지사항'),
      onTap: () => _tapCallback(context),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.question_answer),
      title: Text('자주 묻는 질문'),
    ));
    /*
    widgetList.add(ListTile(
      leading: Icon(Icons.android_outlined),
      title: Text('앱 설정'),
    ));
     */
    widgetList.add(ListTile(
      leading: Icon(Icons.add_business_outlined),
      title: Text('사장님 메뉴'),
      onTap: () => _storeOwner(context),
    ));
    /*
    widgetList.add(ListTile(
      leading: Icon(Icons.add_business_outlined),
      title: Text('이미지 업로드'),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ImageUploadScreen()));
      },
    ));
     */
    widgetList.add(ListTile(
      leading: Icon(Icons.logout),
      title: Text('로그아웃'),
      onTap: () => _tapLogout(context),
    ));

    return widgetList;
  }

  void _tapCallback(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text("공지"), content: Text("환영합니다."));
        });
  }

  void _tapLogout(BuildContext context) async {
    await storage.delete(key: "access_token");
    await storage.delete(key: "refresh_token");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  void _storeOwner(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ReplyScreen()));
  }

  Future<void> _getUserInfo() async {
    var response = await http_get(header: null, path: 'api/user');

    print(response);

    List responseJson = response['list'];

    setState(() {
      thumbnailImgUrl = response['data']['profile']['uspImage'];
      userName = response['data']['user']['name'];
    });
  }
}
