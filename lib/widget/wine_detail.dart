import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:wine/inquiry/manual_inquiry.dart';
import 'package:wine/model/comment.dart';
import 'package:wine/model/wine.dart';
import 'package:wine/review/review_register.dart';
import 'package:wine/util/http.dart';
import 'package:wine/webview/webview_screen.dart';
import '../model/review.dart';
import 'package:flag/flag.dart';


Widget getCountryIcon(String country_name) {
  switch(country_name) {
    case "United States":
      return Flag.fromCode(FlagsCode.US, height: 20, width: 20);
    case "Canada":
      return Flag.fromCode(FlagsCode.CA, height: 20, width: 20);
    case "Spain":
      return Flag.fromCode(FlagsCode.ES, height: 20, width: 20);
    case "Chile":
      return Flag.fromCode(FlagsCode.CL, height: 20, width: 20);
    case "France":
      return Flag.fromCode(FlagsCode.FR, height: 20, width: 20);
    case "Austria":
      return Flag.fromCode(FlagsCode.AT, height: 20, width: 20);
    case "Portugal":
      return Flag.fromCode(FlagsCode.PT, height: 20, width: 20);
    case "Germany":
      return Flag.fromCode(FlagsCode.DE, height: 20, width: 20);
    case "Hungary":
      return Flag.fromCode(FlagsCode.HU, height: 20, width: 20);
    case "Italy":
      return Flag.fromCode(FlagsCode.IT, height: 20, width: 20);
    case "Argentina":
      return Flag.fromCode(FlagsCode.AR, height: 20, width: 20);
    case "Switzerland":
      return Flag.fromCode(FlagsCode.US, height: 20, width: 20);
    case "New Zealand":
      return Flag.fromCode(FlagsCode.CH, height: 20, width: 20);
    case "South Africa":
      return Flag.fromCode(FlagsCode.ZA, height: 20, width: 20);
  }
  return Flag.fromCode(FlagsCode.US, height: 20, width: 20);
}


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
  TextEditingController _textEditingController = TextEditingController();

  List<Widget> reviewList = [];
  List<Widget> commentList = [];

  bool isCreator = false;
  bool isRetailer = false;
  int? userId = null;


  @override
  void dispose() {
    _scrollController!.dispose();
    _hideFabAnimController!.dispose();
    _textEditingController.dispose();
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
      _getCommentList();
      _checkUserRole();
    });
  }

  void _checkUserRole() async {

    List<String>? roles = await getUserRoles();

    if(roles!.contains("ROLE_CREATOR")  ) {
      setState(() {
        isCreator = true;
      });
    }

    if(roles!.contains("ROLE_RETAILER") ) {

      var response = await http_get(header: null, path: 'api/user');

      print(response);

      int user_id = response['data']['user']['msrl'];

      setState(() {
        isRetailer = true;
        userId = user_id;
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

  Future<void> _getCommentList() async {
    commentList = [];
    var response = await http_get(header: null, path: 'api/product/comment/' + widget.wineItem!.wineId!.toString());

    print(response);

    if(response['code'] == 0) { //쿼리 결과가 있는 경우에만 수행
      List responseJson = response['list'];
      var responseList = responseJson;
      for (var commentJson in responseList) {
        Comment comment = new Comment.fromJson(commentJson);
        setState(() {
          commentList.add(
              new ListTile(
                /* 사용자 사진이 보이는게 맞나?? 익명성 보장이 너무 안될듯
                leading: CircleAvatar(
                  backgroundImage: _getSNSIcon(review.prvMedia!),
                  // no matter how big it is, it won't overflow
                  backgroundColor: Colors.white,
                ),
                 */
                title: Text(comment.pucUserComment!),
                subtitle: Text('by ' + comment.pucUsrNickname!),
                //trailing: comment.prvRecommend! == "Y" ? Text("추천") : Text(""),
                //onTap: () => _viewReview(context, review),
              )
          );
        });
      }
    }
  }

  Future<void> registerWineByRetailId(int wineId) async {
    var response = await http_post(header: null, path: 'api/retail/$userId/register/$wineId');

    if (response['success'] == true) {
      final snackBar = SnackBar(content: Text("와인샵에 와인등록 완료!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("와인샵에 와인등록 실패!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _registerComment(int wineId) async {
    if(_textEditingController.text == "") {
      final snackBar = SnackBar(content: Text("내용 입력 후 등록 부탁드립니다."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    Map<String, dynamic>? reqBody =
    {
      'pucUserComment': _textEditingController.text
    };
    _textEditingController.text = "";
    var response = await http_post(header: null, path: 'api/user/comment/$wineId', body:reqBody);

    if (response['success'] == true) {
      final snackBar = SnackBar(content: Text("평가 등록 완료! 소중한 의견 감사합니다 :)"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("평가 등록 실패!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    _getCommentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          isRetailer == true ? Positioned(
            right: 10,
            bottom: 160,
            child: FadeTransition(
              opacity: _hideFabAnimController!,
              child: ScaleTransition(
                scale: _hideFabAnimController!,
                child: FloatingActionButton(
                  backgroundColor: Colors.red[900],
                  child: Icon(Icons.add_business_outlined),
                  onPressed: () {registerWineByRetailId(this.widget.wineItem!.wineId!);},
                ),
              ),
            ),
          ) : Container(),
          isCreator == true ? Positioned(
            right: 10,
            bottom: 90,
            child: FadeTransition(
              opacity: _hideFabAnimController!,
              child: ScaleTransition(
                scale: _hideFabAnimController!,
                child: FloatingActionButton(
                  backgroundColor: Colors.red[900],
                  child: Icon(Icons.rate_review_outlined),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ReviewRegister(wineItem: this.widget.wineItem)));
                  },
                ),
              ),
            ),
          ) : Container(),
          Positioned(
            bottom: 20,
            right: 10,
            child: FadeTransition(
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
          ),
          // Add more floating buttons if you want
          // There is no limit
        ],
      ),
      // floatingActionButton: FadeTransition(
      //   opacity: _hideFabAnimController!,
      //   child: ScaleTransition(
      //     scale: _hideFabAnimController!,
      //     child: FloatingActionButton(
      //       backgroundColor: Colors.red[900],
      //       child: Text("문의"),
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (context) =>
      //                 ManualInquiry(wineItem: widget.wineItem)));
      //       },
      //     ),
      //   ),
      // ),
      body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                          height: 5,
                        ),
                        Text(widget.wineItem!.wineName!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24)),
                        SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          Container(child: getCountryIcon(widget.wineItem!.wineCountry!), margin: EdgeInsets.fromLTRB(0,5,5,5)),
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
                                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
                                    text: widget.wineItem!.wineRegion!,
                                  ),
                                  // TextSpan(
                                  //   text: " · ",
                                  // ),
                                  // TextSpan(
                                  //   text: widget.wineItem!.wineCountry!,
                                  // ),
                                ]),
                          )
                        ],),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Divider(height: 2, thickness: 1, color: Colors.grey, ),
              SizedBox(height: 11, child: Container(color: Colors.grey[200],),),
              Container(
                // color: Color(0xffF4F0DE),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Expanded(
                                    child: Text("와인 크리에이터 리뷰",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            // fontWeight: FontWeight.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20 )
                                    ),
                                  ),
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
                  ],
                ),
              ),
              SizedBox(height: 11, child: Container(color: Colors.grey[200],),),
              Container(
                // color: Color(0xffF4F0DE),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Expanded(
                                    child: Text("유저 코멘트",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            // fontWeight: FontWeight.normal,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20 )
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ]
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: commentList,
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20,0,20,0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '이 와인에 대한 평가를 남겨주세요.',
                        )
                      ),
                    ),
                    SizedBox(width: 5),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black, // foreground
                      ),
                      onPressed: () => _registerComment(widget.wineItem!.wineId!),
                      child: Text('등록'),
                    )
                  ],
                )
              ),
              SizedBox(height: 300),
              SizedBox(height: 300),
            ],
          ),),

      ),
    );

  }
}
