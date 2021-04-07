import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InqueryMapScreen extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<InqueryMapScreen> {
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];

  OverlayImage wineShopMarker;

  int _selectCnt = 0;

  Future<void> _getWineShopList() async {
    var url =
        "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/retail/infoall";
    print(url);
    var response;
    try {
      response = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    } catch (e) {
      print(e);
    }

    print(response);

    if (response.statusCode == 200) {
      //var jsonResponse = convert.jsonDecode(response.body);
      var jsonResponse =
          convert.jsonDecode(utf8.decode(response.bodyBytes)); //한글깨짐 수정
      // var wine_list = jsonResponse['wine_list'];
      var wineShopList = jsonResponse;
      //print(wine_shop_list);
      //print(wine_shop_list is List);

      for (Map wine_shop in wineShopList) {
        _addMarker(wine_shop['retailId'].toString(), wine_shop['retailName'],
            wine_shop['retailLocationX'], wine_shop['retailLocationY']);
      }
    } else {
      print('http 500');
      print(response);
    }
  }

  void _addMarker(String retailId, String retailName, double retailLocationX,
      double retailLocationY) {
    setState(() {
      _markers.add(Marker(
          markerId: retailId,
          position: LatLng(retailLocationY, retailLocationX),
          captionText: retailName,
          captionColor: Colors.red,
          captionHaloColor: Colors.black,
          captionTextSize: 12.0,
          alpha: 1,
          icon: wineShopMarker,
          anchor: AnchorPoint(0.5, 1),
          width: 30,
          height: 40,
          onMarkerTab: _onMarkerTap));
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OverlayImage.fromAssetImage(
        assetName: 'images/wine.png',
        context: context,
      ).then((image) {
        wineShopMarker = image;
      });
    });
    _getWineShopList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("문의를 보낼 와인샵 선택"),
        ),
        body: Column(
          children: <Widget>[
            _naverMap(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("문의"),
          onPressed: () {
            print("Inquery Button touched");
            Fluttertoast.showToast(
                msg: "문의보내기 완료!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          },
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 40.0,
          child: Text("선택된 와인샵 : " + _selectCnt.toString()),
        )),
      ),
    );
  }

  _naverMap() {
    return Expanded(
      child: NaverMap(
        onMapCreated: _onMapCreated,
        onMapTap: _onMapTap,
        markers: _markers,
        initLocationTrackingMode: LocationTrackingMode.Follow,
      ),
    );
  }

  // ================== method ==========================

  void _onMapCreated(NaverMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTap(LatLng latLng) {
    /*
    if (_currentMode == MODE_ADD) {
      _markers.add(Marker(
        markerId: DateTime.now().toIso8601String(),
        position: latLng,
        infoWindow: '테스트',
        onMarkerTab: _onMarkerTap,
      ));
      setState(() {});
    }
     */
  }

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) async {
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);
    setState(() {
      if (_markers[pos].captionColor == Colors.red) {
        _markers[pos].captionColor = Colors.blue;
        _selectCnt += 1;
      } else {
        _markers[pos].captionColor = Colors.red;
        _selectCnt -= 1;
      }
    });
  }
}
