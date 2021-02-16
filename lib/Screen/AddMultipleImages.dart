import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'dart:async';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddMultipleImages extends StatefulWidget {
  String GalleryId="",FolderName="",albumid="";
  Function newdataaddedd;
  AddMultipleImages({this.GalleryId,this.FolderName,this.newdataaddedd,this.albumid});
  @override
  _AddMultipleImagesState createState() => new _AddMultipleImagesState();
}

class _AddMultipleImagesState extends State<AddMultipleImages> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  var file;
  String basename="";
  List<String> filename;
  List files = [];
  int n=0;
  getImageFileFromAsset(String path) async{
    File file = File(path);
    basename = file.path;
    filename = basename.split("/");
     n = filename.length;
    print(filename[n-1]);
    return file;
  }

  _uploadImages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String studioId = prefs.getString(Session.StudioId);
        var data;
        print("images");
        print(images);
        String img = '';
        for (int i = 0; i < images.length; i++) {
          var path2 = await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
          file = await getImageFileFromAsset(path2);
          print("file");
          print(file);
          List<int> imageBytes = await file.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          img = base64Image;
          data = {
            'fileType': "AlbumPhotos",
            'albumid' :widget.albumid.toString(),
            'FolderName': widget.FolderName,
            'galleryId': widget.GalleryId,
            'imagecode': img.toString(),
            'filename' : filename[n-1].toString()
          };
          print(data);
          FormData formData = new FormData.fromMap(data);
          Services.SaveGallery(formData, name: "UploadPhotos").then((
              data) async {
            print("data");
            print(data);
            if (data["ResultData"]["Data"]=="1") {
              showMsg("Images Added Successfully");
              widget.newdataaddedd("dataaddedd");
            }
          }, onError: (e) {
            print(e.toString());
            showMsg("Try Again");
          });
        }
      }
    } on SocketException catch (_) {
      //pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  Widget buildGridView() {
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
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
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
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        appBar: new AppBar(
          title: const Text('Add Images'),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                RaisedButton(
                  child: Text("Pick images",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: loadAssets,
                ),
                RaisedButton(
                  child: Text("Upload images",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _uploadImages,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
            ),
            Expanded(
              child: buildGridView(),
            ),
          ],
      ),
    );
  }
}