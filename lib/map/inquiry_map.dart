import 'dart:io' show Platform;
import 'dart:async';
import 'package:wine/util/http.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:wine/model/inquiry_info.dart';
import 'package:wine/model/wine.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class InquiryMapScreen extends StatefulWidget {
  final Wine wineItem;

  const InquiryMapScreen({this.wineItem}) : super();

  @override
  _MarkerMapPageState createState() => _MarkerMapPageState();
}

class _MarkerMapPageState extends State<InquiryMapScreen> {
  Completer<NaverMapController> _controller = Completer();
  List<Marker> _markers = [];
  List<String> _selectedShops = [];

  OverlayImage wineShopMarker;

  int _selectCnt = 0;

  static final storage = FlutterSecureStorage();

  Future<void> _getWineShopList() async {
    wineShopMarker = await OverlayImage.fromAssetImage(
      assetName: 'images/wine.png',
      context: context,
    );

    var response = await http_get(header: null, path: 'api/retail/allpartner');

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
                    text: '문의 보낼 와인샵 선택',
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
        floatingActionButton: FloatingActionButton(
          child: Text("문의"),
          onPressed: _onInquiryTap,
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          height: 40.0,
          child: Text("선택된 와인샵 : " + _selectCnt.toString()),
        )),
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
        _selectedShops.add(_markers[pos].markerId);
      } else {
        _markers[pos].captionColor = Colors.red;
        _selectCnt -= 1;
        _selectedShops.remove(_markers[pos].markerId);
      }
    });
    print(_selectedShops);
  }

  Future<void> _onInquiryTap() async {
    if (_selectedShops.length <= 0) {
      final snackBar = SnackBar(content: Text("와인샵을 선택해주세요."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (_selectedShops.length > 10) {
      final snackBar = SnackBar(content: Text("10개까지 선택 가능합니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    var wineInquiry = InquiryInfo(widget.wineItem.wineName, widget.wineItem.inqContents, " ", _selectedShops);

    var response = await http_post(header: null, path: 'api/inquiry/send', body: wineInquiry.toJson());

    if (response['success'] == true) {
      final snackBar = SnackBar(content: Text("문의보내기 완료!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("문의보내기 실패!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
