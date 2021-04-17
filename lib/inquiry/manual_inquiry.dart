import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ManualInquiry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(color: Colors.red,);
    return Scaffold(
      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height / 25,
                )
              ],
            ),
          )),
    );
  }
}
