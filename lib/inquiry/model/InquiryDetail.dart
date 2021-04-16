import 'package:flutter/material.dart';

class InquiryDetail extends StatefulWidget {

  final wine_name;
  final List<dynamic> inquiryInfo;

  const InquiryDetail({Key key, this.wine_name, this.inquiryInfo}) : super(key: key);

  @override
  _InqueryDetailState createState() => _InqueryDetailState();
}

class _InqueryDetailState extends State<InquiryDetail> {
  @override
  Widget build(BuildContext context) {

    print('shit-InquiryDetail-001');
    print(widget.inquiryInfo);
    print(widget.inquiryInfo.runtimeType);
    // print(widget.inquiryInfo['shop_name']);
    // print(widget.inquiryInfo['status']);
    // print(widget.inquiryInfo['contents']);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                )
            ),
            Container(
              child: Text(widget.wine_name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: widget.inquiryInfo.length,
                itemBuilder: (context, index) {
                  return ReplyTile(widget.inquiryInfo[index]);
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
      title: Text(_reply['shop_name']),
      subtitle: Text(_reply['status'] == 'waiting' ?  '답변을 기다리는 중' : _reply['contents']),
    );
  }
}

class Reply {
  String shop_id;
  String shop_name;
  String status;
  String contents;

  Reply(this.shop_id, this.shop_name, this.status, this.contents);
}