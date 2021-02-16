import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'Dashboard.dart';

class PhotoContestDescription extends StatefulWidget {
  @override
  _PhotoContestDescriptionState createState() =>
      _PhotoContestDescriptionState();
}

class _PhotoContestDescriptionState extends State<PhotoContestDescription> {
  ProgressDialog pr;
  bool isLoading = true;
  List NewList = [];
  File ContestImage;
  File profileImage;
  String _url = "";
  List bannerImage = ["images/photo_contest.png"];

  // bool isLoading = true;
  int _current = 0;

  @override
  void initState() {
    _getContest();
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

  _getContest() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetContest();
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              NewList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on NewLead Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
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

  pickProfile(source) async {
    var picture = await ImagePicker.pickImage(source: source);
    this.setState(() {
      ContestImage = picture;
    });
    Navigator.pop(context);
  }

  Future<void> _chooseprofilepic(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      pickProfile(ImageSource.gallery);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      pickProfile(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = "${tempDate[2].toString().substring(0, 2)}-"
              "${tempDate[1].toString().substring(0, 2)}-${tempDate[0].toString()}"
          .toString();
    }
    return final_date;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      },
      child: Scaffold(
        /*    appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    cnst.appPrimaryMaterialColorYellow,
                    cnst.appPrimaryMaterialColorPink
                  ],
                ),
              ),
            ),
            title: Text("Photo Conteset"),
            centerTitle: true,
          ),*/
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(

                children: [
                  Container(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset(
                        "images/2.png",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.only(top: 8,left: 6,right: 6),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 190,
                          width: MediaQuery.of(context).size.width ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: NewList[0]["Image"] != "" &&
                                  NewList[0]["Image"] != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: FadeInImage.assetNetwork(
                                      placeholder: "",
                                      width: MediaQuery.of(context).size.width,
                                      height: 150,
                                      fit: BoxFit.fill,
                                      image: "${cnst.ImgUrl}" +
                                          NewList[0]["Image"]),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Image.asset(
                                    "images/logo1.png",
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  ),
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
                        /* CarouselSlider(
                    height: 180,
                    viewportFraction: 0.9,
                    autoPlayAnimationDuration: Duration(milliseconds: 1500),
                    reverse: false,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlay: true,
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                    items: bannerImage.map((i) {
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: profileImage != null
                            ? Image.file(
                                profileImage,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fill,
                              )
                            : _url != "" && _url != null
                                ? FadeInImage.assetNetwork(
                                    placeholder: "images/user1.png",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                    image: "${cnst.ImgUrl}" + _url)
                                : Image.asset(
                                    "$i",
                                  ),
                        */ /* Image.asset(
                          "$i",
                          height: 125,
                          width: MediaQuery.of(context).size.width / 1.13,
                          fit: BoxFit.fill,
                        ),*/ /*
                      );

                      */ /*FadeInImage.assetNetwork(
                            placeholder: 'images/splash_screen.png',
                            image: i,
                            height: 125,
                            width: MediaQuery.of(context).size.width / 1.13,
                            fit: BoxFit.fill,
                          );*/ /*
                      */ /*Image.asset(i,
                                width: MediaQuery.of(context).size.width);*/ /*
                    }).toList(),
                  ),*/
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Description About Contest",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                child: Divider(
                                  height: 4,
                                  thickness: 1,
                                  color: Colors.grey,
                                  indent:
                                      MediaQuery.of(context).size.width / 100,
                                  endIndent:
                                      MediaQuery.of(context).size.width / 10,
                                ),
                              ),
                              Flexible(
                                child: Divider(
                                  height: 4,
                                  thickness: 1,
                                  color: Colors.grey,
                                  indent:
                                      MediaQuery.of(context).size.width / 10,
                                  endIndent:
                                      MediaQuery.of(context).size.width / 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Contest Name",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Text("${(NewList[0]["ContestName"])}"),
                                  ),
                                ),
                              ],
                            ),
                            /*Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Eding Date",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "${setDate(NewList[0]["EndDate"])}"),
                                  ),
                                ),
                              ],
                            ),*/
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Starting Date",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "${setDate(NewList[0]["StartDate"])}"),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Eding Date",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "${setDate(NewList[0]["EndDate"])}"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Contest  Fess",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      ":",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${NewList[0]["Fees"]}"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                         Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Upload Your Photo",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ":",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              height: MediaQuery.of(context).size.width / 11,
                              width: MediaQuery.of(context).size.width / 10,
                              decoration: BoxDecoration(
                                  borderRadius:

                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        cnst.appPrimaryMaterialColorYellow,
                                        cnst.appPrimaryMaterialColorPink
                                      ])),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                onPressed: () {
                                  _chooseprofilepic(context);
                                },
                                child: Text(
                                  "Add Photo",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),//mmmmmmmmm
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
