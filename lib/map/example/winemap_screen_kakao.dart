// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:ui';
import 'dart:convert' as convert;
import 'dart:convert' show utf8;
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

import 'package:wine/map/example/page.dart';
import 'package:wine/map/model/wine_shop.dart';

class WineMapScreenKakao extends KakaoMapExampleAppPage {
  WineMapScreenKakao() : super(const Icon(Icons.place), 'Place marker');

  @override
  Widget build(BuildContext context) {
    return const PlaceMarkerBody();
  }
}

class PlaceMarkerBody extends StatefulWidget {
  const PlaceMarkerBody();

  @override
  State<StatefulWidget> createState() => PlaceMarkerBodyState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class PlaceMarkerBodyState extends State<PlaceMarkerBody> {
  PlaceMarkerBodyState();
  static final MapPoint center = const MapPoint(37.350152, 127.117604);
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: MapPoint(37.350152, 127.117604),
    zoom: 5,
  );
  CameraPosition _position = _kInitialPosition;

  KakaoMapController controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MarkerId selectedMarker;
  int _markerIdCounter = 1;

  bool _isDrage = false;

  List<WineShop> wineShopList = [];

  void _onMapCreated(KakaoMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    print('_onMarkerTapped' + markerId.toString());
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      if(selectedMarker == markerId){
        //이미 터치한 마커를 한번 더 터치한 경우 상세화면으로 이동
        print(wineShopList[int.parse(markerId.value)]);//코드 개선 시급
      }
      else {
        setState(() {
          if (markers.containsKey(selectedMarker)) {
            final Marker resetOld = markers[selectedMarker]
                .copyWith(iconParam: BitmapDescriptor.defaultMarker);
            markers[selectedMarker] = resetOld;
          }
          selectedMarker = markerId;
          final Marker newMarker = tappedMarker.copyWith(
            iconParam: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          );
          markers[markerId] = newMarker;
        });
      }
    }
  }

  void _onInfoWindowTapped(MarkerId markerId) {
    print('_onInfoWindowTapped' + markerId.toString());
  }

  void _onMarkerDragEnd(MarkerId markerId, MapPoint newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _add_marker(String retailId, String retailName, double retailLocationX, double retailLocationY) {
    final String markerIdVal = _markerIdCounter.toString();
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      //position: MapPoint(retailLocationX, retailLocationY),
      position: MapPoint(retailLocationY, retailLocationX),
      draggable: _isDrage,
      infoWindow: InfoWindow(title: retailName, snippet: 'TestTest', onTap: (){
        _onInfoWindowTapped(markerId);
      }),
      markerType: MarkerType.markerTypeBluePin,
      markerSelectedType: MarkerSelectedType.markerSelectedTypeRedPin,
      showAnimationType: ShowAnimationType.showAnimationTypeDropFromHeaven,
      onTap: () {
        _onMarkerTapped(markerId);
      },
      onDragEnd: (MapPoint position) {
        _onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  void _remove() {
    setState(() {
      if (markers.containsKey(selectedMarker)) {
        markers.remove(selectedMarker);
      }
    });
  }

  void _changePosition() {
    final Marker marker = markers[selectedMarker];
    final MapPoint current = marker.position;
    final Offset offset = Offset(
      center.latitude - current.latitude,
      center.longitude - current.longitude,
    );
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        positionParam: MapPoint(
          center.latitude + offset.dy,
          center.longitude + offset.dx,
        ),
      );
    });
  }

  Future<void> _changeInfoAnchor() async {
    final Marker marker = markers[selectedMarker];
    final Offset currentAnchor = marker.infoWindow.anchor;
    final Offset newAnchor = Offset(1.0 - currentAnchor.dy, currentAnchor.dx);
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          anchorParam: newAnchor,
        ),
      );
    });
  }

  Future<void> _changeInfo() async {
    final Marker marker = markers[selectedMarker];
    final String newSnippet = marker.infoWindow.snippet + '*';
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        infoWindowParam: marker.infoWindow.copyWith(
          snippetParam: newSnippet,
        ),
      );
    });
  }

  Future<void> _changeRotation() async {
    final Marker marker = markers[selectedMarker];
    final double current = marker.rotation;
    setState(() {
      markers[selectedMarker] = marker.copyWith(
        rotationParam: current == 330.0 ? 0.0 : current + 30.0,
      );
    });
  }

  Future<void> _getWineShopList() async {
    print('START');
    var url =  "http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/retail/infoall";
    print(url);
    var response;
    try {
      response = await http.get(
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
      //var jsonResponse = convert.jsonDecode(response.body);
      var jsonResponse = convert.jsonDecode(utf8.decode(response.bodyBytes));//한글깨짐 수정
      // var wine_list = jsonResponse['wine_list'];
      var wine_shop_list = jsonResponse;
      //print(wine_shop_list);
      //print(wine_shop_list is List);

      for (Map wine_shop in wine_shop_list) {
        _add_marker(wine_shop['retailId'].toString(),wine_shop['retailName'],wine_shop['retailLocationX'],wine_shop['retailLocationY']);
        /*
        print("a");
        wineShopList.add(
            WineShop(wine_shop['retailId'].toString(),wine_shop['retailName'],wine_shop['retailPhone'],
                //wine_shop['retailAddress'],wine_shop['retailBhours'],wine_shop['retailExp'])
                wine_shop['retailAddress'],"Test","Test")//retailBhours, reatailExp가 null이면 코드는 진행되나 마커가 표시안됨
        );
        print("b");
         */
      }
    }
    else {
      print('http 500');
      print(response);
    }
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void _onMarkerSelect(MarkerTag markerId) {
    print("Test");
  }

  @override
  void initState() {
    // TODO: implement initState
    _getWineShopList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 500.0,
            child: KakaoMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: const CameraPosition(
                target: MapPoint(37.350152, 127.117604),
                zoom: 5,
              ),
              onMarkerSelect: _onMarkerSelect,
              onCameraMove: _updateCameraPosition,
              markers: Set<Marker>.of(markers.values),
            ),
          ),
        ),
      ],
    );
  }
}
