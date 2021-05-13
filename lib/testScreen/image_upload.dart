import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _UploadState createState() => new _UploadState();
}

class _UploadState extends State<ImageUploadScreen> {
  List<Asset> images = List<Asset>();
  String _error;

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
    });
  }


  _uploadImage() async {
    if (images != null) {
      // string to uri
      Uri uri = Uri.parse(
          'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/image/upload');

      // create multipart request
      MultipartRequest request = http.MultipartRequest("POST", uri);

      for (Asset image in images) {
        ByteData byteData = await image.getByteData();
        List<int> imageData = byteData.buffer.asUint8List();

        MultipartFile multipartFile = MultipartFile.fromBytes(
          'files', //key of the api
          imageData,
          //filename: 'some-file-name.jpg',
          filename : image.name,
          contentType: MediaType("image", "jpeg"),
        );

        // add file to multipart
        request.files.add(multipartFile);
      }

      // send
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print(respStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            RaisedButton(
              child: Text("Upload selected images"),
              onPressed: _uploadImage,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}
