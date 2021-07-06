import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
// import 'package:wine/inquiry/model/InquiryDetail.dart';
import 'package:wine/reply/replyTile.dart';
import 'package:wine/util/http.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

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
    logger.d('ReplyPage !!!');
    return FutureBuilder(
        initialData: [],
        future: _fetchReplyData(),
        builder: (context, AsyncSnapshot snapshot) {
          print('ReplyPage FutureBuilder');
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {

            // logger.d(snapshot.data);
            print('ReplyPage FutureBuilder - 2');
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ReplyTile(snapshot.data?[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(thickness: 1);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.red[900]!)
              ),
            );
          }
        });
  }

  Future<List<ReplyInfo>> _fetchReplyData() async {
    List<ReplyInfo> replyInfoList = [];
    var response = await http_get(header: null, path: 'api/retail/mylist');
    print('nnnn-0001');
    logger.d(response.runtimeType);
    // List responseJson = response.data['list'];
    List responseJson = response['list'];
    logger.d(responseJson.runtimeType);
    print('nnnn-0002');

    var result = responseJson.map((inquiryInfo) => new ReplyInfo.fromJson(inquiryInfo)).toList();

    return result;

  }
}
