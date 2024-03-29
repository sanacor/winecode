import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/util/http.dart';
import 'package:flutter/services.dart';

import 'dart:io' show Platform, sleep;

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
              trailing: Icon(Icons.copy_all),
              onTap: () { Clipboard.setData(new ClipboardData(text: widget.wineShopItem!.retail_address!)); final snackBar = SnackBar(content: Text("복사 완료!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar); },


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
            SizedBox(height: 11, child: Container(color: Colors.grey[200],),),
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
            widget.wineShopItem!.retail_partner!
                ? ShopWineList(widget.wineShopItem!.retail_id!)
                : PleaseJoinWineFi(widget.wineShopItem!.retail_name)
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
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(snapshot.data![index].wineId.toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        _deleteWineFromShop(snapshot.data![index].wineId.toString(), snapshot.data![index].wineName);
                        snapshot.data!.removeAt(index);
                        // sleep(const Duration(seconds: 1));
                        // Remove the item from the data source.
                        // setState(() {
                        //   // snapshot.data!.removeAt(index);
                        // });


                      },
                      child: ListTile(
                        onLongPress: () {},
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
                      )
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 1);
                  },
                ));
              } else {
                return Center(
                  child: Container(),
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

  void _deleteWineFromShop(String wine_id, wine_name) async {
    print("[_deleteWineFromShop]");
    var response = await http_get(
        header: null, path: 'api/retail/${widget._shopId}/delete/${wine_id}');

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${wine_name}을 삭제하였습니다')));
  }

}

class PleaseJoinWineFi extends StatefulWidget {
  PleaseJoinWineFi(this._shopName);

  var _shopName;
  String _snackBarSentence = "에게 Wine-Fi 입점을 요청해볼게요!";
  @override
  _PleaseJoinWineFiState createState() => _PleaseJoinWineFiState();
}

class _PleaseJoinWineFiState extends State<PleaseJoinWineFi> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        child: Column(children: [
          SizedBox(height: 10,),
          Container(child: Text("아직 Wine-Fi와 함께하지 못하고 있는 와인샵입니다")),
          SizedBox(height: 10,),
          Container(
            height: 70,
            child: Row(
            children: [
              Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(

                        style: ButtonStyle(
                          // fixedSize: Size.fromWidth(320),
                            fixedSize: MaterialStateProperty.all<Size>(Size.fromHeight(60)),
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[900]!)),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('곧 ${widget._shopName}${widget._snackBarSentence}'))),
                        child: Text('${widget._shopName}에게 Wine-Fi 입점을 요청하기')),
                  ))
            ],
          ),)
        ],));
  }
}
