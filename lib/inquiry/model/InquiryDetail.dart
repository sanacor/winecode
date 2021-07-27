import 'package:flutter/material.dart';
import 'package:wine/map/model/wine_shop.dart';
import 'package:wine/map/wine_shop_detail.dart';
import 'package:wine/util/http.dart';
import 'package:wine/inquiry/model/InquiryTile.dart';

class InquiryDetail extends StatefulWidget {

  final inqPdtName;
  final List<dynamic>? replyInfo;
  final InquiryInfo? inquiryInfo;

  const InquiryDetail({Key? key, this.inqPdtName, this.replyInfo, this.inquiryInfo}) : super(key: key);

  @override
  _InquiryDetailState createState() => _InquiryDetailState();
}

class _InquiryDetailState extends State<InquiryDetail> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                )
            ),
            Row(
              children: [
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    text: "내가 문의한 와인",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  child: Expanded(
                      child: Image.network(widget.inquiryInfo!.inqPdtImage!, fit: BoxFit.fill)
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                      Text(widget.inquiryInfo!.inqPdtCompany!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 18)),
                      SizedBox(
                        height: 2,
                      ),
                      Text(widget.inquiryInfo!.inqPdtName!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 40),
            Row(
              children: [
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    text: "문의 내용",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: 20),
                Flexible(
                    child: Text(widget.inquiryInfo!.inqContents!)
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    text: "답변 내역",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: widget.replyInfo!.length,
                itemBuilder: (context, index) {
                  return ReplyTile(widget.replyInfo![index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider(thickness: 1);
                },
              ),
            )

          ],
        )
      ),
    );
  }
}

class ReplyTile extends StatelessWidget {
  ReplyTile(this._reply);

  final Map<String, dynamic> _reply;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.storefront_outlined),
      title: Text(_reply['rlyRtlName']),
      subtitle: Text(_reply['rlyStatus'] == 'Waiting' ?  '답변을 기다리는 중' : _reply['rlyContents']),
      onTap: () => pushShopDetail(context),
      // onTap: pushShopDetail(context),
    );
  }

  pushShopDetail(context) async {
    var response = await http_get(header: null, path: 'api/retail/${_reply['rlyRtlId']}');
    var wineShopInfo = response['data'];

    WineShop selectedWineShop = new WineShop.fromJson(wineShopInfo);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WineShopDetail(wineShopItem: selectedWineShop)));
  }
}

class Reply {
  int  rlyId;
  int rlyInqId;
  String rlyRtlId;
  String rlyRtlName;
  String rlyStatus;
  String rlyContents;
  String rlyTime;

  Reply(this.rlyId, this.rlyInqId, this.rlyRtlId, this.rlyRtlName, this.rlyStatus, this.rlyContents, this.rlyTime);
}