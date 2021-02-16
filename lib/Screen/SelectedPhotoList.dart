import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/Components/SelectedPhotoListComponent.dart';
import 'package:opicxo_studio_app/Screen/AddMultipleImages.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedPhotoList extends StatefulWidget {
  var Id, Name;

  SelectedPhotoList(this.Id, this.Name);

  @override
  _SelectedPhotoListState createState() => _SelectedPhotoListState();
}

class _SelectedPhotoListState extends State<SelectedPhotoList> {
  List NewList = [];
  ProgressDialog pr;
  bool isLoading = true;
  List albumData = new List();

  @override
  void initState() {
    _getSelectedAlbumPhotoList();
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

  _getSelectedAlbumPhotoList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Future res = Services.GetSelectedAlbumPhotoList(widget.Id.toString());
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
          centerTitle: true,
          title: Text(
            "${widget.Name}",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                "images/7.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())

              : NewList.length > 0
              ? Container(
              child: StaggeredGridView.countBuilder(
                padding: const EdgeInsets.only(left: 3, right: 3, top: 5),
                crossAxisCount: 4,
                itemCount: NewList.length,
                addRepaintBoundaries: false,
                itemBuilder: (BuildContext context, int index) {
                  return SelectedPhotoListComponent(NewList[index]);
                },
                staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              )):Center(
              child: Text(
                "No Data Found",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              )),
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
                    child: Text("Add Photos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMultipleImages(
                                GalleryId:widget.Id.toString(),
                                FolderName:widget.Name.toString(),
                                albumid :  widget.Id.toString(),
                            newdataaddedd: (value){
                                  if(value=="dataaddedd"){
                                    _getSelectedAlbumPhotoList();
                                  }
                            },
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),

        ],

        ));
  }
}
