import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/NotificationComponent.dart';
import 'package:opicxo_studio_app/common/Services.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
  List list = new List();

  @override
  void initState() {
    _getPhotographerNotificationList();
    isLoading = true;
    // TODO: implement initState
    super.initState();
    //   getDailyProgressFromServer();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  _getPhotographerNotificationList() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Future res = Services.GetPhotographerNotificationList();
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              isLoading = false;
              list = data;
            });
          } else {
            //showMsg("Try Again.");
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          print("Error : on Login Call $e");
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  /* _getNotification() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetNotification(Data).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              notificationList = data;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showMsg("Something went wrong.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }*/

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
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
          "Notification",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
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
                "images/back009.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : list.length != 0 && list != null
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 5),
                          itemCount: 3,
                          itemBuilder: (BuildContext context, int index) {
                            return NotificationComponent(list[index]);
                          },
                        )
                      : NoDataComponent()),
        ],
      ),

      /*Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : list.length != 0 && list != null
              ? ListView.builder(
            padding: EdgeInsets.only(top: 5),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return NotificationComponent(list[index]);
            },
          )
              : NoDataComponent()),*/
    );
  }
}
