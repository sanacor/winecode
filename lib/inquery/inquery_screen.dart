import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:wine/inquery/model/InqueryTile.dart';
import 'package:http/http.dart' as http;


class inquery_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text('문의'),
          backgroundColor: Colors.white70,
          centerTitle: true,
          elevation: 0.0
      ),
      body: InqueryPage()
    );
    throw UnimplementedError();
  }

  }

  class InqueryPage extends StatefulWidget{
    @override
    _InqueryPageState createState() => _InqueryPageState();
  }


  class _InqueryPageState extends State<InqueryPage>{

    @override
    Widget build(BuildContext context)  {
      return FutureBuilder(
          initialData: [],
          future:_fetchInqueryData() ,
          builder: (context,snapshot){
            if( snapshot.connectionState == ConnectionState.done && snapshot.hasData){
              return ListView.separated(
                  itemCount: snapshot.data.length ,
                  itemBuilder: (context,index){
                    return InqueryTile(snapshot.data[index]);
                  },
                  separatorBuilder: (context, index){
                    return const Divider(thickness: 2,);
                  },
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
        }
      );
  }

    Future<List<InqueryInfo>> _fetchInqueryData() async {
      List<InqueryInfo> inqueryList = [];
      var url = 'https://9l885hmyfg.execute-api.ap-northeast-2.amazonaws.com/dev/inquiry';

      print("[fetchInqueryData] started fetch inquery data http request");

      try{
        var response = await http.get(
            Uri.encodeFull(url),
            headers: {
              "Accept": "application/json",
              "Content-Type":"application/json"
            }
        );

        if(response.statusCode == 200){
          List responseJson = json.decode(utf8.decode(response.bodyBytes));
          return responseJson.map((inqueryInfo) => new InqueryInfo.fromJson(inqueryInfo)).toList();
        }else{
          throw Exception('Failed to load InqueryInfo Data');
        }
      }catch(ex){
        print(ex);
      }

    }

}

