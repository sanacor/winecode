import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

class WineMapScreen extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<WineMapScreen> {
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];

  OverlayImage wine_shop_marker;

  Future<void> _getWineShopList() async {
    print('START');
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
      var wine_shop_list = jsonResponse;
      //print(wine_shop_list);
      //print(wine_shop_list is List);

      for (Map wine_shop in wine_shop_list) {
        _add_marker(wine_shop['retailId'].toString(), wine_shop['retailName'],
            wine_shop['retailLocationX'], wine_shop['retailLocationY']);
        //print("a");
        /*
        wineShopList.add(
            WineShop(wine_shop['retailId'].toString(),wine_shop['retailName'],wine_shop['retailPhone'],
                //wine_shop['retailAddress'],wine_shop['retailBhours'],wine_shop['retailExp'])
                wine_shop['retailAddress'],"Test","Test")//retailBhours, reatailExp가 null이면 코드는 진행되나 마커가 표시안됨
        );
         */
        //print("b");
      }
    } else {
      print('http 500');
      print(response);
    }
  }

  void _add_marker(String retailId, String retailName, double retailLocationX,
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
          icon: wine_shop_marker,
          anchor: AnchorPoint(0.5, 1),
          width: 30,
          height: 40,
          infoWindow: '인포 윈도우',
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
        wine_shop_marker = image;
      });
    });
    _getWineShopList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            //_controlPanel(),
            _naverMap(),
          ],
        ),
      ),
    );
  }

  _naverMap() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          NaverMap(
            onMapCreated: _onMapCreated,
            onMapTap: _onMapTap,
            markers: _markers,
            initLocationTrackingMode: LocationTrackingMode.Follow,
          ),
        ],
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

  void _onMarkerTap(Marker marker, Map<String, int> iconSize) {
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);
    setState(() {
      _markers[pos].captionText = '선택됨';
    });
  }
}
