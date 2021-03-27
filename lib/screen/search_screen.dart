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
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: Container(child: ListWidget())));
  }
}

class ListWidget extends StatelessWidget {
  final TextEditingController _textController = new TextEditingController();
  final PostViewModel viewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Wine>>(
      future: this.viewModel.searchByKeyword('amaranta'),
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
              Expanded(child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
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
        return CircularProgressIndicator();
      },
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
  }
}
