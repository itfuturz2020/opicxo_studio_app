import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/AllAlbum.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Components/SaveAlbum.dart';
class CustomerListComponent extends StatefulWidget {
  var NewList;
  int redeemoffers=0;

  CustomerListComponent(this.NewList,{this.redeemoffers});

  @override
  _CustomerListComponentState createState() => _CustomerListComponentState();
}

class _CustomerListComponentState extends State<CustomerListComponent> {
  String emailid, mobile, url, StudioId,Name;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  ProgressDialog pr;
  TextEditingController txtfoldername = new TextEditingController();

  @override
  void initState() {
    _getdata();
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
  }

  _getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(widget.redeemoffers!=0) {
        emailid = prefs.getString(cnst.Session.Email);
        mobile = prefs.getString(cnst.Session.Mobile);
        StudioId = prefs.getString(cnst.Session.StudioId);
        Name = prefs.getString(cnst.Session.Name);
        url = widget.NewList["Image"];
      }
    });

    //print("Helloworld => " + widget.NewList["CustomerId"].toString());
  }

  showMsg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Add Folder"),
          content: Form(
            key: _formkey,
            child: Column(
              children: [
            TextFormField(
            decoration: InputDecoration(
            labelText: 'Name Folder',
            ),
              controller: txtfoldername,
              validator: (value) {
                if (value.trim() == "") {
                  return 'Please Enter Name Of Your Folder';
                }
                return null;
              },
        ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    _showPicker(context);
                  },
                  child: _image != null || _image!=""
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      _image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      :Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50)),
                    width: 100,
                    height: 100,
                    child: Center(
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text("Add File"),
                          ],
                        ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  child: RaisedButton(
                    onPressed: (){
                      if (!_formkey.currentState.validate()) {
                        return 'Please Enter Name Of Your Folder';
                      }
                    },
                    color: Colors.pink,
                    child: Text("Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        );
      },
    );
  }

  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: .0),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  widget.redeemoffers!=0 ? MaterialPageRoute(
                      builder: (context) =>
                          AllAlbum(
                              widget
                                  .NewList["Id"],
                              StudioId)):null);
            },
            child: Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipOval(
                                child: url != "" && url != null
                                    ? FadeInImage.assetNetwork(
                                        placeholder: "images/user1.png",
                                        height: 40.0,
                                        width: 40.0,
                                        fit: BoxFit.fill,
                                        image: "${cnst.ImgUrl}" + "$url")
                                    : Image.asset(
                                        "images/man.png",
                                        height: 40.0,
                                        width: 40.0,
                                      ),
                              ),
                              /*Image.asset(
                                "images/man.png",
                                width: 50,
                                height: 50,
                              ),*/
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.person,
                                          size: 15,
                                          color: cnst.appPrimaryMaterialColorPink,
                                        ),
                                        Text(
                                          "${widget.NewList["Name"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.camera_alt,
                                            color:
                                                cnst.appPrimaryMaterialColorPink,
                                            size: 15,
                                          ),
                                          widget.redeemoffers!=0 ? Text(
                                            " ${widget.NewList["SelectedPhotos"]}/${widget.NewList["TotalPhotos"]}",
                                            style: TextStyle(fontSize: 14),
                                          ):Container(),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 0.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              print("tapped");
                                              Navigator.push(context, MaterialPageRoute(builder:
                                              (context) => SaveAlbum(),
                                              ));
                                            },
                                            child: Icon(
                                              Icons.add,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              _launchURL('', '', '');
                                            },
                                            child: Image.asset(
                                              "images/gmail.png",
                                              width: 25,
                                              height: 60,
                                            ),

                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              launch(
                                                  'tel:${widget.NewList["Mobile"]}');
                                            },
                                            child: Image.asset(
                                              "images/telephone.png",
                                              width: 25,
                                              height: 60,
                                              
                                            ),

                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              FlutterOpenWhatsapp.sendSingleMessage(
                                                  "+91${widget.NewList["Mobile"]}",
                                                  "Hello ${widget.NewList["Name"]} \n Now you can view your photos on your mobile by just downloading the app from the below link \n http://tinyurl.com/y2vnvfnb \n Your Login Credentials \n Username : ${widget.NewList["UserName"]} \n Password : ${widget.NewList["Password"]} \n Regards ${Name.toString()}");
                                            },
                                            child: Image.asset(
                                              "images/whatsapp.png",
                                              width: 45,
                                              height: 60,
                                            ),

                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.04,
                                        ),
                                         GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  widget.redeemoffers!=0 ? MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllAlbum(
                                                              widget
                                                                  .NewList["Id"],
                                                              StudioId)):null);
                                              /*Navigator.pushNamed(
                                                  context, "/AllAlbum");*/
                                            },
                                            child: Image.asset(
                                              "images/camera.png",
                                              width: 30,
                                              height: 60,
                                            ),

                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          widget.NewList["Selected"].toString() == "1"
                              ? Container(
                                  margin: EdgeInsets.all(8),
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cnst.appPrimaryMaterialColorPink,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 19,
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.all(5),
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.6),
                                      border: Border.all(
                                          color: cnst.appPrimaryMaterialColorPink,
                                          width: 2)),
                                ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cnst.appPrimaryMaterialColorPink,
                                    border: Border.all(
                                        color: cnst.appPrimaryMaterialColorPink,
                                        width: 2)),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),*/
                        ],
                      ),
                    ),

                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("",),
                      ],
                    )*/

                    /*   Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Selection : ",
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          " Pending",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        */ /*Text(
                          " Done",
                          style: TextStyle(color: Colors.green,fontWeight: FontWeight.w700,fontSize: 15),
                        ),*/ /*
                      ],
                    ),*/
                  ],
                ),
              ),
            ),

            /*Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          "images/man.png",
                          width: 60,
                          height: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    size: 15,
                                    color: cnst.appPrimaryMaterialColorPink,
                                  ),
                                  Text(
                                    " Raj Sharma",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.camera_alt,
                                      color: cnst.appPrimaryMaterialColorPink,
                                      size: 15,
                                    ),
                                    Text(
                                      " Photos : " + "500/250",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    "images/gmail.png",
                                    width: 25,
                                    height: 60,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Image.asset(
                                      "images/telephone.png",
                                      width: 25,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Image.asset(
                                      "images/whatsapp.png",
                                      width: 45,
                                      height: 60,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/AllAlbum");
                                      },
                                      child: Image.asset(
                                        "images/camera.png",
                                        width: 30,
                                        height: 60,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                child: Text("sdsd"),
                                alignment: Alignment.bottomLeft,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
          ),
        ],
      ),
    );
  }
}

_launchURL(String toMailId, String subject, String body) async {
  var url = 'mailto:$toMailId?subject=$subject&body=$body';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _makeCall() async {
  const phonenumber = "tel:";

  if (await canLaunch(phonenumber)) {
    await launch(phonenumber);
  } else {
    throw 'Could not call';
  }
}
