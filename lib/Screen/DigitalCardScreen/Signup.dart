import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/ImagePickerHandlerComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

Color colorOne = cnst.appcolor;
Color colorTwo = cnst.buttoncolor;
Color colorThree = Colors.grey[500];

class _SignupState extends State<Signup>
    with TickerProviderStateMixin,ImagePickerListener{

  bool isLoading = false;
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtCompany = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtRegCode = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_controller);
    imagePicker.init();

  }

  String GetRandomNo(int length){
    String UniqueNo = "";
    var rng = new Random();
    for (var i = 0; i < length; i++) {
      UniqueNo += rng.nextInt(10).toString();
    }
    return UniqueNo;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SaveOffer() async {
    if (txtName.text != '' && txtMobile.text != '' && txtCompany.text != '' && txtEmail.text != '') {
      setState(() {
        isLoading = true;
      });

      String img = '';
      String referCode = txtName.text.substring(0,3).toUpperCase() + GetRandomNo(5);

      if (_image != null){
        List<int> imageBytes = await _image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
      }
      print('base64 Img : $img');
      print('RefferCode : $referCode');

      var data = {
        'type': 'signup',
        'name': txtName.text,
        'mobile': txtMobile.text,
        'company': txtCompany.text,
        'email': txtEmail.text,
        'imagecode': img,
        'myreferCode': referCode,
        'regreferCode': txtRegCode.text
      };

      Future res = Services.MemberSignUp(data);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null && data.ERROR_STATUS == false) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
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
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                CustomPaint(
                  child: Container(
                    height: 140.0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                              "images/logo1.png",
                              width: 70.0,
                              height: 70.0,
                              fit: BoxFit.contain
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:20.0),
                        ),
                        Text(
                          'Digital Card \nSign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700
                            //fontSize: 18.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  painter: CurvePainter(),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                  //height: MediaQuery.of(context).size.height - 140.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: TextFormField(
                          controller: txtName,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.perm_identity),
                            hintText: "Name"
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                        //height: 40,
                        width: MediaQuery.of(context).size.width - 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: TextFormField(
                          controller: txtMobile,
                          maxLength: 10,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                              hintText: "Mobile"
                          ),
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.black),
                        ),
                        //height: 40,
                        width: MediaQuery.of(context).size.width - 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: TextFormField(
                          controller: txtCompany,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.business_center),
                              hintText: "Company"
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                        ),
                        //height: 40,
                        width: MediaQuery.of(context).size.width - 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: TextFormField(
                          controller: txtEmail,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.local_post_office),
                              hintText: "Email"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                        ),
                        //height: 40,
                        width: MediaQuery.of(context).size.width - 60,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            border: new Border.all(width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: TextFormField(
                          controller: txtRegCode,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.device_hub),
                              hintText: "Referral Code"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                        ),
                        //height: 40,
                        width: MediaQuery.of(context).size.width - 60,
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () => imagePicker.showDialog(context),
                          child: new Center(
                            child: _image == null
                                ? Image.asset("images/user.png",height: 100.0,
                              width: 100.0,)
                                : new Container(
                              height: 100.0,
                              width: 100.0,
                              child: ClipOval(
                                child: Image.file(File(_image.path),
                                    height: 230,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      )*/
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        margin: EdgeInsets.only(top: 20),
                        child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            elevation: 5,
                            textColor: Colors.white,
                            color: cnst.buttoncolor,
                            child: setUpButtonChild(),
                            onPressed: () {
                              SaveOffer();
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20,right: 20,bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text("already a memeber?",
                                style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: cnst.buttoncolor)),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, "/MobileLogin");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text("Login Now",
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: cnst.appcolor)),
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }
  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Sign Up",
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
}

class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0.0, size.height - 20);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
    Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0.0, size.height - 25);
    var first1ControlPoint = Offset(size.width / 4, size.height - 5);
    var first1EndPoint = Offset(size.width / 2.25, size.height - 35.0);
    path.quadraticBezierTo(first1ControlPoint.dx, first1ControlPoint.dy,
        first1EndPoint.dx, first1EndPoint.dy);

    var second1ControlPoint =
    Offset(size.width - (size.width / 3.25), size.height - 70);
    var second1EndPoint = Offset(size.width, size.height - 45);
    path.quadraticBezierTo(second1ControlPoint.dx, second1ControlPoint.dy,
        second1EndPoint.dx, second1EndPoint.dy);

    path.lineTo(size.width, size.height - 45);
    path.lineTo(size.width, 0.0);
    path.close();

    paint.color = colorOne;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}