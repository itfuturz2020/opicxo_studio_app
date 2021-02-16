import 'dart:io';

import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/ManageBranchComponent.dart';
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard.dart';

class ManageBranch extends StatefulWidget {
  @override
  _ManageBranchState createState() => _ManageBranchState();
}

class _ManageBranchState extends State<ManageBranch> {
  List NewList = [];
  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    _getAddressBranch();
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

  _getAddressBranch() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String studioId = await preferences.getString(cnst.Session.StudioId);
        Future res = Services.GetAddressBranch(studioId);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              NewList = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on NewLead Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
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
                opacity: 0.2,
                child: Image.asset(
                  "images/6.png",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : NewList.length > 0
                    ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: NewList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                              child: ManageBranchComponent(NewList[index],
                                      () {
                                    setState(() {
                                      _getAddressBranch();
                                      //   NewList.removeAt(index);
                                    }
                                    );
                                  })
                          );
                        }),
                  ),
                )
                    : Expanded(child: NoDataComponent())
                /* Center(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 250.0),
                          child: Text(
                            "No Data Found",
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w600),
                          ),
                        ))*/
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:  Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.09,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.09,
                    child: RaisedButton(
                      child: Text(
                        "Add Branch",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: (){
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AddBranch(),
                        //     ));
                        Navigator.pushNamed(context, '/AddBranch');
                      },
                    ),
                  ),

                ],

              ),
            ),

          ],

        ),
      ),
    );
  }
}
