import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Common/Constants.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opicxo_studio_app/common/Constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController txtMobile = new TextEditingController();
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
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

  _photographerLogin() async {
    if (txtMobile.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Future res = Services.PhotographerLogin(txtMobile.text, "", "");
          res.then((data) async {
            pr.hide();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data != null && data.length > 0) {
              await prefs.setString(
                  cnst.Session.StudioId, data[0]["Id"].toString());
              await prefs.setString(
                  cnst.Session.Image, data[0]["StudioLogo"].toString());
              await prefs.setString(
                  cnst.Session.BranchId, data[0]["BranchId"].toString());
              await prefs.setString(cnst.Session.Name, data[0]["Name"]);

              await prefs.setString(cnst.Session.Mobile, data[0]["MobileNo"]);

              await prefs.setString(cnst.Session.Email, data[0]["UserName"]);
              await prefs.setString(cnst.Session.Password, data[0]["Password"]);
              await prefs.setString(
                  cnst.Session.IsVerified, data[0]["IsVerified"].toString());

              //print("login:${prefs.getString(cnst.Session.AlbumId)}");
              if (data[0]["IsVerified"].toString() == "true" &&
                  data[0]["IsVerified"] != null) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/Dashboard", (Route<dynamic> route) => false);
              } else {
                Navigator.pushNamedAndRemoveUntil(context, "/OTPVerification",
                    (Route<dynamic> route) => false);
              }
            } else {
              showMsg("Invalid login Detail");
            }
          }, onError: (e) {
            setState(() {
              pr.hide();
            });

            print("Error : on Login Call $e");
            showMsg("$e");
          });
        }
      } on SocketException catch (_) {
        showMsg("No Internet Connection.");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Registerd Mobile Number",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP);
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
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/1.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //color: Colors.black.withOpacity(0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Image.asset(
                      'images/logo1.png',
                      fit: BoxFit.fill,
                      width: 200,
                      height: 70,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 50,
                        child: TextFormField(
                          controller: txtMobile,
                          scrollPadding: EdgeInsets.all(0),
                          decoration: InputDecoration(
                              labelText: "Mobile No",
                              labelStyle: (TextStyle(color: Colors.black)),
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: cnst.appPrimaryMaterialColorPink),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: cnst.appPrimaryMaterialColorPink,
                              ),
                              counterText: "",
                              hintText: "Enter Mobile No",
                              hintStyle:
                                  TextStyle(fontSize: 15, color: Colors.black)),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 25),
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: cnst.appPrimaryMaterialColorPink),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(9.0)),
                          onPressed: () {
                            _photographerLogin();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 25),
                      //   width: MediaQuery
                      //       .of(context)
                      //       .size
                      //       .width,
                      //   height: 45,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       color: appPrimaryMaterialColorPink),
                      //   child: MaterialButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: new BorderRadius.circular(9.0)),
                      //     onPressed: () {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (context){
                      //             return LoginWithUsername();
                      //           })
                      //       );
                      //     },
                      //     child: Text(
                      //
                      //       "Login with Username",
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 17.0,
                      //           fontWeight: FontWeight.w600),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/Registration');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Don\'t have an account ?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          cnst.appPrimaryMaterialColorYellow),
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) => RadialGradient(
                                        center: Alignment.topLeft,
                                        colors: [
                                          cnst.appPrimaryMaterialColorYellow[
                                              800],
                                          cnst.appPrimaryMaterialColorPink[800]
                                        ],
                                        tileMode: TileMode.mirror)
                                    .createShader(bounds),
                                // child: Text(
                                //   'SIGN UP',
                                //   style: TextStyle(
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.w600,
                                //       ),
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/TermsandConditions");
                          },
                          child: Text(
                            "Terms & Conditions",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
