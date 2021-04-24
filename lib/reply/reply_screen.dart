import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:wine/reply/ReplyTile.dart';
// import 'package:wine/util/http.dart';
import 'package:wine/util/http_mock.dart';

class ReplyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
          child: Center(
              child: Column(children: <Widget>[
                Container(height: Platform.isAndroid ? 10 : 1 ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                      text: '답변 하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 25,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 25),
                Expanded(child: ReplyPage())
              ]))),
    );
    throw UnimplementedError();
  }
}

class ReplyPage extends StatefulWidget {
  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: [],
        future: _fetchReplyData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return replyTile(snapshot.data[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(thickness: 1);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<List<replyInfo>> _fetchReplyData() async {
    List<replyInfo> replyInfoList = [];
    var response = await http_get(header: null, path: 'api/retail/mylist');
    List responseJson = response;
    print(responseJson);

    return responseJson
        .map((inqueryInfo) => new replyInfo.fromJson(inqueryInfo))
        .toList();

  }
}
