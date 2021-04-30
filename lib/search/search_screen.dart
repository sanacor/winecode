import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:wine/model/wine.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:wine/widget/wine_detail.dart';
import 'package:wine/inquiry/manual_inquiry.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _textController = new TextEditingController();
  final PostViewModel viewModel = PostViewModel();
  var isLoading = false;
  // return SafeArea(child: Center(child: Container(child: ListWidget())));

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Container(
                child: FutureBuilder<List<Wine>>(
      future: this.viewModel.searchByKeyword(_textController.text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          isLoading = true;
        } else {
          isLoading = false;
        }

        return Column(
          children: <Widget>[
            Container(height: Platform.isAndroid ? 10 : 1 ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.bottomLeft,
              child: RichText(
                text: TextSpan(
                  text: '와인 검색',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                ),
              ),
              height: MediaQuery.of(context).size.height / 25,
            ),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 25,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        decoration: new InputDecoration.collapsed(
                            hintText: "  와인 이름으로 검색"),
                      ),
                    ),
                    Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            isLoading = true;
                            _handleSubmitted(_textController.text);
                          }),
                    ),
                  ],
                )),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.red[900])))
                    : ListView.separated(
                        // scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        // itemCount: snapshot.data.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                          indent: 20,
                          endIndent: 20,
                          thickness: 1
                        ),
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Container(
                                height: 70,
                                child: Center(child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(snapshot.data[index].wineImageURL, fit: BoxFit.fill),
                                  ),

                                  title: Text('${snapshot.data[index].wineName}'),
                                  isThreeLine: false,
                                  subtitle:
                                  Text('${snapshot.data[index].wineName}'),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => (index == snapshot.data.length - 1) || (index == 0) ?  ManualInquiry(Wine('', '')) : WineDetail(
                                            wineItem: snapshot.data[index])));
                                  },
                                ),)
                              ));
                        },
                      ))
          ],
        );
      },
    ))));
  }

  void _handleSubmitted(String text) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // this.viewModel.searchByKeyword(text);
    });
  }
}
