import 'package:flutter/material.dart';

class InquiryDetail extends StatefulWidget {

  final inqPdtName;
  final List<dynamic> replyInfo;

  const InquiryDetail({Key key, this.inqPdtName, this.replyInfo}) : super(key: key);

  @override
  _InqueryDetailState createState() => _InqueryDetailState();
}

class _InqueryDetailState extends State<InquiryDetail> {
  @override
  Widget build(BuildContext context) {

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
              child: Text(widget.inqPdtName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: widget.replyInfo.length,
                itemBuilder: (context, index) {
                  return ReplyTile(widget.replyInfo[index]);
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
      subtitle: Text(_reply['rlyStatus'] == 'Waiting' ?  '답변을 기다리는 중' : _reply['contents']),
    );
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