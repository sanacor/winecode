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


class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBarController<Wine> _searchBarController = SearchBarController();
  bool isReplay = false;


  Future<List<Wine>> _searchWineByKeyword(String search_text) async {
    List<Wine> wines = [];
    print('START');
    var url =  "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/product/search/$search_text";
    print(url);
    var response;
    try {
      response = await http.get(
      // Uri.encodeFull("https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/wine"),
          Uri.encodeFull(url),
          headers: {
            "Accept": "application/json"
          }
      );
    }catch(e){
        print(e);
    }


    print(response);

    if (response.statusCode == 200) {
      print('http 200');
      var jsonResponse = convert.jsonDecode(response.body);
      var wineList = jsonResponse;
      print(wineList);
      print(wineList is List);

      for (Map wine in wineList) {
        print('shit');
        wines.add(Wine(wine['wineName'], wine['wineImage']));
      };
      print('wines');
      return wines;
    }
    else {
      print('http 500');
      print(response);
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
        cancellationWidget: Text("취소"),
        emptyWidget: Text("empty"),
        // indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
        onCancelled: () {
          print("Cancelled triggered");
        },
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        crossAxisCount: 1,
        onItemFound: (Wine wineItem, int index) {
          return Container(
            // margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.blueAccent)
            ),
            // color: Colors.lightBlue,
            child: ListTile(
              leading: Image.network(wineItem.wineImageURL),
              title: Text(wineItem.wineName),
              isThreeLine: false,
              subtitle: Text(wineItem.wineName),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => WineDetail(wineItem: wineItem)));
              },
            ),
          );
        },
      ),

    );


  }

}

//
// class WineDetail extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             Text("Detail"),
//           ],
//         ),
//       ),
//     );
//   }
// }
