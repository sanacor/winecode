import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;
import 'package:wine/util/http.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'package:wine/map/wine_shop_detail.dart';

class WineMapScreen extends StatefulWidget {
  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<WineMapScreen> {
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];

  OverlayImage wineShopMarker;

  Future<void> _getWineShopList() async {
    // var url =
    //     "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/retail/infoall";
    // print(url);
    // var response;
    // try {
    //   response = await http
    //       .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    // } catch (e) {
    //   print(e);
    // }

    wineShopMarker = await OverlayImage.fromAssetImage(
      assetName: 'images/wine.png',
      context: context,
    );

    var response = await http_get(header: null, path: 'api/retail/infoall');
    
    print(response);

    List responseJson = response['list'];

    var wineShopList = responseJson;

    for (Map wine_shop in wineShopList) {
      _addMarker(wine_shop['rtlId'].toString(), wine_shop['rtlName'],
          wine_shop['xcoordinate'], wine_shop['ycoordinate']);
    }
  }

  void _addMarker(String retailId, String retailName, double retailLocationX,
      double retailLocationY) {
    setState(() {
      _markers.add(Marker(
          markerId: retailId,
          position: LatLng(retailLocationY, retailLocationX),
          captionText: retailName,
          captionColor: Colors.red[500],
          captionHaloColor: Colors.grey[300],
          captionTextSize: 12.0,
          alpha: 1,
          icon: wineShopMarker,
          anchor: AnchorPoint(0.5, 1),
          width: 30,
          height: 40,
          //infoWindow: '인포 윈도우',
          onMarkerTab: _onMarkerTap));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWineShopList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(height: Platform.isAndroid ? 10 : 1),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    text: '내 주변 와인샵',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 25,
              ),
              flex: 1,
            ),
            SizedBox(height: 15),
            Expanded(
              child: NaverMap(
                onMapCreated: _onMapCreated,
                onMapTap: _onMapTap,
                markers: _markers,
                initLocationTrackingMode: LocationTrackingMode.Follow,
              ),
              flex: 21,
            ),
          ],
        ),
      ),
    );
  }

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
      //_markers[pos].captionText = '선택됨';
      _markers[pos].captionColor = Colors.blue;
    });

    var response = await http_get(
        header: null, path: 'api/retail/' + _markers[pos].markerId);

    print(response);

    Map wineShopInfo = response['data'];
    WineShop selectedWineShop = WineShop(
      retail_id: wineShopInfo['rtlId'].toString(),
      retail_address: wineShopInfo['rtlAddress'].toString(),
      retail_name: wineShopInfo['rtlName'].toString(),
      //TODO Null이어도 되도록 해야함
      //retail_bhours: wineShopInfo['rtlBhours'].toString(),
      retail_phone: wineShopInfo['rtlPhone'].toString(),
      //retail_exp: wineShopInfo['rtlExp'].toString(),
    );
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WineShopDetail(wineShopItem: selectedWineShop)));
    _markers[pos].captionColor = Colors.red;
  }
}
