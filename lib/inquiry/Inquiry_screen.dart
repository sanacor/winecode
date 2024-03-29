import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:wine/inquiry/model/InquiryTile.dart';
import 'package:wine/util/http.dart';

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
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InquiryTile(snapshot.data![index]);
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

  Future<List<dynamic>> _fetchInquiryData() async {
    print("[fetchInquiryData] started fetch Inquiry data http request");
    var response = await http_get(header: null, path: 'api/inquiry/list');
    print(response);
    if (response['success'] == true) {
      var inquiryList = response['list'];
      inquiryList = inquiryList.map((inquiryInfo) => new InquiryInfo.fromJson(inquiryInfo)).toList();
      return inquiryList;
    } else {
      final snackBar = SnackBar(content: Text("문의내역이 없습니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var inquiryList = [];
      return inquiryList;
    }
  }
}
