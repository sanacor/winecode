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
      child: buildFloatingSearchBar(),

    );


  }

  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
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
