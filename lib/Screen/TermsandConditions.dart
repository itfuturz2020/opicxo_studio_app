import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/common/Services.dart';

class TermsandConditions extends StatefulWidget {
  @override
  _TermsandConditionsState createState() => _TermsandConditionsState();
}

class _TermsandConditionsState extends State<TermsandConditions> {
  List _termsAndConditionList = [];
  bool isLoading = false;

  @override
  void initState() {
    _getTermsAndCondition();
  }

  _getTermsAndCondition() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetTermsAndCondition();
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _termsAndConditionList = data;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("$e");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'Rubric Group'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, "/Login",
                    (Route<dynamic> route) => false);
            //Navigator.pushReplacementNamed(context, "/Login");
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
        centerTitle: true,
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      body: Stack(

        children: <Widget>[

          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/9.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
              itemCount: _termsAndConditionList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${_termsAndConditionList[index]["Id"]}. ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                          child: Text(
                              "${_termsAndConditionList[index]["Title"]}",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                );
              }),
        ],
      ),


    );
  }
}
