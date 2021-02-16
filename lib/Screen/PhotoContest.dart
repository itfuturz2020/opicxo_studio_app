import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/WinnerScreen.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PhotoContestDescription.dart';

class PhotoContest extends StatefulWidget {
  @override
  _PhotoContestState createState() => _PhotoContestState();
}

class _PhotoContestState extends State<PhotoContest> {
  ProgressDialog pr;
  bool isLoading = true;
  List NewList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
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
            "Conteset",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 50),
            indicatorPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Photo contest",
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Winners",
                  style: GoogleFonts.aBeeZee(
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            PhotoContestDescription(),
            WinnerScreen(),
          ],
        ),
      ),
    );
  }
}
