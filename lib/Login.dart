import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Screen/DigitalCardScreen/MemberSelection.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '././common/DigitalCardCommon/Constants.dart' as cnst;
class LoginDigital extends StatefulWidget {
  @override
  _LoginDigitalState createState() => _LoginDigitalState();
}

Color colorOne = cnst.appcolor;
Color colorTwo = cnst.buttoncolor;
Color colorThree = Colors.grey[500];

class _LoginDigitalState extends State<LoginDigital> {
  bool isLoading = false;
  TextEditingController txtMobileNo = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Digital Card"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  CheckLogin() async {
    if (txtMobileNo.text != "") {
      setState(() {
        isLoading = true;
      });

      Future res = Services.MemberLogin(txtMobileNo.text);
      res.then((data) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          isLoading = false;
        });

        if (data != null && data.length > 0) {
          print("length : ${data.length}");
          if (data.length > 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MemberSelection(memberList: data),
              ),
            );
          } else {
            await prefs.setString(cnst.Session.MemberId, data[0].Id);
            await prefs.setString(cnst.Session.Name, data[0].Name);
            await prefs.setString(cnst.Session.Mobile, data[0].Mobile);
            await prefs.setString(cnst.Session.Company, data[0].Company);
            await prefs.setString(
                cnst.Session.ReferCode, data[0].MyReferralCode);
            Navigator.pushReplacementNamed(context, "/Dashboard");
          }
        } else {
          showMsg("Invalid login details");
        }
      }, onError: (e) {
        print("Error : on Login Call");
        showMsg("$e");
        setState(() {
          isLoading = false;
        });
      });
    } else {
      showMsg("Please enter login details");
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
                height: 280.0,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Image.asset("images/logo1.png",
                          width: 100.0, height: 100.0, fit: BoxFit.contain),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      'Digital Card',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                          //fontSize: 18.0,
                          ),
                    ),
                  ],
                ),
              ),
              painter: CurvePainter(),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              height: MediaQuery.of(context).size.height - 350.0,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        border: new Border.all(width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: TextFormField(
                      controller: txtMobileNo,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                    ),
                    //height: 40,
                    width: MediaQuery.of(context).size.width - 60,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    margin: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      color: Colors.green[700],
                      minWidth: MediaQuery.of(context).size.width - 60,
                      //onPressed: (){Navigator.pushNamed(context, '/Otp');},
                      onPressed: () {
                        CheckLogin();
                      },
                      child: setUpButtonChild(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Not a memeber yet?",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cnst.buttoncolor)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/Signup");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Signup Now",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: cnst.appcolor)),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    ));
  }

  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Login",
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

class CurvePainter extends CustomPainter {
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
