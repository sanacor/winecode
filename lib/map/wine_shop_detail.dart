import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/util/http.dart';
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
            SizedBox(height: 20),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: RichText(
                    text: TextSpan(
                        text: ("${widget.wineShopItem!.retail_name!}의 와인"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20)))),
            ShopWineList(widget.wineShopItem!.retail_id!)
          ],
        ),
      ),
    );
  }
}

class ShopWineList extends StatefulWidget {
  ShopWineList(this._shopId);

  var _shopId;

  @override
  _ShopWineListState createState() => _ShopWineListState();
}

class _ShopWineListState extends State<ShopWineList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
            initialData: [],
            future: _fetchShopWineList(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Expanded(
                    child: ListView.separated(
                    padding: const EdgeInsets.only(top: 10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                            snapshot.data![index].wineImageURL!,
                            fit: BoxFit.fill),
                      ),

                      title: Text('${snapshot.data![index].wineCompany}' +
                          " " +
                          '${snapshot.data![index].wineName}'),
                      isThreeLine: false,
                      subtitle: Text(snapshot.data![index].wineRegion == null ||
                              snapshot.data![index].wineCountry == null
                          ? '검색 결과에 와인이 없는 경우 여기 ✋'
                          : '${snapshot.data![index].wineRegion}' +
                              " in " +
                              '${snapshot.data![index].wineCountry}'),
                      // Text('${snapshot.data![index].wineRegion}' + " in " + '${snapshot.data![index].wineCountry}'),
                      // onTap: () {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //       builder: (context) => (index == snapshot.data!.length - 1) || (index == 0) ?  ManualInquiry(wineItem: Wine()) : WineDetail(
                      //           wineItem: snapshot.data![index])));
                      // },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1);
                  },
                ));
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.red[900]!)),
                );
              }
            }));
  }

  Future<List<dynamic>> _fetchShopWineList() async {
    print("[fetchInquiryData] started fetch Inquiry data http request");
    var response = await http_get(
        header: null, path: 'api/retail/${widget._shopId}/product_list');
    List responseJson = response['list'];

    return responseJson.map((post) => new Wine.fromJson(post)).toList();
  }
}
