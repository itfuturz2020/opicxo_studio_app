import 'dart:io';
import 'dart:math';

import 'package:opicxo_studio_app/Screen/DigitalCardScreen/MemberSelection.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';

import '../../common/DigitalCardCommon/Constants.dart' as cnst;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

class MobileLogin extends StatefulWidget {
  MobileLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  String type = "login";

  double loginwidth = 170;
  double signUpWidth = 110;
  bool isLoginExpand = true;

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: <Widget>[
                type == "login" ? LoginScreen() : SignUpScreen(),
                Positioned(
                  top: 60,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (type == "signup") {
                          type = "login";
                        }
                        if (isLoginExpand == false) {
                          isLoginExpand = true;
                          loginwidth = 170;
                          signUpWidth = 110;
                        }
                      });
                    },
                    child: AnimatedContainer(
                        duration: new Duration(milliseconds: 700),
                        width: loginwidth,
                        height: 40,
                        child: Container(
                            decoration: BoxDecoration(
                                color: cnst.appMaterialColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25))),
                            child: Center(
                                child: Text("LOGIN",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))))),
                  ),
                ),
                Positioned(
                  top: 110,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (type == "login") {
                          type = "signup";
                        }

                        if (isLoginExpand == true) {
                          isLoginExpand = false;
                          loginwidth = 110;
                          signUpWidth = 170;
                        }
                      });
                    },
                    child: AnimatedContainer(
                        duration: new Duration(milliseconds: 700),
                        width: signUpWidth,
                        height: 40,
                        child: Container(
                            decoration: BoxDecoration(
                                color: cnst.appMaterialColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25))),
                            child: Center(
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600))))),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobile = new TextEditingController();
  TextEditingController edtCompany = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtRefCode = new TextEditingController();
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
  }

  Future<List<MemberClass>> chklog() async {
    List<MemberClass> data = await Services.MemberLogin(edtMobile.text);
    return data;
  }

  checkLogin() async {
    if (edtMobile.text != "" && edtMobile.text != null) {
      if (edtMobile.text.length == 10) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            pr.show();
            chklog().then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print("deate leng ${data}");
              if (data != null && data.length > 0) {
                if (data.length > 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemberSelection(memberList: data),
                    ),
                  );
                } else {
                  pr.hide();
                  await prefs.setString(cnst.Session.MemberId, data[0].Id);
                  await prefs.setString(cnst.Session.Name, data[0].Name);
                  await prefs.setString(cnst.Session.Mobile, data[0].Mobile);
                  await prefs.setString(cnst.Session.Company, data[0].Company);
                  await prefs.setString(cnst.Session.Email, data[0].Email);
                  await prefs.setString(
                      cnst.Session.ReferCode, data[0].MyReferralCode);
                  await prefs.setBool(
                      cnst.Session.IsActivePayment, data[0].IsActivePayment);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Dashboard1', (Route<dynamic> route) => false);

                  //Navigator.pushReplacementNamed(context, '/ConclaveDashboard');
                }
              } else {
                pr.hide();
                showMsg("Invalid login Detail.");
              }
            }, onError: (e) {
              pr.hide();
              print("Error : on Login Call $e");
              showMsg("$e");
            });
          } else {
            pr.hide();
            showMsg("Something wen wrong");
          }
        } on SocketException catch (_) {
          showMsg("No Internet Connection.");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please enter Valid Mobile Number",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: cnst.appMaterialColor,
            textColor: Colors.white,
            fontSize: 15.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: cnst.appMaterialColor,
          textColor: Colors.white,
          fontSize: 15.0);
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
                style: TextStyle(color: cnst.appMaterialColor),
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
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Container(
        margin: EdgeInsets.only(
            top: devicePadding.top + 200),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeIn(
                1.0,
                Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Container(
                          height: 3,
                          width: 40,
                          decoration: BoxDecoration(
                              color: cnst.appMaterialColor[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    Text("LOGIN",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(height: 50),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtMobile,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Mobile No",
                        hintStyle: TextStyle(fontSize: 12)),
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      color: cnst.appMaterialColor,
                      onPressed: () {
                        checkLogin();
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  TextEditingController edtName = new TextEditingController();
  TextEditingController edtMobile = new TextEditingController();
  TextEditingController edtCompany = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtRefCode = new TextEditingController();
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    //pr.setMessage('Please Wait');
    // TODO: implement initState
    super.initState();
  }

  String GetRandomNo(int length) {
    String UniqueNo = "";
    var rng = new Random();
    for (var i = 0; i < length; i++) {
      UniqueNo += rng.nextInt(10).toString();
    }
    return UniqueNo;
  }

  signUp() {
    if (edtName.text != '' &&
        edtMobile.text != '' &&
        edtCompany.text != '' &&
        edtEmail.text != '') {
      setState(() {
        isLoading = true;
      });

      String img = '';
      String referCode =
          edtName.text.substring(0, 3).toUpperCase() + GetRandomNo(5);

      print('RefferCode : $referCode');

      var data = {
        'type': 'signup',
        'name': edtName.text,
        'mobile': edtMobile.text,
        'company': edtCompany.text,
        'email': edtEmail.text,
        'imagecode': img,
        'myreferCode': referCode,
        'regreferCode': edtRefCode.text
      };

      Future res = Services.MemberSignUp(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: cnst.appMaterialColor,
              gravity: ToastGravity.TOP);
          Navigator.pushReplacementNamed(context, '/MobileLogin');
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).padding;
    return Container(
        margin: EdgeInsets.only(top: devicePadding.top + 100),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
              child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeIn(
                1.0,
                Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Container(
                          height: 3,
                          width: 40,
                          decoration: BoxDecoration(
                              color: cnst.appMaterialColor[800],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                    Text("Sign Up",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtName,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.person,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Name",
                        hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtMobile,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Mobile No",
                        hintStyle: TextStyle(fontSize: 12)),
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtCompany,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.business_center,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Company Name",
                        hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtEmail,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Email",
                        hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Container(
                  height: 50,
                  child: TextFormField(
                    controller: edtRefCode,
                    scrollPadding: EdgeInsets.all(0),
                    decoration: InputDecoration(
                        counterText: "",
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.redAccent),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.device_hub,
                          color: cnst.appMaterialColor,
                        ),
                        hintText: "Referal Code",
                        hintStyle: TextStyle(fontSize: 12)),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FadeIn(
                1.0,
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(top: 10),
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      color: cnst.appMaterialColor,
                      onPressed: () {
                        signUp();
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 1000), Tween(begin: 0.0, end: 1.0)),
      Track("translateX").add(
          Duration(milliseconds: 1000), Tween(begin: 0.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (400 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}
