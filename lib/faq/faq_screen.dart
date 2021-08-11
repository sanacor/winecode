import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wine/model/faq.dart';
import 'package:wine/model/notice.dart';
import 'dart:io' show Platform;

import 'package:wine/util/http.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  Future<List<Faq>> _fetchFaqData() async {
    var response = await http_get(header: null, path: 'api/faq/list');
    List responseJson = response['list'];
    return responseJson.map((faq) => new Faq.fromJson(faq)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                  ),
                  SizedBox(width: 100),
                  Container(
                      padding: EdgeInsets.only(top: 15),
                      alignment: Alignment.topCenter,
                      child: Text(
                        '자주묻는질문',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Faq>>(
                    initialData: [],
                    future: _fetchFaqData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        print("Test");
                        return MyExpansionTileList(snapshot.data!);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.red[900]!)
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        )
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<Faq> elementList;

  MyExpansionTileList(this.elementList);

  List<Widget> _getChildren() {
    List<Widget> children = [];
    elementList.forEach((element) {
      children.add(
        new ExpansionTile(
          title: Text(element.faqQ!),
          children: [
            Html(
                data: element.faqA!
            ),
          ],
        ),
      );
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _getChildren(),
    );
  }
}