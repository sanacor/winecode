import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:wine/model/wine.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:wine/widget/wine_detail.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';




class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = new TextEditingController();
  final PostViewModel viewModel = PostViewModel();

  // return SafeArea(child: Center(child: Container(child: ListWidget())));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(child: Container(child: FutureBuilder<List<Wine>>(
      future: this.viewModel.searchByKeyword(_textController.text),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSubmitted,
                          decoration: new InputDecoration.collapsed(
                              hintText: "와인 이름으로 검색"),
                        ),
                      ),
                      Container(
                        // margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () =>
                                _handleSubmitted(_textController.text)),
                      ),
                    ],
                  )),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                // itemCount: snapshot.data.length,
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: ListTile(
                        leading:
                            Image.network(snapshot.data[index].wineImageURL),
                        title: Text('${snapshot.data[index].wineName}'),
                        isThreeLine: false,
                        subtitle: Text('${snapshot.data[index].wineName}'),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  WineDetail(wineItem: snapshot.data[index])));
                        },
                      ));
                },
              ))
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // 기본적으로 로딩 Spinner를 보여줍니다.
        // return CircularProgressIndicator();
        return Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _textController,
                        onSubmitted: _handleSubmitted,
                        decoration: new InputDecoration.collapsed(
                            hintText: "와인 이름으로 검색"),
                      ),
                    ),
                    Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () =>
                              _handleSubmitted(_textController.text)),
                    ),
                  ],
                )),
            Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  // itemCount: snapshot.data.length,
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: ListTile(
                          leading:
                          Image.network(snapshot.data[index].wineImageURL),
                          title: Text('${snapshot.data[index].wineName}'),
                          isThreeLine: false,
                          subtitle: Text('${snapshot.data[index].wineName}'),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    WineDetail(wineItem: snapshot.data[index])));
                          },
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
