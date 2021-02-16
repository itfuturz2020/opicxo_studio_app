import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/common/ClassList.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';

class EditBranchForm extends StatefulWidget {
  var Id,
      StudioName,
      Mobile,
      AlternateMobile,
      Email,
      State,
      City,
      Address,
      Pincode;

  EditBranchForm(
    this.Id,
    this.StudioName,
    this.Mobile,
    this.AlternateMobile,
    this.Email,
    this.State,
    this.City,
    this.Address,
    this.Pincode,
  );

  @override
  _EditBranchFormState createState() => _EditBranchFormState();
}

class _EditBranchFormState extends State<EditBranchForm> {
  bool stateLoading = false;
  bool cityLoading = false;
  bool isLoading = false;

  String _stateDropdownError, _cityDropdownError, _dateError;

  TextEditingController txtStudioName = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtPinCode = new TextEditingController();
  TextEditingController txtemail = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtalternatemobile = new TextEditingController();

  ProgressDialog pr;
  String Id, StudioName, Address, PinCode, state, city;

  List<cityClass> cityClassList = [];
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  cityClass _cityClass;
  String _currentState;

  List<stateClass> stateClassList = [];
  stateClass _stateClass;
  String _currentCity;

  @override
  void initState() {
    _getData();
    _getState();
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

  _getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        Future res = Services.GetStates();
        res.then((data) async {
          setState(() {
            stateLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              stateClassList = data;
            });
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            String currentData = widget.State;
            print("pass data:$currentData");
            print("hello-> " + widget.State);
            for (int i = 0; i < data.length; i++) {
              if (data[i].id == currentData) {
                setState(() {
                  _stateClass = data[i];
                });
                getCity(data[i].id);
                print("match");
              }
            }
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

  getCity(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        Future res = Services.GetCity(id);
        res.then((data) async {
          setState(() {
            cityLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              cityClassList = data;
            });
            if (_cityClass == null) {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              String currentData = widget.City;
              print("hello-> " + widget.City);
              print("c: ${currentData}");
              for (int i = 0; i < data.length; i++) {
                if (data[i].id == currentData) {
                  setState(() {
                    _cityClass = data[i];
                  });
                  print("set");
                }
              }
            }
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        cityLoading = false;
      });
    }
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Id = prefs.getString(cnst.Session.Id);
      txtStudioName.text = widget.StudioName;
      txtmobile.text = widget.Mobile;
      txtalternatemobile.text = widget.AlternateMobile;
      txtemail.text = widget.Email;
      txtAddress.text = widget.Address;
      //_url = prefs.getString(cnst.Session.Image);
      txtPinCode.text = widget.Pincode;

      //_stateClass.Name = _stateClass.Name;
      //_cityClass.Name = _cityClass.Name;
    });
    print("Yash-> " + widget.Id);
    print("Yash-> " + txtStudioName.text);
    print("Yash-> " + txtPinCode.text);
  }

  /*_updateAddressBranch() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        var formData = {
          "Id": widget.Id.toString(),
          "StudioName": txtStudioName.text,
          "Address": txtAddress.text,
          "Pincode": txtPinCode.text,
        };
        print("Dartttaaa: ${formData}");
        Services.UpdateAddressBranch(formData).then((data) async {
          setState(() {
            isLoading = false;
          });

          if (data.Data != "0") {
            Fluttertoast.showToast(
                msg: "Branch Update Succsecfully !!!",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushReplacementNamed(context, '/Dashboard1');
            */ /*    Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard()));*/ /*

          } else {
            showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("No Internet Connection.");
    }
  }*/

  _updateAddressBranch() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String studioid = preferences.getString(Session.StudioId);

        setState(() {
          isLoading = true;
        });
        Future res = Services.UpdateAddressBranch(
            widget.Id,
            studioid,
            txtStudioName.text,
            txtmobile.text,
            txtalternatemobile.text,
            txtemail.text,
            _stateClass.id,
            _cityClass.id,
            txtAddress.text,
            "",
            txtPinCode.text);
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if(data.Data != "0" && data.IsSuccess == true){
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(cnst.Session.BranchId, "${widget.Id}");
            await prefs.setString(
                cnst.Session.StudioName, "${txtStudioName.text}");
            await prefs.setString(cnst.Session.Address, "${txtAddress.text}");
            await prefs.setString(cnst.Session.Mobile, "${txtmobile.text}");
            await prefs.setString(
                cnst.Session.AlternateMobile,"${txtalternatemobile.text}");
            await prefs.setString(cnst.Session.Email, "${txtemail.text}");
            await prefs.setString(cnst.Session.Address, "${txtAddress.text}");

            await prefs.setString(cnst.Session.PinCode, "${txtPinCode.text}");
            Fluttertoast.showToast(
                msg: "Branche Successfully Updated",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.TOP);
            // Navigator.pushReplacementNamed(context, "/Dashboard");
            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "images/16.png",
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formkey1,
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
                        Column(
                          children: <Widget>[
                            /*Container(
                              height: 50,
                              child: TextFormField(
                                validator: (value) {
                                  if (value.trim() == "") {
                                    return 'Please Enter Studio Name';
                                  }
                                  return null;
                                },
                                controller: txtStudioName,
                                scrollPadding: EdgeInsets.all(0),
                                decoration: InputDecoration(
                                    labelText: "Studio Name",
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color:
                                                cnst.appPrimaryMaterialColorPink),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    prefixIcon: Icon(
                                      Icons.home,
                                      color: cnst.appPrimaryMaterialColorPink,
                                    ),
                                    // counterText: "",
                                    //hintText: "Studio Name",
                                    hintStyle: TextStyle(fontSize: 15)),
                                keyboardType: TextInputType.text,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),*/
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
                                  controller: txtmobile,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Mobile No",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.call,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Address",
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
                                  validator: (value) {
                                    if (value.trim() == "" || value.length < 10) {
                                      return 'Please enter 10 characters';
                                    }
                                    return null;
                                  },
                                  controller: txtalternatemobile,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Alternate Mobile No",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.add_call,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "Address",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
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
                                  controller: txtemail,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Email",
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
                                      //counterText: "",
                                      // hintText: "Address",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "State",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      stateLoading
                                          ? CircularProgressIndicator()
                                          : Container(
                                              height: 45,
                                              margin: EdgeInsets.only(top: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.black26,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 0.6),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton<stateClass>(
                                                isExpanded: true,
                                                hint: stateClassList.length > 0
                                                    ? Text(
                                                        'Select State',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12),
                                                      )
                                                    : Text(
                                                        "State Not Found",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                value: _stateClass,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _stateClass = newValue;
                                                    _cityClass = null;
                                                    _stateDropdownError = null;
                                                    cityClassList = [];
                                                  });
                                                  getCity(newValue.id.toString());
                                                },
                                                items: stateClassList
                                                    .map((stateClass value) {
                                                  return DropdownMenuItem<
                                                      stateClass>(
                                                    value: value,
                                                    child: Text(value.Name),
                                                  );
                                                }).toList(),
                                              ))),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: _stateDropdownError == null
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "",
                                                  textAlign: TextAlign.start,
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _stateDropdownError ?? "",
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "City",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (cityClassList.length <= 0 &&
                                                _stateClass != null) {
                                            } else
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Select State First",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT);
                                          },
                                          child: cityLoading
                                              ? CircularProgressIndicator()
                                              : Container(
                                                  height: 45,
                                                  margin: EdgeInsets.only(top: 5),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.3,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    color: Colors.black26,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        style: BorderStyle.solid,
                                                        width: 0.6),
                                                  ),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child:
                                                        DropdownButton<cityClass>(
                                                      isExpanded: true,
                                                      hint: cityClassList.length >
                                                              0
                                                          ? Text(
                                                              'Select City',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            )
                                                          : Text(
                                                              "City Not Found",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12),
                                                            ),
                                                      value: _cityClass,
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _cityClass = newValue;
                                                          _cityDropdownError =
                                                              null;
                                                        });
                                                      },
                                                      items: cityClassList
                                                          .map((cityClass value) {
                                                        return DropdownMenuItem<
                                                            cityClass>(
                                                          value: value,
                                                          child: Text(value.Name),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: _cityDropdownError == null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "",
                                                    textAlign: TextAlign.start,
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _cityDropdownError ?? "",
                                                    style: TextStyle(
                                                        color: Colors.red[700],
                                                        fontSize: 12),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "") {
                                      return 'Please Enter Your Address';
                                    }
                                    return null;
                                  },
                                  controller: txtAddress,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "Address",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.location_city,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      //counterText: "",
                                      // hintText: "Address",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Container(
                                height: 50,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.trim() == "" || value.length < 6) {
                                      return 'Please enter 6 characters';
                                    }
                                    return null;
                                  },
                                  controller: txtPinCode,
                                  scrollPadding: EdgeInsets.all(0),
                                  decoration: InputDecoration(
                                      labelText: "PinCode",
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: cnst
                                                  .appPrimaryMaterialColorPink),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.phone_iphone,
                                        color: cnst.appPrimaryMaterialColorPink,
                                      ),
                                      counterText: "",
                                      // hintText: "PinCode",
                                      hintStyle: TextStyle(fontSize: 15)),
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
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
                                  bool isValidate = true;
                                  setState(() {
                                    if (_stateClass == null) {
                                      isValidate = false;
                                      _stateDropdownError =
                                      "Please Select State";
                                    }
                                  });
                                  if (_formkey1.currentState.validate()) {
                                    if (isValidate) {
                                      _updateAddressBranch();
                                    }
                                  }

                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
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
        ),
      ),
    );
  }
}
