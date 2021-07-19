import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'dart:io' show Platform;

class WineShopDetail extends StatefulWidget {
  final WineShop? wineShopItem;

  const WineShopDetail({Key? key, this.wineShopItem}) : super(key: key);

  @override
  _WineShopDetailState createState() => _WineShopDetailState();
}

class _WineShopDetailState extends State<WineShopDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Container(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                )),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  text: widget.wineShopItem!.retail_name!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25),
                ),
              ),
              height: MediaQuery.of(context).size.height / 25,
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.call),
              title: Text("전화번호"),
              subtitle: Text(widget.wineShopItem!.retail_phone!),
              onTap: () =>
                  {launch("tel://" + widget.wineShopItem!.retail_phone!)},
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text("주소"),
              subtitle: Text(widget.wineShopItem!.retail_address!),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text("영업시간"),
              subtitle: Text(widget.wineShopItem!.retail_bhours! == ""
                  ? "영업시간 정보없음"
                  : widget.wineShopItem!.retail_bhours!),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text("가게 소개"),
              subtitle: Text(widget.wineShopItem!.retail_exp! == ""
                  ? widget.wineShopItem!.retail_address! +
                      "에 위치한 " +
                      widget.wineShopItem!.retail_name! +
                      " 입니다."
                  : widget.wineShopItem!.retail_exp!),
            ),
            SizedBox(height: 30),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: RichText(
                    text: TextSpan(
                        text: ("${widget.wineShopItem!.retail_name!}의 와인"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20))))
            
          ],
        ),
      ),
    );
  }

  List<Widget> LoadSettingTile(BuildContext context) {
    List<ListTile> widgetList = [];
    widgetList.add(ListTile(
      leading: Icon(Icons.call),
      title: Text("전화번호"),
      subtitle: Text(widget.wineShopItem!.retail_phone!),
      onTap: () => {launch("tel://" + widget.wineShopItem!.retail_phone!)},
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.place),
      title: Text("주소"),
      subtitle: Text(widget.wineShopItem!.retail_address!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.schedule),
      title: Text("영업시간"),
      subtitle: Text(widget.wineShopItem!.retail_bhours! == ""
          ? "영업시간 정보없음"
          : widget.wineShopItem!.retail_bhours!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.description),
      title: Text("가게 소개"),
      subtitle: Text(widget.wineShopItem!.retail_exp! == ""
          ? widget.wineShopItem!.retail_address! +
              "에 위치한 " +
              widget.wineShopItem!.retail_name! +
              " 입니다."
          : widget.wineShopItem!.retail_exp!),
    ));
    widgetList.add(ListTile(
      leading: Icon(Icons.local_offer),
      title: Text('할인 정보'),
    ));

    return widgetList;
  }
}
