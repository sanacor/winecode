import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:wine/main.dart';
import 'package:wine/map/inquery_map.dart';
import 'package:wine/map/model/wine_shop.dart';


final List<String> imgList = [];


final List<Widget> imageSliders = imgList.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(5.0),
    child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: Stack(
          children: <Widget>[
            Image.network(item, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. ${imgList.indexOf(item)} image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        )
    ),
  ),
)).toList();


class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class FullscreenSliderDemo extends StatelessWidget {
  final WineShop wineShop;

  const FullscreenSliderDemo ({ Key key, this.wineShop }): super(key: key);

  @override
  Widget build(BuildContext context) {
    imgList.clear();
    imgList.add('https://assets.bonappetit.com/photos/5dcb33135a172900098302a0/master/w_2560%2Cc_limit/HLY-Wine-Shop-Thirties.jpg');

    return Scaffold(
      body: Builder(
          builder: (context) {
            final double height = (MediaQuery.of(context).size.height/10)*4;
            return Stack(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // autoPlay: false,
                  ),
                  items: imgList.map((item) => SafeArea(
                      child:Container(
                        child: Center(
                            child: Image.network(item, fit: BoxFit.cover, height: height)
                        ),
                      ))).toList(),
                ),
                SafeArea(child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                )),

              ],
            );
          }
      ),
    );
  }
}


class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            CarouselSlider(
              items: imageSliders,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((url) {
                int index = imgList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]
      ),
    );
  }
}

class WineShopDetail extends StatefulWidget {
  final WineShop wineShopItem;

  const WineShopDetail ({ Key key, this.wineShopItem }): super(key: key);

  @override
  _WineShopDetailState createState() => _WineShopDetailState();
}

class _WineShopDetailState extends State<WineShopDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FooterView(
        children:<Widget>[
          Container(
              height: MediaQuery.of(context).size.height/10*2,
              child: Wrap(
                children: <Widget> [
                  Container(
                      height: MediaQuery.of(context).size.height/10*4,
                      child: FullscreenSliderDemo(wineShop: widget.wineShopItem)),
                  Container(
                      height: MediaQuery.of(context).size.height/10*4,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                          child: Wrap(
                            children: <Widget> [
                              Text(widget.wineShopItem.retail_name, style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20)),
                              Text(widget.wineShopItem.retail_phone, style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20)),
                              Text(widget.wineShopItem.retail_address, style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 20)),
                            ]
                          )
                      )
                  )
                ],
              )
          )
        ],
        footer: new Footer(
          child: InkWell(
            onTap: () {
              // navigationBar.onTap(1);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => InqueryMapScreen()));
            },
            child: Center(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text('와인샵에 전화하기', style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 15))
                )
            ),
          ),
        ),
        flex: 1, //default flex is 2
      ),
    );

  }
}