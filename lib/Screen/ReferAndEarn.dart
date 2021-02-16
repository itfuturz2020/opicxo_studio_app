import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/Dashboard.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/services.dart';

import 'MyEarnings.dart';

class ReferAndEarn extends StatefulWidget {
  @override
  _ReferAndEarnState createState() => _ReferAndEarnState();
}

class _ReferAndEarnState extends State<ReferAndEarn> {
  ProgressDialog pr;
  bool isLoading = true;
  String second = "";
  String second1 = "";
  String first="";
  Map refercode = {};

  @override
  void initState() {
    _getRefearlAndEarnCodeById();
    super.initState();
    }

  _getRefearlAndEarnCodeById() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var studioid = prefs.getString(Session.StudioId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetRefearlAndEarnCodeById(studioid);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              refercode = data;
              List<dynamic> _list;
              _list = refercode.values.toList();
               second=_list[1];
               second1 = second.replaceAll("<ReferralCode>", _list[0]);
               first = _list[0];
            });
          } else {
            setState(() {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 354,
                  decoration: BoxDecoration(
                    color: appPrimaryMaterialColorPink,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:25.0,right: 350),
                      // child: GestureDetector(
                      //   onTap: () {
                      //     print("tapped");
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => Dashboard()),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left:8.0),
                      //     child: Icon(
                      //       Icons.arrow_back,
                      //       size: 30,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top:20.0,left: 260,right: 10,),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyEarnings()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0,right: 8,top: 3,bottom: 3),
                              child: Text("MY EARNINGS",style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 10,
                              ),),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("Invite Your Friend And \n        Earn Money",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 75.0),
                              child: Container(
                                width: 20.0,
                                height: 20.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 49.0),
                              child: Container(
                                width: 30.0,
                                height: 25.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 80.0),
                              child: Container(
                                width: 23.0,
                                height: 23.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Icon(
                          Icons.accessibility,
                          size: 60,
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Icon(
                          Icons.accessibility,
                          size: 60,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 49.0),
                              child: Container(
                                width: 30.0,
                                height: 25.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 18.0,
                                height: 18.0,
                                decoration: new BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:3.0,right: 3),
                      child: Container(
                        height: 110,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:150.0,top: 12,),
                                child: Icon(
                                  Icons.book,
                                  size: 36,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top:18.0,bottom: 8,right: 30,left: 5,
                                ),
                                child: Column(
                                  children: [
                                    Text("Share your referral link and invite your friends via SMS \n",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("  Email / Whatsapp. Your will earn upto ₹ 10000",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [

                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: new BoxDecoration(
                            border: Border.all(color: Colors.blue,width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 1,
                            width: 1,
                            child: Image.asset("images/invitefriends.png",
                              cacheHeight: 25,
                              cacheWidth: 25,
                            ),
                          ),
                        ),
                        Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: new BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text("1",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          ),
                        ),
                      ],

                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text("Invite your \n friends to \n sign up",style: TextStyle(
                      fontSize: 11,
                    ),),
                  ],

                ),
                Column(
                  children: [
                    Stack(
                      children: [

                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: new BoxDecoration(
                            border: Border.all(color: Colors.blue,width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 1,
                            width: 1,
                            child: Image.asset("images/rewareded.png",
                              cacheHeight: 20,
                              cacheWidth: 20,
                            ),

                          ),
                        ),
                        Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: new BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text("2",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ],

                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text("     Your Friends \n will get services \n         from us",style: TextStyle(
                      fontSize: 11,
                    ),),
                  ],

                ),
                Column(
                  children: [
                    Stack(
                      children: [

                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: new BoxDecoration(
                            border: Border.all(color: Colors.blue,width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 1,
                            width: 1,
                            child: Image.asset("images/service.jfif",
                              cacheHeight: 20,
                              cacheWidth: 20,
                            ),
                          ),
                        ),
                        Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: new BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text("3",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ],

                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text("You and your \n   friends get \n    rewarded",style: TextStyle(
                      fontSize: 11,
                    ),
                    ),
                  ],

                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Text("YOUR REFERRAL CODE",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    first,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            GestureDetector(
              onTap: () {

                ClipboardManager.copyToClipBoard(first).then((result) {
                final snackBar = SnackBar(
                  content: Text('Code Copied'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: first));
                    },
                  ),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              });
              },
              child: Text(
                "TAP TO COPY",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:110.0,right:110,top: 15),
    child: Container(
        height: 30.0,
        child: RaisedButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF81C784), Color(0xFF388E3C)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30.0)
            ),
            child: GestureDetector(
    onTap: () {
        Share.share(second1);
        },
              child: Container(
                constraints: BoxConstraints(maxWidth: 200.0, minHeight: 40.0),
                alignment: Alignment.center,
                child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        Text("REFER NOW",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
    ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("*T&C",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     flexibleSpace: Container(
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment.centerLeft,
    //           end: Alignment.centerRight,
    //           colors: <Color>[
    //             cnst.appPrimaryMaterialColorYellow,
    //             cnst.appPrimaryMaterialColorPink
    //           ],
    //         ),
    //       ),
    //     ),
    //     title: Text(
    //       "Refer & Earn",
    //       style: GoogleFonts.aBeeZee(
    //         textStyle: TextStyle(
    //             fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
    //       ),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body: Stack(
    //     children: [
    //       Container(
    //         child: Opacity(
    //           opacity: 0.1,
    //           child: Image.asset(
    //             "images/back009.png",
    //             width: MediaQuery.of(context).size.width,
    //             height: MediaQuery.of(context).size.height,
    //             fit: BoxFit.fill,
    //           ),
    //         ),
    //       ),
    //       SingleChildScrollView(
    //         child: Container(
    //           color: Colors.white,
    //           height: MediaQuery.of(context).size.height,
    //           child: Column(
    //             children: <Widget>[
    //               Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 90),
    //                 child: Image.asset(
    //                   "images/logo.png",
    //                   height: MediaQuery.of(context).size.height / 4,
    //                   width: MediaQuery.of(context).size.width,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 10.0, left: 8.0),
    //                 child: Text(
    //                   "Refer & Earn",
    //                   style: TextStyle(
    //                       color: cnst.appPrimaryMaterialColorPink,
    //                       fontWeight: FontWeight.w900,
    //                       fontSize: 25),
    //                 ),
    //               ),
    //               /* Padding(
    //               padding: const EdgeInsets.only(top: 11.0),
    //               child: */ /*Text(
    //                 "Current Point",
    //                 style: TextStyle(
    //                     color: cnst.appPrimaryMaterialColorPink,
    //                     fontSize: 18.0,
    //                     fontWeight: FontWeight.w700),
    //               ),*/ /*
    //             ),*/
    //               /*Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Image.asset(
    //                 "images/dollar.png",
    //                 height: 35,
    //                 width: 35,
    //               ),
    //             ),
    //             Text(
    //               "100",
    //               style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w900,
    //                   fontSize: 16),
    //             ),*/
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 35, left: 15),
    //                 child: Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Text(
    //                     "SHARE YOUR INVITE CODE",
    //                     style: TextStyle(
    //                         color: cnst.appPrimaryMaterialColorPink,
    //                         fontWeight: FontWeight.w700),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Container(
    //                   //  margin: EdgeInsets.only(top: 20),
    //                   width: MediaQuery.of(context).size.width / 1.1,
    //                   height: 45,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.all(Radius.circular(7)),
    //                       gradient: LinearGradient(
    //                           begin: Alignment.topLeft,
    //                           end: Alignment.bottomRight,
    //                           colors: [
    //                             cnst.appPrimaryMaterialColorYellow,
    //                             cnst.appPrimaryMaterialColorPink
    //                           ])),
    //                   child: Center(
    //                     child: Text(
    //                       "$refercode",
    //                       style: TextStyle(
    //                           color: Colors.black,
    //                           fontWeight: FontWeight.w500,
    //                           fontSize: 20,
    //                           letterSpacing: 2),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: SizedBox(
    //                   height: 45,
    //                   width: 350,
    //                   child: RaisedButton(
    //                     color: Colors.white,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: new BorderRadius.circular(11.0),
    //                         side: BorderSide(
    //                             color: cnst.appPrimaryMaterialColorPink)),
    //                     onPressed: () {
    //                       String withrefercode = cnst.inviteFriMsg
    //                           .replaceAll("#refercode", refercode);
    //                       String withappurl = withrefercode.replaceAll(
    //                           "#appurl", cnst.playstoreUrl);
    //                      // Share.share(withappurl);
    //                     },
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Text(
    //                           "Refer ",
    //                           style: TextStyle(
    //                               color: cnst.appPrimaryMaterialColorPink),
    //                         ),
    //                         Icon(
    //                           Icons.share,
    //                           color: cnst.appPrimaryMaterialColorPink,
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(
    //                     top: 10, left: 10, right: 10, bottom: 10),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: <Widget>[
    //                     Padding(
    //                       padding: const EdgeInsets.only(right: 8.0),
    //                       child: Text(
    //                         "Note:",
    //                         style: TextStyle(fontWeight: FontWeight.w600),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       child: Text(
    //                         "",
    //                         style: TextStyle(color: Colors.grey),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
