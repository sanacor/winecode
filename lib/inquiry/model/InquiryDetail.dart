import 'package:flutter/material.dart';

class InquiryDetail extends StatefulWidget {


  final inquiryInfo;

  const InquiryDetail({Key key, this.inquiryInfo}) : super(key: key);

  @override
  _InqueryDetailState createState() => _InqueryDetailState();
}

class _InqueryDetailState extends State<InquiryDetail> {
  @override
  Widget build(BuildContext context) {

    print('shit');
    print(widget.inquiryInfo);
    print(widget.inquiryInfo.wine);

    return Scaffold(
      body: SafeArea(
        child: Container(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: () => Navigator.of(context).pop(),
            )
        ),
      ),
    );
  }
}