import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/Dashboard.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomerForm extends StatefulWidget {
  @override
  _AddCustomerFormState createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  ProgressDialog pr;
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtDOB = new TextEditingController();
  TextEditingController txtUserName = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
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
  }

  bool _obscureText = false;

  _saveCustomer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var data = {
          "Id": 0,
          "PhotographerId": prefs.getString(cnst.Session.Id),
          "StudioId": prefs.getString(cnst.Session.StudioId),
          "Name": txtName.text,
          "Mobile": txtMobile.text,
          "Email": txtEmail.text,
          "DOB" : txtDOB.text,
          "Username" : txtUserName.text,
          "Password" : txtPassword.text,
        };
        Services.SaveCustomer(data).then((data) async {
          pr.hide();
          if (data.Data == "1") {
            Fluttertoast.showToast(
                msg: "Customer Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushNamedAndRemoveUntil(
                context, "/CustomerList", (Route<dynamic> route) => false);
//            Navigator.pushReplacementNamed(context, "/Dashboard");
          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = "PICTIK"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("PICTIK"),
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/CustomerList");
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
            title: Text(
              "Add Customer",
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            centerTitle: true,
            // bottom: TabBar(
            //   labelPadding: EdgeInsets.symmetric(horizontal: 50),
            //   indicatorPadding: EdgeInsets.all(0),
            //   indicatorSize: TabBarIndicatorSize.tab,
            //   isScrollable: true,
            //   tabs: <Widget>[
            //     Tab(
            //       child: Text(
            //         "Add Customer",
            //         style: GoogleFonts.aBeeZee(
            //           textStyle: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ),
            //     Tab(
            //       child: Text(
            //         "Customer List",
            //         style: GoogleFonts.aBeeZee(
            //           textStyle: TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.w600,
            //               color: Colors.white),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),

          body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                "images/14.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 30),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(15.0),
                            /*child: Image.asset(
                              'images/logo1.png',
                              fit: BoxFit.fill,
                              width: 150,
                              height: 50,
                            ),*/
                          ),
                        ),
                      ),
                      Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.trim() == "") {
                                    return 'Please Enter Your Name';
                                  }
                                  return null;
                                },
                                controller: txtName,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    labelText: "Enter Name",
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                                cnst.appPrimaryMaterialColorPink),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: cnst.appPrimaryMaterialColorPink,
                                    ),
                                    //  counterText: "",
                                    //hintText: "Name",
                                    hintStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "" || value.length < 10) {
                                      return 'Please enter 10 characters';
                                    }
                                    return null;
                                  },
                                  controller: txtMobile,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Enter Mobile No",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color:
                                                  cnst.appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.phone_android,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Mobile Number",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value.trim() == "" ||
                                  //       !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  //           .hasMatch(value)) {
                                  //     return 'Please enter valid email id';
                                  //   }
                                  //   return null;
                                  // },
                                  controller: txtEmail,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Enter Email",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color:
                                                  cnst.appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      // counterText: "",
                                      // hintText: "Email",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value.trim() == "") {
                                  //     return 'Please enter your birthdate';
                                  //   }
                                  //   return null;
                                  // },
                                  controller: txtDOB,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Date Of Birth",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color:
                                              cnst.appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.date_range,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Mobile Number",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value.trim() == "") {
                                  //     return 'Please enter your Username';
                                  //   }
                                  //   return null;
                                  // },
                                  controller: txtUserName,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Enter Username",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color:
                                              cnst.appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Mobile Number",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  // validator: (value) {
                                  //   if (value.trim() == "") {
                                  //     return 'Please enter your Password';
                                  //   }
                                  //   return null;
                                  // },
                                  obscureText: !_obscureText,
                                  controller: txtPassword,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Based on passwordVisible state choose the icon
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        onPressed: () {
                                          // Update the state i.e. toogle the state of passwordVisible variable
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                      labelText: "Enter Password",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color:
                                              cnst.appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.height,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Mobile Number",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.text,
                                  maxLength: 20,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),

                            /*Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              height: 50,
                              child: TextFormField(
                               // controller: edtEmail,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    labelText: "Enter referral code",
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: cnst.appPrimaryMaterialColorPink),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.people_outline,
                                      color: cnst.appPrimaryMaterialColorPink,
                                    ),
                                    counterText: "",
                                    hintText: "referral code",
                                    hintStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),*/
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        cnst.appPrimaryMaterialColorYellow,
                                        cnst.appPrimaryMaterialColorPink,
                                      ])),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(9.0)),
                                onPressed: () {
                                  if (_formkey.currentState.validate()) {
                                    _saveCustomer();
                                  }
                                },
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Divider(
                                    thickness: 0,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Divider(
                                    thickness: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
