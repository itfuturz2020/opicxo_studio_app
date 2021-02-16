import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:opicxo_studio_app/Common/Constants.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageView extends StatefulWidget {


  var photo;

  ImageView(this.photo);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool downloading = false;

  ProgressDialog pr;
  String SelectedPin = "", PinSelection = "";

  TextEditingController edtPIN = new TextEditingController();

  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    //pr.setMessage('Please Wait');
    // TODO: implement initState
   // getLocalData();
    super.initState();
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Gallery'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AlbumAllImages(),
              ),
            ).then((value) {
              debugPrint(value);
              getLocalData();
            });*/
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height,
        child: Stack(
          /*crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,*/
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Center(
              child: PhotoView(
                imageProvider: NetworkImage(
                  //"${cnst.ImgUrl}" + widget.albumData[widget.albumIndex]["Photo"],
                  "${cnst.ImgUrl}${widget.photo}",
//                    fit: BoxFit.contain,
//                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height - 100,
                ),
                loadingChild: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
