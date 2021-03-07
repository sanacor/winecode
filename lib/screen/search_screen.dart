import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:wine/model/wine.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';



class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBarController<Wine> _searchBarController = SearchBarController();
  bool isReplay = false;

  Future<List<Wine>> _searchWineByKeyword(String text) async {
    List<Wine> wines = [];

    var response = await http.get(
          Uri.encodeFull("https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/wine"),
          headers: {
            "Accept": "application/json",
            "x-api-key-word": text
          }
      );

    if (response.statusCode == 200) {
      print('http 200');
      var jsonResponse = convert.jsonDecode(response.body);
      var wine_list = jsonResponse['wine_list'];
      print(wine_list);
      print(wine_list is List);

      for (Map wine in wine_list) {
        print('shit');
        wines.add(Wine(wine['wine'], wine['image_url']));
      };
      print('wines');
      // print(wines);
      return wines;
    }
    else {
      print('http 500');
    }
    return wines;

  }

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text('Search'));
    return SafeArea(
      child: SearchBar<Wine>(
        searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
        headerPadding: EdgeInsets.symmetric(horizontal: 10),
        listPadding: EdgeInsets.symmetric(horizontal: 10),
        onSearch: _searchWineByKeyword,
        searchBarController: _searchBarController,
        // placeHolder: Text("placeholder"),
        cancellationWidget: Text("Cancel"),
        emptyWidget: Text("empty"),
        // indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
        onCancelled: () {
          print("Cancelled triggered");
        },
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        crossAxisCount: 1,
        onItemFound: (Wine wine_item, int index) {
          return Container(
            // margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent)
            ),
            // color: Colors.lightBlue,
            child: ListTile(
              leading: Image.network(wine_item.wine_image_url),
              title: Text(wine_item.wine_name),
              isThreeLine: false,
              subtitle: Text(wine_item.wine_name),
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
              },
            ),
          );
        },
      ),

    );


  }




}

