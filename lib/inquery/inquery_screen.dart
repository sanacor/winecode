import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wine/inquery/model/InqueryTile.dart';
import 'package:http/http.dart' as http;


class Inquery_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InqueryPage(),
    );
    throw UnimplementedError();
  }

  }

  class InqueryPage extends StatefulWidget{
    @override
    _InqueryPageState createState() => _InqueryPageState();
  }


  class _InqueryPageState extends State<InqueryPage>{
    List _data = [];

    _fetchInqueryData(){
      http.get('https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/inquiry').then(
          (response){
            if( response.statusCode == 200){
              String jsonString = response.body;
              print(jsonString);

              List inqueries = jsonDecode(jsonString);
              for( int i =0; i < inqueries.length; i++){
                var inquery = inqueries[i];
                InqueryInfo inqueryinfo = InqueryInfo.fromJson(inquery);

                setState(() {
                  _data.add(inqueryinfo);
                });
              }
            }else{
              print('Error');
            }
          }
      );
    }

    @override
    Widget build(BuildContext context)  {
      return Scaffold(
        appBar: AppBar(
          title: Text("HTTP&JSON"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh),
                onPressed:(){
                  _fetchInqueryData();
                }),
          ],
        ),
        body: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context,index){
             return InqueryTile(_data[index]);
            }),
      );
  }

    // Future<List<InqueryInfo>> _fetchInqueryData() async {
    //   List<InqueryInfo> inqueryList = [];
    //   var url = 'https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/inquiry';
    //
    //   print("[fetchInqueryData] started fetch inquery data http request");
    //
    //   try{
    //     var response = await http.get(
    //         Uri.encodeFull(url),
    //         headers: {
    //           "Accept": "application/json",
    //           "Content-Type":"application/json"
    //         }
    //     );
    //
    //     if(response.statusCode == 200){
    //       List responseJson = json.decode(response.body);
    //       print("[fetchInqueryData] responseJson is ");
    //       print(responseJson);
    //       return responseJson.map((inqueryInfo) => new InqueryInfo.fromJson(inqueryInfo)).toList();
    //     }else{
    //       throw Exception('Failed to load InqueryInfo Data');
    //     }
    //   }catch(ex){
    //     print(ex);
    //   }
    //
    // }

}

