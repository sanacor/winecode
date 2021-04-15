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
            )

          ],
        )
      ),
    );
  }
}