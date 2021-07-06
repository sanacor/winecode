import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wine/inquiry/manual_inquiry.dart';
import 'package:wine/model/wine.dart';

final List<String> imgList = [];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // borderRadius: BorderRadius.all(Radius.circular(5.0) ),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.fill, width: 1000.0),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
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
                )),
          ),
        ))
    .toList();

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class FullscreenSliderDemo extends StatelessWidget {
  final Wine? wineItem;

  const FullscreenSliderDemo({Key? key, this.wineItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    imgList.clear();
    imgList.add(wineItem!.wineImageURL!);

    return Scaffold(
      body: Builder(builder: (context) {
        final double height = (MediaQuery.of(context).size.height / 10) * 4;
        return Column(
          children: [
            Stack(
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: height,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    // autoPlay: false,
                  ),
                  items: imgList
                      .map((item) => SafeArea(
                              child: Container(
                            child: Center(
                                child: Image.network(item,
                                    fit: BoxFit.cover, height: height)),
                          )))
                      .toList(),
                ),
              ],
            )
          ],
        );
      }),
    );
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
              }),
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
      ]),
    );
  }
}

class WineDetail extends StatefulWidget {
  final Wine? wineItem;

  const WineDetail({Key? key, this.wineItem}) : super(key: key);

  @override
  _WineDetailState createState() => _WineDetailState();
}

class _WineDetailState extends State<WineDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
            )),
            Container(
                height: (MediaQuery.of(context).size.height / 10) * 4,
                child: FullscreenSliderDemo(wineItem: widget.wineItem)),
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Image from ",
                  style: TextStyle(fontSize: 9)
                ),
                Text("VIVINO",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9, color: Colors.red[900])
                ),
              ]
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.wineItem!.wineCompany!,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(widget.wineItem!.wineName!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      RichText(
                        text: TextSpan(
                            text: widget.wineItem!.wineType!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                            children: [
                              TextSpan(
                                  text: " From ",
                                  style: TextStyle(fontWeight: FontWeight.normal)
                              ),
                              TextSpan(
                                text: widget.wineItem!.wineRegion!,
                              ),
                              TextSpan(
                                text: " · ",
                              ),
                              TextSpan(
                                text: widget.wineItem!.wineCountry!,
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red[900],
          child: Text("문의"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ManualInquiry(wineItem: widget.wineItem)));
          },
        ),
      ),
    );
  }
}