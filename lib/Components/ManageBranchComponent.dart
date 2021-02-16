import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/EditBranchForm.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ManageBranchComponent extends StatefulWidget {
  final Function onChange;
  var NewList;

  ManageBranchComponent(this.NewList, this.onChange);

  @override
  _ManageBranchComponentState createState() => _ManageBranchComponentState();
}

class _ManageBranchComponentState extends State<ManageBranchComponent> {
  ProgressDialog pr;
  bool isLoading = false;

  @override
  void initState() {
    //  print("Yash-> "+widget.NewList["Id"].toString());
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(cnst.appPrimaryMaterialColorPink),
          ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
    // TODO: implement initState
    super.initState();
  }

  _deleteAddressBranch() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res =
            Services.DeleteAddressBranch(widget.NewList["Id"].toString());
        res.then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.Data != "0" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Data Deleted Successfully",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM);
            widget.onChange();
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

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: new Text("Rubric Group"),
          content: new Text("Are You Sure You Want To Remove This ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAddressBranch();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Card(
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
                   padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                children: [
                  Text("${widget.NewList["MainStudioName"]}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              final String number ="tel:${widget.NewList["Mobile"]}";
                              if(await canLaunch(number)){
                                await launch(number);
                              }
                              else {
                                throw "Can't connect";
                              }
            },
                            child: Icon(
                              Icons.call,
                              size: 24,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async{
                              final String email ="mailto:${widget.NewList["Email"]}";
                              if(await canLaunch(email)){
                                await launch(email);
                              }
                              else {
                                throw "Can't connect";
                              }
                            },
                            child: Icon(
                              Icons.email,
                              size: 24,color: Colors.purple,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                          onTap: () {
                              _showConfirmDialog();
                            },
                            child: Image.asset(
                                                  "images/delete.png",
                                                  height: 21,
                                                  color: Colors.red,
                                                  width: 21,
                                                ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          GestureDetector(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => EditBranchForm(
                                                      widget.NewList["Id"].toString(),
                                                      widget.NewList["StudioName"].toString(),
                                                      widget.NewList["Mobile"].toString(),
                                                      widget.NewList["AlternateMobile"].toString(),
                                                      widget.NewList["Email"].toString(),
                                                      widget.NewList["StateId"].toString(),
                                                      widget.NewList["CityId"].toString(),
                                                      widget.NewList["Address"].toString(),
                                                      widget.NewList["Pincode"].toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                            child: Image.asset(
                                                  "images/pencil.png",
                                                  height: 25,
                                                  width: 25,color: Colors.lightBlue,
                                                ),
                          ),
                          SizedBox(
                            height: 8,
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

    );
  }
}
