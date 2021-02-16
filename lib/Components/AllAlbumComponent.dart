import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/SubAlbumEvent.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllAlbumComponent extends StatefulWidget {
  var Assigned, Id;

  AllAlbumComponent(this.Assigned, this.Id);

  @override
  _AllAlbumComponentState createState() => _AllAlbumComponentState();
}

class _AllAlbumComponentState extends State<AllAlbumComponent> {
  bool _lights = false;
  ProgressDialog pr;
  bool isLoading = true;

  //final Color activeColor = Colors.green;

  @override
  void initState() {
    _getdata();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _getdata() async {
    if (widget.Assigned["IsSelected"].toString() == "1") {
      setState(() {
        _lights = true;
      });
    }
    // print("d${widget.NewList["IsSelected"]}");
    //  print("s${_lights}");
  }

  _saveCustomerAlbum() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var studioid=prefs.getString(Session.StudioId);
        var data = {
          "Id": studioid,
          "CustomerId": widget.Id,
          "GalleryId": widget.Assigned["Id"],
        };

        // print("Save Vendor Data = ${data}");
        Services.SaveCustomerAlbum(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
            _lights?
            Fluttertoast.showToast(
                msg: "Album Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT):
            Fluttertoast.showToast(
                msg: "Album Removed Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pop(context);
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else
        showMsg("No Internet Connection.");
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          elevation: 2,
          title: new Text("Error"),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubAlbumEvent(
                    widget.Assigned["Id"], widget.Assigned["Title"])));
        // Navigator.pushNamed(context, "/SubAlbumEvent");
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        //color: Colors.green,
        margin: EdgeInsets.all(7),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: widget.Assigned["GalleryCover"] != "" &&
                      widget.Assigned["GalleryCover"] != null
                  ? FadeInImage.assetNetwork(
                      placeholder: "",
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      fit: BoxFit.fill,
                      image: "${cnst.ImgUrl}" + widget.Assigned["GalleryCover"])
                  : Image.asset(
                      "images/no_image.png",
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
              /*ClipRRect(
                      //borderRadius: new BorderRadius.circular(6.0),

                      child: widget.GalleryData["GalleryCover"] != null
                          ? FadeInImage.assetNetwork(
                        placeholder: 'images/OM.png',
                        image:
                        "${cnst.ImgUrl}${widget.GalleryData["GalleryCover"]}",
                        fit: BoxFit.cover,
                      )
                          : Container(
                        color: Colors.grey[100],
                      ),
                    ),*/
            ),
            /*Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5)
                    ],
                  ),
                  borderRadius: new BorderRadius.all(Radius.circular(6)),
                ),
              ),*/
            Container(
              //height: 50,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 10, bottom: 10, top: 10),
                        child: Text(
                          "${widget.Assigned["Title"]}",
                          /* '${widget.GalleryData["Title"]}',*/
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      CupertinoSwitch(
                        value: _lights,
                        onChanged: (bool value) {
                          setState(() {
                            _lights = value;
                          });
                          //print("Switch-> "+value.toString());
                          _saveCustomerAlbum();
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
