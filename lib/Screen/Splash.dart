import 'dart:async';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String Id = prefs.getString(cnst.Session.Id);
      String veri = prefs.getString(cnst.Session.IsVerified);
      if (Id != null && Id != "" && veri == "true") {
        Navigator.pushReplacementNamed(context, '/Dashboard');
        //Navigator.pushReplacementNamed(context, '/GuestDashboard');

      } else {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/logo1.png",
                width: 250.0, height: 250.0, fit: BoxFit.contain),
            /*Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'The Studio Om',
                style: TextStyle(
                    color: cnst.secondaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700
                    //fontSize: 18.0,
                    ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
