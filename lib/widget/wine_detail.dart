import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:wine/model/wine.dart';


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
  final Wine wine_item;

  const FullscreenSliderDemo ({ Key key, this.wine_item }): super(key: key);

  @override
  Widget build(BuildContext context) {
    imgList.clear();
    imgList.add(wine_item.wine_image_url);

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

class WineDetail extends StatefulWidget {
  final Wine wine_item;

  const WineDetail ({ Key key, this.wine_item }): super(key: key);

  @override
  _WineDetailState createState() => _WineDetailState();
}

class _WineDetailState extends State<WineDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FullscreenSliderDemo(wine_item: widget.wine_item)
    );
  }
}

