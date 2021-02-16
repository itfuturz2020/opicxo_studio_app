import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ReferralCode.dart';

class OTPVerification extends StatefulWidget {
  var mobile = "";
  var name;
  var id;

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController txtOTP = new TextEditingController();
  String rndnumber = "";
  String id = "";
  String mobileNo = "";
  String name = "";
  var isLoading = false;
  int otpCode;
  String isNavigate = "isnavigate";

  ProgressDialog pr;

  @override
  void initState() {
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
    getLocalData();
  }

  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (widget.mobile != null && widget.mobile != "") {
        name = widget.name;
        mobileNo = widget.mobile;
        id = widget.id;
      } else {
        mobileNo = prefs.getString(cnst.Session.Mobile);
      }
    });
    print(mobileNo);
    _sendVerificationCode(mobileNo);
  }

  _sendVerificationCode(String mobileNo) async {
    try {
      setState(() {
        rndnumber = "";
      });
      var rnd = new Random();

      for (int i = 1; i <= 4; i++) {
        setState(() {
          rndnumber = rndnumber + rnd.nextInt(9).toString();
        });
      }
      print(rndnumber);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading = true;
        Services.SendVerificationCode(mobileNo, rndnumber).then((data) async {
          isLoading = false;
          if (data.Data == "1" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "OTP sent succsecfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP);
          } else {
            showMsg("${data.Message}");
          }
        }, onError: (e) {
          isLoading = false;
          print("Error : on otp $e");
          showMsg("${e}");
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      showMsg("No internet connection");
    }
  }

  _photographerOTPVerification() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        Services.PhotographerOTPVerification(prefs.getString(cnst.Session.Id))
            .then((data) async {
          pr.hide();
          if (data.Data == "1" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "OTP Verification succsecfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);

            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
          } else {
            showMsg("Something Went Wrong");
          }
        }, onError: (e) {
          pr.hide();
          print("Error : on otp $e");
          showMsg("$e");
          setState(() {});
        });
      }
    } on SocketException catch (_) {
      showMsg("No internet connection");
    }
  }

  showMsg(String msg, {String title = 'PICTIK'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/Login');
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.9,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        cnst.appPrimaryMaterialColorYellow,
                        cnst.appPrimaryMaterialColorPink
                      ])),
                  //color: cnst.appPrimaryMaterialColorPink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Verify Your Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 20, right: 20),
                        child: Text(
                          //"OTP has been sent to you on ${memberMobile}. Please enter it below",
                          "OTP has been sent to you on ${mobileNo}. Please enter it below",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      //side: BorderSide(color: cnst.appcolor)),
                      side: BorderSide(width: 0.50, color: Colors.grey[500]),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.65,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          PinCodeTextField(
                            autofocus: false,
                            controller: txtOTP,
                            highlight: true,
                            pinBoxHeight: 60,
                            pinBoxWidth: 60,
                            wrapAlignment: WrapAlignment.center,
                            highlightColor: cnst.appPrimaryMaterialColorYellow,
                            defaultBorderColor: Colors.grey,
                            hasTextBorderColor:
                                cnst.appPrimaryMaterialColorPink,
                            maxLength: 4,
                            pinBoxDecoration: ProvidedPinBoxDecoration
                                .defaultPinBoxDecoration,
                            pinTextStyle: TextStyle(fontSize: 20.0),
                            pinTextAnimatedSwitcherTransition:
                                ProvidedPinBoxTextAnimation.scalingTransition,
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 200),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 30),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              //color: Colors.red,
                              color: cnst.appPrimaryMaterialColorPink[700],
                              minWidth: MediaQuery.of(context).size.width - 20,
                              onPressed: () {
                                if (txtOTP.text == rndnumber) {
                                  _photographerOTPVerification();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Entered Wrong OTP !",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER);
                                }
                              },
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  Text(
                                    "Didn't Receive the Verification Code ?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _sendVerificationCode(mobileNo);
                                    },
                                    child: Text(
                                      'RESEND CODE',
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              cnst.appPrimaryMaterialColorPink),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*  Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: isLoading ? LoadinComponent() : Container(),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
