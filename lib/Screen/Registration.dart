import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/ClassList.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registration extends StatefulWidget {
  String Name, Email, Mobile;
  Registration({this.Name, this.Email, this.Mobile});
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool stateLoading = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _mobileKey = GlobalKey<FormFieldState>();
  bool flag = false;

  ProgressDialog pr;
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtStudioName = new TextEditingController();
  TextEditingController txtCode = new TextEditingController();

  List<cityClass> cityClassList = [];
  cityClass _cityClass;

  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  List<GetBranchClass> _getBranchList = [];
  //GetBranchClass _getBranchClass;
  String _CodeDropdownError;

  @override
  void initState() {
    _getBranch();
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
//              backgroundColor: cnst.appPrimaryMaterialColorPink,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  _savePhotographer() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData data = new FormData.fromMap({
          "Id": 0,
          "StudioId": prefs.getString(cnst.Session.StudioId),
          "BranchId": prefs.getString(cnst.Session.BranchId),
          "Name": txtName.text,
          "MobileNo": txtMobile.text,
          "Email": txtEmail.text,
          "StudioName": txtStudioName.text,
          "Code": txtCode.text,
        });

        print("Save visitorData Data = ${data}");
        Services.SavePhotographer(data).then((data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            /* SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.Id, data.Data);
            await prefs.setString(cnst.Session.StudioId, data.Data);
            await prefs.setString(cnst.Session.Mobile, txtMobile.text);
            await prefs.setString(cnst.Session.Image, "");
            await prefs.setString(cnst.Session.Name, txtName.text);
            await prefs.setString(cnst.Session.Email, txtEmail.text);
            await prefs.setString(cnst.Session.StudioId, data.Data);
            await prefs.setString(cnst.Session.StudioName, txtStudioName.text);
            prefs.setString(cnst.Session.IsVerified, "false");*/
            Fluttertoast.showToast(
                msg: "Registration Successfully",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
            Navigator.pushNamedAndRemoveUntil(
                context, "/Login", (Route<dynamic> route) => false);
            /*   Navigator.pushNamedAndRemoveUntil(
                context, "/Login", (Route<dynamic> route) => false);*/
          } else {
            showMsg(data.Message, title: "Error");
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

  _getBranch() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        Future res = Services.GetBranch(txtStudioName.text);
        res.then((data) async {
          setState(() {
            stateLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _getBranchList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        stateLoading = false;
      });
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                "images/back009.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              //color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formkey,
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
                      Form(
                        key: _formkey1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                      labelText: "Full Name",
                                      labelStyle:
                                          (TextStyle(color: Colors.black)),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      //  counterText: "",
                                      //  hintText: "Full Name",
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "" ||
                                        value.length < 10) {
                                      return 'Please enter 10 characters';
                                    }
                                    return null;
                                  },
                                  controller: txtMobile,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Mobile No",
                                      labelStyle:
                                          (TextStyle(color: Colors.black)),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.phone_android,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      //   hintText: "Enter Mobile No",
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "" ||
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return 'Please enter valid email id';
                                    }
                                    return null;
                                  },
                                  controller: txtEmail,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Email Address",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "") {
                                      return 'Please Enter Stuido Name';
                                    }
                                    return null;
                                  },
                                  controller: txtStudioName,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Studio Name",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.camera_alt,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            _getBranch();
                                          },
                                          icon: Icon(Icons.arrow_forward_ios)),
                                      //counterText: "",
                                      //  hintText: "Enter Studio Name",
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "") {
                                      return 'Please Enter Your Code';
                                    }
                                    return null;
                                  },
                                  controller: txtCode,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Referral Code",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.code,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15, color: Colors.black)),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: appPrimaryMaterialColorPink),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(9.0)),
                                onPressed: () {
                                  bool isValidate = true;
                                  setState(() {
                                    if (txtCode == null) {
                                      isValidate = false;
                                      _CodeDropdownError =
                                          "Please Enter your Code";
                                    }
                                  });
                                  if (_formkey1.currentState.validate()) {
                                    if (isValidate) {
                                      _savePhotographer();
                                    }
                                  }
                                  /* else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Registration(
                                              Name: txtName.text,
                                              Mobile: txtMobile.text,
                                              Email: txtEmail.text,
                                            )));
                                  }*/
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
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
                                    thickness: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Already Register ?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
