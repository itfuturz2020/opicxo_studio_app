import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:opicxo_studio_app/common/ClassList.dart';
import 'package:opicxo_studio_app/common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';
const kGoogleApiKey = "AIzaSyCQq4XwyAvIbIklYDOGG8dVzbIqoe0RNJE";

Position _currentPosition;
String _currentAddress;
final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddBranch extends StatefulWidget {
  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {

  final Geolocator _geolocator = Geolocator();

  final TextEditingController _coordinatesTextController =
  TextEditingController();

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  String _placemark = '';
  Future<void> _onLookupAddressPressed() async {
    final List<String> coords = _coordinatesTextController.text.split(',');
    final double latitude = double.parse(coords[0]);
    final double longitude = double.parse(coords[1]);
    final List<Placemark> placemarks =
    await _geolocator.placemarkFromCoordinates(latitude, longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.thoroughfare + ', ' + pos.locality;
      });
      Fluttertoast.showToast(
          msg: "${_placemark}",
          backgroundColor: cnst.appPrimaryMaterialColorYellow,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
    else
      {
        Fluttertoast.showToast(
            msg: "Placemark null",
            backgroundColor: cnst.appPrimaryMaterialColorYellow,
            textColor: Colors.white,
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
      }

  }

  bool stateLoading = false;
  bool cityLoading = false;

  String _stateDropdownError, _cityDropdownError, _dateError;
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  List<cityClass> cityClassList = [];
  cityClass _cityClass;

  List<stateClass> stateClassList = [];
  stateClass _stateClass;

  ProgressDialog pr;

  TextEditingController txtStudioName = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtPinCode = new TextEditingController();
  TextEditingController txtemail = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtlocation = new TextEditingController();
  TextEditingController txtalternatemobile = new TextEditingController();


  loc.LocationData currentLocation;
  String latlong;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    if(_currentPosition!=null && _currentAddress!=null){
      txtlocation.text = _currentAddress;
      print("txtemail.text");
      print(txtlocation.text);
    }
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
    _getState();
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

  _saveAddressBranch() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        // cnst.Studio_Id;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var data = {
          "Id": 0,
          "StudioId": prefs.getString(cnst.Session.StudioId),
          "StudioName": txtStudioName.text,
          "Address": _coordinatesTextController.text,
          "PinCode": txtPinCode.text,
          "Email": txtemail.text,
          "Mobile": txtmobile.text,
          "AlternateMobile": txtalternatemobile.text,
          "StateId": _stateClass.id.toString(),
          "CityId": _cityClass.id.toString(),
          "LatLong": _placemark,
        };

        print("Save Vendor Data = ${data}");
        print("latlong Data = ${_placemark}");
        Services.SaveAddressBranch(data).then((data) async {
          pr.hide();

          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Branch Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false);
            // Navigator.pushNamed(context, "/Dashboard");
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

  final homeScaffoldKey = GlobalKey<ScaffoldState>();

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Mode _mode = Mode.overlay;

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    print("p");
    print(p.description);
    txtlocation.text = p.description;
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "in")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
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
          title: Text(
            "Add Branch",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
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
                        Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: RaisedButton(
                            onPressed: _handlePressButton,
                            child: Text(
                              "Change Location",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            ),
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim() == "" ||
                                    value.length < 10) {
                                  return 'Please select your location';
                                }
                                return null;
                              },
                              controller: txtlocation,
                              scrollPadding: EdgeInsets.all(0),
                              decoration: InputDecoration(
                                  labelText: "Your Location",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: cnst
                                              .appPrimaryMaterialColorPink),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: cnst.appPrimaryMaterialColorPink,
                                  ),
                                  counterText: "",
                                  // hintText: "Address",
                                  hintStyle: TextStyle(fontSize: 15)),
                              keyboardType: TextInputType.number,
                              maxLength: 100,

                              style: TextStyle(color: Colors.black),
                              onTap: (){
                                print("tapped");
                                _handlePressButton;
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
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
                                if (value.trim() == "" ||
                                    value.length < 10) {
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
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                                      child:
                                      DropdownButtonHideUnderline(
                                          child: DropdownButton<
                                              stateClass>(
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
                                              getCity(
                                                  newValue.id.toString());
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
                                padding: const EdgeInsets.only(left:8.0),
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
                                        margin:
                                        EdgeInsets.only(top: 5),
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            2.3,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              5),
                                          color: Colors.black26,
                                          border: Border.all(
                                              color: Colors.black,
                                              style:
                                              BorderStyle.solid,
                                              width: 0.6),
                                        ),
                                        child:
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<
                                              cityClass>(
                                            isExpanded: true,
                                            hint: cityClassList
                                                .length >
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
                                            items: cityClassList.map(
                                                    (cityClass value) {
                                                  return DropdownMenuItem<
                                                      cityClass>(
                                                    value: value,
                                                    child:
                                                    Text(value.Name),
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
                              controller: _coordinatesTextController,
                            //  controller: txtAddress,
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
                                if (value.trim() == "" ||
                                    value.length < 6) {
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
                                borderRadius:
                                new BorderRadius.circular(9.0)),
                            onPressed: () async {

                           // await  _onLookupAddressPressed();
                            //  print("hii -> "+_placemark);
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
                                  _saveAddressBranch();
                                }
                              }
                            },
                            child: Text(
                              "Add Branch",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        // Column(
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.only(bottom: 10),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //         MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Container(
                        //             width:
                        //             MediaQuery.of(context).size.width / 3,
                        //             child: Divider(
                        //               thickness: 0,
                        //             ),
                        //           ),
                        //           Container(
                        //             width:
                        //             MediaQuery.of(context).size.width / 3,
                        //             child: Divider(
                        //               thickness: 0,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
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