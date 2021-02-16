import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/AllAlbumComponent.dart';
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/Screen/NotAssignedComponent.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NotAssigned.dart';

class NotAssigned extends StatefulWidget {
  var Id, StudioId;
  NotAssigned({this.Id, this.StudioId});

  @override
  _NotAssignedState createState() => _NotAssignedState();
}

class _NotAssignedState extends State<NotAssigned> {
  List NewList = [];
  List NotAssigned = [];

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

  _getCustomerGalleryList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String studioId = await prefs.getString(cnst.Session.StudioId);
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
            for(int i=NewList.length-1;i>=0;i--){
              if(NewList[i]["IsSelected"].toString()!='1'){
                NotAssigned.add(NewList[i]);
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

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    NotAssigned.add((NotAssigned.length+1).toString());
    if(mounted)
      setState(() {
        NotAssigned.length+=1;
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
        actions: <Widget>[
          /* Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.search,
              size: 30,
            ),
          )*/
        ],
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
          "Assign Album",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
      body: SmartRefresher(
        // enablePullDown: true,
        //enablePullUp: true,
        //header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Stack(
          children: <Widget>[
            Container(
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : NotAssigned.length > 0
                    ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: NotAssigned.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          NotAssigned.reversed;
                          return SingleChildScrollView(
                              child: NotAssignedComponent(
                                  NotAssigned[index], widget.Id));
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
            //   child:  Stack(
            //     children: [
            //       Container(
            //         color: Colors.white,
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height*0.09,
            //       ),
            //       Container(
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(25),
            //         ),
            //         width: MediaQuery.of(context).size.width,
            //         height: MediaQuery.of(context).size.height*0.09,
            //         child: RaisedButton(
            //           child: Text("Not Assigned",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white,
            //               fontSize: 18,
            //             ),
            //           ),
            //           onPressed: (){
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => NotAssigned(),
            //                 ));
            //           },
            //         ),
            //       ),
            //
            //     ],
            //
            //   ),
            // ),

          ],

        ),
      ),
    );
  }
}
