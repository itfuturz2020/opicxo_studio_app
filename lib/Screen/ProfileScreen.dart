import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/ClassList.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Dashboard.dart';

class ProfileScreen extends StatefulWidget {
  String url;

  ProfileScreen({this.url});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProgressDialog pr;

  String name = '';
  String cardData;

  bool isLoading = false;
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  double _inputHeight = 50;
  final TextEditingController txtBio = TextEditingController();


  String Id, Name, Email, Mobile;
  File profileImage;
  String _url = "";

  @override
  void initState() {
    _getData();

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
    //_getLocalData();
  }



  _checkDigitalCardMember(String type) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String Mobile = prefs.getString(cnst.Session.Mobile);
      String name = prefs.getString(cnst.Session.Name);
      String email = prefs.getString(cnst.Session.Email);
      /*setState(() {
        name = prefs.getString(cnst.Session.Name);
        // Email = prefs.getString(cnst.Session.Email);
        //   Mobile = prefs.getString(cnst.Session.Mobile);
      });*/
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.CheckDigitalCardMember(Mobile,name,email);
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              cardData = data;
              // print("Card Id: ${cardData}");
            });
            if (type == "yes") {
              String profileUrl = cnst.profileUrl.replaceAll("#id", cardData);
              if (await canLaunch(profileUrl)) {
                await launch(profileUrl);
              } else {
                throw 'Could not launch $profileUrl';
              }
            }
          } else {
            setState(() {
              isLoading = false;
            });
            //showMsg("Try Again.");
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Id = prefs.getString(cnst.Session.Id);
      txtName.text = prefs.getString(cnst.Session.Name);
      txtMobile.text = prefs.getString(cnst.Session.Mobile);
      _url = prefs.getString(cnst.Session.Image);
      txtEmail.text = prefs.getString(cnst.Session.Email);
      txtPassword.text = prefs.getString(cnst.Session.Password);
      txtBio.text = prefs.getString(cnst.Session.Bio);
    });
  }

  _updatePhotgrapherData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String id = preferences.getString(cnst.Session.Id);
        setState(() {
          isLoading = true;
        });
        print("Success1-->>");
        Future res = Services.UpdatePhotgrapherData(
            id, txtName.text, txtMobile.text, txtEmail.text,txtPassword.text,txtBio.text);
        res.then((data) async {
          print("Success2-->>");
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            print("Success3-->>");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.Name, "${txtName.text}");
            await prefs.setString(cnst.Session.Mobile, "${txtMobile.text}");
            await prefs.setString(cnst.Session.Email, "${txtEmail.text}");
            await prefs.setString(cnst.Session.Password, "${txtPassword.text}");
            await prefs.setString(cnst.Session.Bio, "${txtBio.text}");
            Fluttertoast.showToast(
                msg: "Profile Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
            Navigator.pushReplacementNamed(context, "/Dashboard");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Login Call $e");
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  _updatePhotographerPhoto() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        String filename = "";
        String filePath = "";
        File compressedFile;
        if (profileImage != null) {
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(profileImage.path);

          compressedFile = await FlutterNativeImage.compressImage(
            profileImage.path,
            quality: 80,
            targetWidth: 600,
            targetHeight: (properties.height * 600 / properties.width).round(),
          );

          filename = profileImage.path.split('/').last;
          filePath = compressedFile.path;
        }

        SharedPreferences preferences = await SharedPreferences.getInstance();
        FormData data = FormData.fromMap({
          "Id": "${preferences.getString(cnst.Session.Id)}",
          "Image": (filePath != null && filePath != '')
              ? await MultipartFile.fromFile(filePath,
                  filename: filename.toString())
              : null,
        });

        Services.UpdatePhotographerPhoto(data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            profileImage != null
                ? await prefs.setString(cnst.Session.Image, "${data.Data}")
                : null;
            Fluttertoast.showToast(
                msg: "Image Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
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
      profileImage = picture;
    });
    Navigator.pop(context);
    _updatePhotographerPhoto();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      },
      child: Scaffold(
         resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: GestureDetector(
                onTap: () {
                  _checkDigitalCardMember("yes");
                },
                child: Image.asset(
                  "images/visiting-card.png",
                  height: 40,
                  width: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          ),
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
          centerTitle: true,
          title: Text(
            "Profile",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
        body: Stack(
          children: [
          Container(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    "images/orangeprofile.jfif",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
      Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
                                    height: MediaQuery.of(context).size.width / 12,
                                    width: MediaQuery.of(context).size.width / 3.5,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
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
                                        "Edit Photo",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
        ),
      ),
       Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(top: 25.0),
             child: Align(
               alignment: Alignment.topCenter,
               child: Container(
                 child: ClipOval(
                     child: profileImage != null
                         ? Image.file(
                       profileImage,
                       width: 100,
                       height: 100,
                       fit: BoxFit.fill,
                     )
                         : _url != "" && _url != null
                         ? FadeInImage.assetNetwork(
                         placeholder:
                         "images/person.png",
                         width: 110,
                         height: 110,
                         fit: BoxFit.fill,
                         image:
                         "${cnst.ImgUrl}" + _url)
                         : Image.asset(
                       "images/person.png",
                       width: 100,
                       height: 100,
                       fit: BoxFit.fill,
                     )),
               ),
             ),
           ),
           SizedBox(
             height: 8,
           ),
           Padding(
               padding: const EdgeInsets.only(
                   top: 6.0, left: 120.0, right: 120),
               child: Container(
                 height: 35,
                 child: TextFormField(
                   controller: txtName,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                       fillColor: Colors.grey[200],
                       contentPadding: EdgeInsets.only(
                           top: 5,
                           left: 10,
                           bottom: 5),
                       focusedBorder: OutlineInputBorder(
                           borderRadius:
                           BorderRadius.all(
                               Radius.circular(5)),
                           borderSide: BorderSide(
                               width: 0,
                               color: Colors.white)),
                       enabledBorder: OutlineInputBorder(
                           borderRadius:
                           BorderRadius.all(
                               Radius.circular(4)),
                           borderSide: BorderSide(
                               width: 0,
                               color: Colors.white)),
                       hintText: 'Your Full Name',
                       hintStyle: TextStyle(
                           color: Colors.white,
                           fontSize: 14)),
                 ),
               ),
             ),
           SizedBox(
             height: 25,
           ),
           Stack(
             children: [
               Padding(
                 padding: const EdgeInsets.only(left:8.0),
                 child: Container(
                   height: 438,
                   width: 378,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(20),
                   ),
                   child: Card(
                     color: Colors.white,
                   ),
                 ),
               ),
               Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top:12.0,right: 280),
                     child: Text("Your Bio",
                       style: TextStyle(
                         color: Colors.red,
                         fontWeight: FontWeight.bold,
                         fontSize: 17,
                       ),
                     ),
                   ),
                   SizedBox(
                     height: 5,
                   ),
                   // Container(
                   //   width: 360,
                   //   decoration: BoxDecoration(
                   //     border: Border.all(
                   //       width: 1,
                   //       color: Colors.grey,
                   //     ),
                   //   ),
                   // ),
                    Padding(
                                                     padding: const EdgeInsets.only(
                                                         top: 6.0, left: 20.0, right: 35),
                                                     child: Container(
                                                       height: 85,
                                                       color: Colors.black12,
                                                       child:  Padding(
                                                         padding: const EdgeInsets.all(8.0),
                                                         child: TextField(
                                                           controller: txtBio,
                                                           textInputAction: TextInputAction.newline,
                                                           keyboardType: TextInputType.multiline,
                                                           maxLines: 3,
                                                           // decoration: InputDecoration(
                                                           //   labelText: "Your Bio",
                                                           //   labelStyle: TextStyle(
                                                           //     color: Colors.black,
                                                           //     fontSize: 15,
                                                           //   ),
                                                           // ),
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                   SizedBox(
                     height: 20,
                   ),
                   Padding(
                     padding: const EdgeInsets.only(
                         top: 6.0, left: 20.0, right: 35),
                     child: Container(
                       height: 45,
                       color: Colors.black12,
                       child:  Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextField(
                           controller: txtPassword,
                           textInputAction: TextInputAction.newline,
                           keyboardType: TextInputType.multiline,
                           maxLines: 3,
                           decoration: InputDecoration(
                             labelText: "Your Password",
                             labelStyle: TextStyle(
                               color: Colors.black,
                               fontSize: 20,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(
                     height: 30,
                   ),
                   Padding(
                     padding: const EdgeInsets.only(top:12.0,right: 240,left: 15),
                     child: Text("Contact Details",
                       style: TextStyle(
                         color: Colors.red,
                         fontWeight: FontWeight.bold,
                         fontSize: 17,
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(
                         top: 6.0, left: 20.0, right: 35),
                     child: Container(
                       height: 45,
                       color: Colors.black12,
                       child:  Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextField(
                           controller: txtEmail,
                           textInputAction: TextInputAction.newline,
                           keyboardType: TextInputType.multiline,
                           maxLines: 3,
                           decoration: InputDecoration(
                             labelText: "Your Email",
                             labelStyle: TextStyle(
                               color: Colors.black,
                               fontSize: 20,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(
                         top: 6.0, left: 20.0, right: 35),
                     child: Container(
                       height: 45,
                       color: Colors.black12,
                       child:  Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: TextField(
                           controller: txtMobile,
                           textInputAction: TextInputAction.newline,
                           keyboardType: TextInputType.multiline,
                           maxLines: 3,
                           decoration: InputDecoration(
                             labelText: "Your Mobile No.",
                             labelStyle: TextStyle(
                               color: Colors.black,
                               fontSize: 20,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),

                                               Container(
                                                 margin: EdgeInsets.only(top: 20),
                                                 height:
                                                     MediaQuery.of(context).size.width / 9,
                                                 width:
                                                     MediaQuery.of(context).size.width / 2.2,
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.all(
                                                         Radius.circular(15)),
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
                                                     if (!isLoading)
                                                       _updatePhotgrapherData();
                                                   },
                                                   child: isLoading
                                                       ? CircularProgressIndicator(
                                                           valueColor:
                                                               new AlwaysStoppedAnimation<
                                                                   Color>(Colors.white),
                                                         )
                                                       : Text(
                                                           "Update Profile",
                                                           style: TextStyle(
                                                               color: Colors.white,
                                                               fontSize: 17.0,
                                                               fontWeight: FontWeight.w600),
                                                         ),
                                                 ),
                                               ),
                                             ],
                                           ),
                 ],
               ),
             ],



       ),
          ],
    //                             ),
    //                           ),
    // ],
        ),
        // body: Stack(
        //   children: [
        //     Container(
        //       child: Opacity(
        //         opacity: 0.3,
        //         child: Image.asset(
        //           "images/profilebackground.jpg",
        //           width: MediaQuery.of(context).size.width,
        //           height: MediaQuery.of(context).size.height,
        //           fit: BoxFit.fill,
        //         ),
        //       ),
        //     ),
        //     SingleChildScrollView(
        //       child: Column(
        //         children: <Widget>[
        //           Column(
        //             children: <Widget>[
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 60.0),
        //                 child: Container(
        //                   child: Column(
        //                     children: <Widget>[
        //                       Center(
        //                         child: Padding(
        //                           padding: const EdgeInsets.all(8.0),
        //                           child: Container(
        //                             child: ClipOval(
        //                                 child: profileImage != null
        //                                     ? Image.file(
        //                                         profileImage,
        //                                         width: 100,
        //                                         height: 100,
        //                                         fit: BoxFit.fill,
        //                                       )
        //                                     : _url != "" && _url != null
        //                                         ? FadeInImage.assetNetwork(
        //                                             placeholder:
        //                                                 "images/person.png",
        //                                             width: 100,
        //                                             height: 100,
        //                                             fit: BoxFit.fill,
        //                                             image:
        //                                                 "${cnst.ImgUrl}" + _url)
        //                                         : Image.asset(
        //                                             "images/person.png",
        //                                             width: 100,
        //                                             height: 100,
        //                                             fit: BoxFit.fill,
        //                                           )),
        //                           ),
        //                         ),
        //                       ),
        //                       Container(
        //                         height: MediaQuery.of(context).size.width / 12,
        //                         width: MediaQuery.of(context).size.width / 3.5,
        //                         decoration: BoxDecoration(
        //                             borderRadius:
        //                                 BorderRadius.all(Radius.circular(15)),
        //                             gradient: LinearGradient(
        //                                 begin: Alignment.topLeft,
        //                                 end: Alignment.bottomRight,
        //                                 colors: [
        //                                   cnst.appPrimaryMaterialColorYellow,
        //                                   cnst.appPrimaryMaterialColorPink
        //                                 ])),
        //                         child: MaterialButton(
        //                           shape: RoundedRectangleBorder(
        //                               borderRadius:
        //                                   new BorderRadius.circular(9.0)),
        //                           onPressed: () {
        //                             _chooseprofilepic(context);
        //                           },
        //                           child: Text(
        //                             "Edit Photo",
        //                             style: TextStyle(
        //                                 color: Colors.white,
        //                                 fontSize: 14.0,
        //                                 fontWeight: FontWeight.w600),
        //                           ),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(top: 30.0),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Chip(
        //                                 backgroundColor: Colors.black38,
        //                                 padding: const EdgeInsets.symmetric(
        //                                     vertical: 13, horizontal: 5),
        //                                 shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(25),
        //                                         bottomRight:
        //                                             Radius.circular(25))),
        //                                 label: Icon(
        //                                   Icons.person,
        //                                   size: 17,
        //                                   color: Colors.white,
        //                                 )),
        //                             Expanded(
        //                               flex: 3,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 2.0, left: 8.0),
        //                                 child: Text(
        //                                   "Name",
        //                                   style: TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 1,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.all(6.0),
        //                                 child: Text(
        //                                   ":",
        //                                   style: TextStyle(
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 8,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 6.0, left: 8.0, right: 5),
        //                                 child: Container(
        //                                   height: 35,
        //                                   child: TextFormField(
        //                                     controller: txtName,
        //                                     keyboardType: TextInputType.text,
        //                                     decoration: InputDecoration(
        //                                         fillColor: Colors.grey[200],
        //                                         contentPadding: EdgeInsets.only(
        //                                             top: 5,
        //                                             left: 10,
        //                                             bottom: 5),
        //                                         focusedBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(5)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         enabledBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(4)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         hintText: 'Enter Full Name',
        //                                         hintStyle: TextStyle(
        //                                             color: Colors.grey,
        //                                             fontSize: 14)),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(top: 20.0),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Chip(
        //                                 backgroundColor: Colors.black38,
        //                                 padding: const EdgeInsets.symmetric(
        //                                     vertical: 13, horizontal: 5),
        //                                 shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(25),
        //                                         bottomRight:
        //                                             Radius.circular(25))),
        //                                 label: Icon(
        //                                   Icons.phone_android,
        //                                   size: 17,
        //                                   color: Colors.white,
        //                                 )),
        //                             Expanded(
        //                               flex: 3,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 2.0, left: 8.0),
        //                                 child: Text(
        //                                   "Mobile No",
        //                                   style: TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 1,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.all(6.0),
        //                                 child: Text(
        //                                   ":",
        //                                   style: TextStyle(
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 8,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 6.0, left: 8.0, right: 5),
        //                                 child: Container(
        //                                   height: 35,
        //                                   color: Colors.black38,
        //                                   child: TextFormField(
        //                                     readOnly: true,
        //                                     controller: txtMobile,
        //                                     keyboardType:
        //                                         TextInputType.emailAddress,
        //                                     decoration: InputDecoration(
        //                                         fillColor: Colors.black26,
        //                                         contentPadding: EdgeInsets.only(
        //                                             top: 5,
        //                                             left: 10,
        //                                             bottom: 5),
        //                                         focusedBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(5)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color:
        //                                                     Colors.grey[500])),
        //                                         enabledBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(4)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color:
        //                                                     Colors.grey[500])),
        //                                         hintText: 'Enter Mobile No',
        //                                         hintStyle: TextStyle(
        //                                             color: Colors.grey[500],
        //                                             fontSize: 14)),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.only(top: 20.0),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Chip(
        //                                 backgroundColor: Colors.black38,
        //                                 padding: const EdgeInsets.symmetric(
        //                                     vertical: 13, horizontal: 5),
        //                                 shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(25),
        //                                         bottomRight:
        //                                             Radius.circular(25))),
        //                                 label: Icon(
        //                                   Icons.email,
        //                                   size: 17,
        //                                   color: Colors.white,
        //                                 )),
        //                             Expanded(
        //                               flex: 3,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 2.0, left: 8.0),
        //                                 child: Text(
        //                                   "User Name",
        //                                   style: TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 1,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.all(6.0),
        //                                 child: Text(
        //                                   ":",
        //                                   style: TextStyle(
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 8,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 6.0, left: 8.0, right: 5),
        //                                 child: Container(
        //                                   height: 35,
        //                                   child: TextFormField(
        //                                     controller: txtEmail,
        //                                     keyboardType:
        //                                         TextInputType.emailAddress,
        //                                     decoration: InputDecoration(
        //                                         fillColor: Colors.grey[200],
        //                                         contentPadding: EdgeInsets.only(
        //                                             top: 5,
        //                                             left: 10,
        //                                             bottom: 5),
        //                                         focusedBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(5)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         enabledBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                                 BorderRadius.all(
        //                                                     Radius.circular(4)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         hintText: 'Enter Your UserName',
        //                                         hintStyle: TextStyle(
        //                                             color: Colors.grey,
        //                                             fontSize: 14)),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                  /*     Padding(
        //                         padding: const EdgeInsets.only(top: 20.0),
        //                         child: Row(
        //                           children: <Widget>[
        //                             Chip(
        //                                 backgroundColor: Colors.black38,
        //                                 padding: const EdgeInsets.symmetric(
        //                                     vertical: 13, horizontal: 5),
        //                                 shape: RoundedRectangleBorder(
        //                                     borderRadius: BorderRadius.only(
        //                                         topRight: Radius.circular(25),
        //                                         bottomRight:
        //                                         Radius.circular(25))),
        //                                 label: Icon(
        //                                   Icons.lock,
        //                                   size: 17,
        //                                   color: Colors.white,
        //                                 )),
        //                             Expanded(
        //                               flex: 3,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 2.0, left: 8.0),
        //                                 child: Text(
        //                                   "Password",
        //                                   style: TextStyle(
        //                                       fontSize: 15,
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 1,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.all(6.0),
        //                                 child: Text(
        //                                   ":",
        //                                   style: TextStyle(
        //                                       fontWeight: FontWeight.w600),
        //                                 ),
        //                               ),
        //                             ),
        //                             Expanded(
        //                               flex: 8,
        //                               child: Padding(
        //                                 padding: const EdgeInsets.only(
        //                                     top: 6.0, left: 8.0, right: 5),
        //                                 child: Container(
        //                                   height: 35,
        //                                   child: TextFormField(
        //                                     controller: txtPassword,
        //                                     keyboardType:
        //                                     TextInputType.text,
        //                                     decoration: InputDecoration(
        //                                         fillColor: Colors.grey[200],
        //                                         contentPadding: EdgeInsets.only(
        //                                             top: 5,
        //                                             left: 10,
        //                                             bottom: 5),
        //                                         focusedBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                             BorderRadius.all(
        //                                                 Radius.circular(5)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         enabledBorder: OutlineInputBorder(
        //                                             borderRadius:
        //                                             BorderRadius.all(
        //                                                 Radius.circular(4)),
        //                                             borderSide: BorderSide(
        //                                                 width: 0,
        //                                                 color: Colors.black)),
        //                                         hintText: 'Enter Your Password',
        //                                         hintStyle: TextStyle(
        //                                             color: Colors.grey,
        //                                             fontSize: 14)),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),*/
        //                       /*  Padding(
        //                       padding: const EdgeInsets.only(top: 20.0),
        //                       child: Row(
        //                         children: <Widget>[
        //                           Chip(
        //                               backgroundColor: Colors.grey[300],
        //                               padding: const EdgeInsets.symmetric(
        //                                   vertical: 13, horizontal: 5),
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius: BorderRadius.only(
        //                                       topRight: Radius.circular(25),
        //                                       bottomRight: Radius.circular(25))),
        //                               label: Icon(
        //                                 Icons.camera_alt,
        //                                 size: 17,
        //                               )),
        //                           Expanded(
        //                             flex: 3,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 2.0, left: 8.0),
        //                               child: Text(
        //                                 "Studio Name",
        //                                 style: TextStyle(
        //                                     fontSize: 15,
        //                                     fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 1,
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(6.0),
        //                               child: Text(
        //                                 ":",
        //                                 style:
        //                                     TextStyle(fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 8,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 6.0, left: 8.0, right: 5),
        //                               child: Container(
        //                                 height: 35,
        //                                 child: TextFormField(
        //                                   keyboardType: TextInputType.emailAddress,
        //                                   decoration: InputDecoration(
        //                                       fillColor: Colors.grey[200],
        //                                       contentPadding: EdgeInsets.only(
        //                                           top: 5, left: 10, bottom: 5),
        //                                       focusedBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(5)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       enabledBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(4)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       hintText: 'Enter Studio Name',
        //                                       hintStyle: TextStyle(
        //                                           color: Colors.grey,
        //                                           fontSize: 14)),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.only(top: 20.0),
        //                       child: Row(
        //                         children: <Widget>[
        //                           Chip(
        //                               backgroundColor: Colors.grey[300],
        //                               padding: const EdgeInsets.symmetric(
        //                                   vertical: 13, horizontal: 5),
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius: BorderRadius.only(
        //                                       topRight: Radius.circular(25),
        //                                       bottomRight: Radius.circular(25))),
        //                               label: Icon(
        //                                 Icons.email,
        //                                 size: 17,
        //                               )),
        //                           Expanded(
        //                             flex: 3,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 2.0, left: 8.0),
        //                               child: Text(
        //                                 "Website",
        //                                 style: TextStyle(
        //                                     fontSize: 15,
        //                                     fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 1,
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(6.0),
        //                               child: Text(
        //                                 ":",
        //                                 style:
        //                                     TextStyle(fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 8,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 6.0, left: 8.0, right: 5),
        //                               child: Container(
        //                                 height: 35,
        //                                 child: TextFormField(
        //                                   keyboardType: TextInputType.emailAddress,
        //                                   decoration: InputDecoration(
        //                                       fillColor: Colors.grey[200],
        //                                       contentPadding: EdgeInsets.only(
        //                                           top: 5, left: 10, bottom: 5),
        //                                       focusedBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(5)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       enabledBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(4)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       hintText: 'Enter Email Id',
        //                                       hintStyle: TextStyle(
        //                                           color: Colors.grey,
        //                                           fontSize: 14)),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                     Padding(
        //                       padding: const EdgeInsets.only(top: 20.0),
        //                       child: Row(
        //                         children: <Widget>[
        //                           Chip(
        //                               backgroundColor: Colors.grey[300],
        //                               padding: const EdgeInsets.symmetric(
        //                                   vertical: 13, horizontal: 5),
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius: BorderRadius.only(
        //                                       topRight: Radius.circular(25),
        //                                       bottomRight: Radius.circular(25))),
        //                               label: Icon(
        //                                 Icons.add_location,
        //                                 size: 17,
        //                               )),
        //                           Expanded(
        //                             flex: 3,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 2.0, left: 8.0),
        //                               child: Text(
        //                                 "Address",
        //                                 style: TextStyle(
        //                                     fontSize: 15,
        //                                     fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 1,
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(6.0),
        //                               child: Text(
        //                                 ":",
        //                                 style:
        //                                     TextStyle(fontWeight: FontWeight.w600),
        //                               ),
        //                             ),
        //                           ),
        //                           Expanded(
        //                             flex: 8,
        //                             child: Padding(
        //                               padding: const EdgeInsets.only(
        //                                   top: 6.0, left: 8.0, right: 5),
        //                               child: Container(
        //                                 height: 35,
        //                                 child: TextFormField(
        //                                   keyboardType: TextInputType.emailAddress,
        //                                   decoration: InputDecoration(
        //                                       fillColor: Colors.grey[200],
        //                                       contentPadding: EdgeInsets.only(
        //                                           top: 5, left: 10, bottom: 5),
        //                                       focusedBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(5)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       enabledBorder: OutlineInputBorder(
        //                                           borderRadius: BorderRadius.all(
        //                                               Radius.circular(4)),
        //                                           borderSide: BorderSide(
        //                                               width: 0,
        //                                               color: Colors.black)),
        //                                       hintText: 'Enter Address',
        //                                       hintStyle: TextStyle(
        //                                           color: Colors.grey,
        //                                           fontSize: 14)),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),*/
        //                       Row(
        //                         children: <Widget>[
        //                           Container(
        //                             margin: EdgeInsets.only(top: 40, left: 110),
        //                             height:
        //                                 MediaQuery.of(context).size.width / 9,
        //                             width:
        //                                 MediaQuery.of(context).size.width / 2.2,
        //                             decoration: BoxDecoration(
        //                                 borderRadius: BorderRadius.all(
        //                                     Radius.circular(15)),
        //                                 gradient: LinearGradient(
        //                                     begin: Alignment.topLeft,
        //                                     end: Alignment.bottomRight,
        //                                     colors: [
        //                                       cnst.appPrimaryMaterialColorYellow,
        //                                       cnst.appPrimaryMaterialColorPink
        //                                     ])),
        //                             child: MaterialButton(
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius:
        //                                       new BorderRadius.circular(9.0)),
        //                               onPressed: () {
        //                                 if (!isLoading)
        //                                   _updatePhotgrapherData();
        //                               },
        //                               child: isLoading
        //                                   ? CircularProgressIndicator(
        //                                       valueColor:
        //                                           new AlwaysStoppedAnimation<
        //                                               Color>(Colors.white),
        //                                     )
        //                                   : Text(
        //                                       "Update Profile",
        //                                       style: TextStyle(
        //                                           color: Colors.white,
        //                                           fontSize: 17.0,
        //                                           fontWeight: FontWeight.w600),
        //                                     ),
        //                             ),
        //                           ),
        //                         ],
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
