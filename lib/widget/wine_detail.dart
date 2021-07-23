import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:wine/inquiry/manual_inquiry.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/review/review_register.dart';
import 'package:wine/util/http.dart';
import 'package:wine/webview/webview_screen.dart';
import '../model/review.dart';

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

class _WineDetailState extends State<WineDetail>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;
  AnimationController? _hideFabAnimController;

  List<Widget> reviewList = [];

  bool isCreator = false;

  @override
  void dispose() {
    _scrollController!.dispose();
    _hideFabAnimController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1, // initially visible
    );

    _scrollController!.addListener(() {
      switch (_scrollController!.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController!.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController!.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getReviewList();
      _checkUserRole();
    });
  }

  void _checkUserRole() async {
    List<String>? roles = await getUserRoles();

    if(roles!.contains("ROLE_CREATOR")) {
      setState(() {
        isCreator = true;
      });
    }
  }
  
  ImageProvider<Object> _getSNSIcon(String sns) {
    switch(sns) {
      case 'YOUTUBE':
        return AssetImage("images/icon/youtube_icon.png");
      case 'NAVER':
        return AssetImage("images/icon/naver_icon.png");
      case 'INSTAGRAM':
        return AssetImage("images/icon/instagram_icon.png");
      default:
        return AssetImage("images/icon/youtube_icon.png");
    }
  }

  void _viewReview(BuildContext context, Review review) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            WebViewScreen(webTitle : review.prvAuthor! + " - " + review.prvTitle!,
                webUrl: review.prvUrl!))
    );
  }

  Future<void> _getReviewList() async {
    var response = await http_get(header: null, path: 'api/product/review/' + widget.wineItem!.wineId!.toString());

    print(response);

    if(response['code'] == 0) { //쿼리 결과가 있는 경우에만 수행
      List responseJson = response['list'];
      var responseList = responseJson;
      for (var reviewJson in responseList) {
        Review review = new Review.fromJson(reviewJson);
        setState(() {
          reviewList.add(
              new ListTile(
                leading: CircleAvatar(
                  backgroundImage: _getSNSIcon(review.prvMedia!),
                  // no matter how big it is, it won't overflow
                  backgroundColor: Colors.white,
                ),
                title: Text(review.prvTitle!),
                subtitle: Text('by ' + review.prvAuthor!),
                trailing: review.prvRecommend! == "Y" ? Text("추천") : Text(""),
                onTap: () => _viewReview(context, review),
              )
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController!,
        child: ScaleTransition(
          scale: _hideFabAnimController!,
          child: FloatingActionButton(
            backgroundColor: Colors.red[900],
            child: Text("문의"),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ManualInquiry(wineItem: widget.wineItem)));
            },
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //SizedBox(height: 40),
              Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  )),
              Container(
                  height: (MediaQuery.of(context).size.height / 10) * 4,
                  child: FullscreenSliderDemo(wineItem: widget.wineItem)),
              SizedBox(
                height: 3,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Image from ", style: TextStyle(fontSize: 9)),
                Text("VIVINO",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        color: Colors.red[900])),
              ]),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(
                          height: 2,
                        ),
                        Text(widget.wineItem!.wineName!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                              text: widget.wineItem!.wineType!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 15),
                              children: [
                                TextSpan(
                                    text: " From ",
                                    style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(
                                  text: widget.wineItem!.wineRegion!,
                                ),
                                TextSpan(
                                  text: " · ",
                                ),
                                TextSpan(
                                  text: widget.wineItem!.wineCountry!,
                                ),
                              ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text("와인 크리에이터 리뷰",
                            style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)
                          ),
                        ),
                        isCreator == true ?
                        RichText(
                            text: TextSpan(
                                text:"나의 리뷰 등록",
                                style: TextStyle(
                                  //decoration: TextDecoration.underline,
                                  //decorationColor: Colors.blue,
                                  color: Colors.black,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ReviewRegister(wineItem: this.widget.wineItem))
                                  );
                            },
                          )
                        ) : Text(""),
                        SizedBox(width: 10),
                      ]
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reviewList,
                    )
                  ],
                )
              ),
              SizedBox(height: 300),
              SizedBox(height: 300),
            ],
          ),),


        // floatingActionButton: Visibility(
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.red[900],
        //     child: Text("문의"),
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) =>
        //               ManualInquiry(wineItem: widget.wineItem)));
        //     },
        //   ),
        //   // visible: false,
        //   visible: true,
        // ),

      ),
    );
    // return SingleChildScrollView(controller: _scrollController, child: Scaffold(
    //     body: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         SizedBox(height: 40),
    //         Container(
    //             child: IconButton(
    //               icon: Icon(Icons.arrow_back, color: Colors.black),
    //               onPressed: () => Navigator.of(context).pop(),
    //             )),
    //         Container(
    //             height: (MediaQuery.of(context).size.height / 10) * 4,
    //             child: FullscreenSliderDemo(wineItem: widget.wineItem)),
    //         SizedBox(
    //           height: 3,
    //         ),
    //         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //           Text("Image from ", style: TextStyle(fontSize: 9)),
    //           Text("VIVINO",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 9,
    //                   color: Colors.red[900])),
    //         ]),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         Row(
    //           children: [
    //             SizedBox(
    //               width: 15,
    //             ),
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(widget.wineItem!.wineCompany!,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.w400, fontSize: 18)),
    //                   SizedBox(
    //                     height: 2,
    //                   ),
    //                   Text(widget.wineItem!.wineName!,
    //                       style: TextStyle(
    //                           fontWeight: FontWeight.bold, fontSize: 24)),
    //                   SizedBox(
    //                     height: 5,
    //                   ),
    //                   RichText(
    //                     text: TextSpan(
    //                         text: widget.wineItem!.wineType!,
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.black,
    //                             fontSize: 15),
    //                         children: [
    //                           TextSpan(
    //                               text: " From ",
    //                               style:
    //                               TextStyle(fontWeight: FontWeight.normal)),
    //                           TextSpan(
    //                             text: widget.wineItem!.wineRegion!,
    //                           ),
    //                           TextSpan(
    //                             text: " · ",
    //                           ),
    //                           TextSpan(
    //                             text: widget.wineItem!.wineCountry!,
    //                           ),
    //                         ]),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //     ),
    //     floatingActionButton: FadeTransition(
    //       opacity: _hideFabAnimController!,
    //       child: ScaleTransition(
    //         scale: _hideFabAnimController!,
    //         child: FloatingActionButton(
    //           backgroundColor: Colors.red[900],
    //           child: Text("문의"),
    //           onPressed: () {
    //             Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (context) =>
    //                     ManualInquiry(wineItem: widget.wineItem)));
    //           },
    //         ),
    //       ),
    //     )
    //
    //   // floatingActionButton: Visibility(
    //   //   child: FloatingActionButton(
    //   //     backgroundColor: Colors.red[900],
    //   //     child: Text("문의"),
    //   //     onPressed: () {
    //   //       Navigator.of(context).push(MaterialPageRoute(
    //   //           builder: (context) =>
    //   //               ManualInquiry(wineItem: widget.wineItem)));
    //   //     },
    //   //   ),
    //   //   // visible: false,
    //   //   visible: true,
    //   // ),
    //
    // ),);
  }
}
