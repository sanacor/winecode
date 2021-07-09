import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'dart:io' show Platform;


class WineShopDetail extends StatefulWidget {
  final WineShop? wineShopItem;

  const WineShopDetail ({ Key? key, this.wineShopItem }): super(key: key);

  @override
  _WineShopDetailState createState() => _WineShopDetailState();
}

class _WineShopDetailState extends State<WineShopDetail> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.bottomLeft,
                  child: RichText(
                    text: TextSpan(
                      text: widget.wineShopItem!.retail_name!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 25,
                ),
                SizedBox(height: 30),
                Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: LoadSettingTile(context),
                    )
                ),
              ],
            ),
          ),
      )
    );
  }

  List<Widget> LoadSettingTile(BuildContext context) {
    List<ListTile> widgetList = [];
    widgetList.add(ListTile(
      leading: Icon(Icons.call),
      title: Text("전화번호"),
      subtitle: Text(widget.wineShopItem!.retail_phone!),
      onTap: () => {
        launch("tel://" + widget.wineShopItem!.retail_phone!)
      },
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.place),
      title: Text("주소"),
      subtitle: Text(widget.wineShopItem!.retail_address!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.schedule),
      title: Text("영업시간"),
      subtitle: Text(widget.wineShopItem!.retail_bhours! == "" ? "영업시간 정보없음" : widget.wineShopItem!.retail_bhours!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.description),
      title: Text("가게 소개"),
      subtitle: Text(widget.wineShopItem!.retail_exp! == "" ?
        widget.wineShopItem!.retail_address! + "에 위치한 " + widget.wineShopItem!.retail_name! + " 입니다." : widget.wineShopItem!.retail_exp!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.local_offer),
      title: Text('할인 정보'),
    ));

    return widgetList;
  }
}