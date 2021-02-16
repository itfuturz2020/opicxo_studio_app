import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/ManageBranchComponent.dart';
import 'package:opicxo_studio_app/Screen/AddBranch.dart';

import 'ManageBranch.dart';

class Branch extends StatefulWidget {
  @override
  _BranchState createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Manage Branch",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        centerTitle: true,
        // bottom: TabBar(
        //   labelPadding: EdgeInsets.symmetric(horizontal: 50),
        //   indicatorPadding: EdgeInsets.all(0),
        //   indicatorSize: TabBarIndicatorSize.tab,
        //   isScrollable: true,
        //   tabs: <Widget>[
        //     Tab(
        //       child: Text(
        //         "Add Branch",
        //         style: GoogleFonts.aBeeZee(
        //           textStyle: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.white),
        //         ),
        //       ),
        //     ),
        //     Tab(
        //       child: Text(
        //         "Manage Branch",
        //         style: GoogleFonts.aBeeZee(
        //           textStyle: TextStyle(
        //               fontSize: 15,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.white),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
      body:
          // TabBarView(
          //   children: <Widget>[
          // AddBranch(),
          ManageBranch(),
      //   ],
      // ),
    );
  }
}
