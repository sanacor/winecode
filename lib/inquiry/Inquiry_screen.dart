import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryTile.dart';
import 'package:http/http.dart' as http;

class InquiryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(children: <Widget>[
              Container(height: Platform.isAndroid ? 10 : 1 ),

              Container(
        padding: const EdgeInsets.only(left: 20),
        alignment: Alignment.bottomLeft,
        child: RichText(
          text: TextSpan(
            text: '와인 문의',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          ),
        ),
        height: MediaQuery.of(context).size.height / 25,
      ),
        SizedBox(height: MediaQuery.of(context).size.height / 25),
        Expanded(child: InquiryPage())
    ])));
    throw UnimplementedError();
  }
}

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: [],
        future: _fetchInquiryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InquiryTile(snapshot.data[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  thickness: 2,
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<List<InquiryInfo>> _fetchInquiryData() async {
    List<InquiryInfo> InquiryList = [];
    var url =
        'https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/inquiry';

    print("[fetchInquiryData] started fetch Inquiry data http request");

    try {
      var response = await http.get(Uri.encodeFull(url), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      });

      if (response.statusCode == 200) {
        print('shit-200');
        List responseJson = json.decode(utf8.decode(response.bodyBytes));
        return responseJson
            .map((inqueryInfo) => new InquiryInfo.fromJson(inqueryInfo))
            .toList();
      } else {
        throw Exception('Failed to load InquiryInfo Data');
      }
    } catch (ex) {
      print(ex);
    }
  }
}