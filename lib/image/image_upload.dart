import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import 'package:image_picker/image_picker.dart';

import 'model/ImageUploadModel.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key key}) : super(key: key);
  @override
  ImageUploadScreenState createState() {
    return ImageUploadScreenState();
  }
}

class ImageUploadScreenState extends State<ImageUploadScreen> {
  List<Object> images = [];
  File _imageFile;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      images.add("Add Image");
      //images.add("Add Image");
      //images.add("Add Image");
      //images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        body: Column(
          children: <Widget>[
            /*
            RaisedButton(
              child: Text("Upload selected images"),
              onPressed: () => uploadImage('api/image/upload', 1),
            ),
             */
            Center(
                child: Container(
              width: 150,
              height: 150.0,
              child: buildGridView(),
            )),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      //crossAxisCount: 3,
      crossAxisCount: 1,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  File(uploadModel.imageFile.path),
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null)
      _imageFile = File(pickedFile.path);
    else
      return;
    setState(() {
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
    setState(() {
      ImageUploadModel imageUpload = new ImageUploadModel();
      imageUpload.isUploaded = false;
      imageUpload.uploading = false;
      imageUpload.imageFile = _imageFile;
      imageUpload.imageUrl = '';
      images.replaceRange(index, index + 1, [imageUpload]);
    });
  }

  Future<String> uploadImage() async {
    if (images != null &&
    images[0] is ImageUploadModel) {
      // string to uri
      Uri uri = Uri.parse(
          'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/image/upload');

      // create multipart request
      MultipartRequest request = http.MultipartRequest("POST", uri);

      for (var i = 0; i < images.length; i++) {
        if (images[i] is ImageUploadModel) {
          ImageUploadModel imageModel = images[i];
          File imageFile = imageModel.imageFile;
          List<int> imageData = await imageFile.readAsBytes();

          MultipartFile multipartFile = MultipartFile.fromBytes(
            'files', //key of the api
            imageData,
            //filename: 'some-file-name.jpg',
            filename: basename(imageFile.path),
            contentType: MediaType("image", "jpeg"),
          );

          // add file to multipart
          request.files.add(multipartFile);
        }
      }

      // send
      var response = await request.send();
      //final respStr = await response.stream.bytesToString();
      //print(respStr);
      var responseJson = json.decode(utf8.decode(await response.stream.toBytes()));
      print(responseJson);
      return 'http://ec2-13-124-23-131.ap-northeast-2.compute.amazonaws.com:8080/api/image/view/' + responseJson['list'][0].toString();
    }
    return "http://images.vivino.com/thumbs/default_label_150x200.jpg";
  }
}

/*
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
*/
