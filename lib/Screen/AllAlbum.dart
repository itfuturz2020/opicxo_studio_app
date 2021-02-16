import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/AllAlbumComponent.dart';
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotAssigned.dart';

class AllAlbum extends StatefulWidget {
  var Id, StudioId;
  AllAlbum(this.Id, this.StudioId);

  @override
  _AllAlbumState createState() => _AllAlbumState();
}

class _AllAlbumState extends State<AllAlbum> {
  List NewList = [];
  List Assigned = [];

  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    print("Helloworld => " + widget.Id.toString());
    _getCustomerGalleryList();
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

  String studioId = "";
  _getCustomerGalleryList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      studioId = await prefs.getString(cnst.Session.StudioId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetCustomerGalleryList(
            widget.Id.toString(), widget.StudioId.toString());
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
            for (int i = 0; i < NewList.length; i++) {
              if (NewList[i]["IsSelected"].toString() == '1') {
                Assigned.add(NewList[i]);
              }
            }
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    Assigned.add((Assigned.length + 1).toString());
    if (mounted)
      setState(() {
        Assigned.length += 1;
      });
    _refreshController.loadComplete();
  }

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
        actions: <Widget>[],
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
          "Albums",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.09,
            child: RaisedButton(
              child: Text(
                "Assign Album",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotAssigned(
                        Id: widget.Id,
                        StudioId: studioId,
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
      body: SmartRefresher(
        //enablePullDown: true,
        // enablePullUp: true,
        //header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    "images/11.png",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Assigned.length > 0
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8, bottom: 15),
                              child: ListView.builder(
                                  itemCount: Assigned.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SingleChildScrollView(
                                        child: AllAlbumComponent(
                                            Assigned[index], widget.Id));
                                  }),
                            ),
                          )
                        : NoDataComponent()
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
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Stack(
            //     children: [
            //       Container(
            //         color: Colors.white,
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height * 0.08,
            //       ),
            //       Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(25),
            //         ),
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height * 0.09,
            //         child: RaisedButton(
            //           child: Text(
            //             "Assign Album",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white,
            //               fontSize: 18,
            //             ),
            //           ),
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => NotAssigned(
            //                     Id: widget.Id,
            //                     StudioId: studioId,
            //                   ),
            //                 ));
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
