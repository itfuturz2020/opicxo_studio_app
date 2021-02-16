import 'package:opicxo_studio_app/Components/DigitalCardComponents/HeaderComponent.dart';
import 'package:opicxo_studio_app/Screen/Login.dart';
import 'package:opicxo_studio_app/common/Constants.dart';

import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  String MemberId = "";

  @override
  void initState() {
    super.initState();
    GetProfileData();
  }

  GetProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.CustomerId);
    setState(() {
      MemberId = memberId;
    });
  }

  _logout() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text("Are you want to Logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(color: cnst.appMaterialColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: cnst.appMaterialColor),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) => Login()));
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            HeaderComponent(
              title: "More Options",
              image: "images/header/moreheader.jpg",
              boxheight: 110,
            ),
            Container(
              height: MediaQuery.of(context).size.height - 170,
              margin: EdgeInsets.only(top: 120),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/InviteFriends");
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/refer.png",
                                  height: 50, width: 50),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Refer & Earn",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),*/
                    GestureDetector(
                      onTap: () async {
                        /*SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove(cnst.Session.MemberId);
                        prefs.remove(cnst.Session.Name);
                        prefs.remove(cnst.Session.Mobile);
                        prefs.remove(cnst.Session.Company);
                        Navigator.pushReplacementNamed(context, "/MobileLogin");*/
                        /*String withrefercode = cnst.inviteFriMsg
                                  .replaceAll("#refercode", ReferCode);*/
                        /*String withappurl = cnst.inviteFriMsg.replaceAll(
                            "#appurl", cnst.playstoreUrl);
                        */ /*String withmemberid =
                              cnst.inviteFriMsg.replaceAll("#id", MemberId);*/ /*
                        */ /*String withrefercode = cnst.inviteFriMsg
                                  .replaceAll("#refercode", ReferCode);*/

                        String withappurl = cnst.inviteFriMsg
                            .replaceAll("#appurl", cnst.playstoreUrl);
                        String withmemberid =
                            withappurl.replaceAll("#id", MemberId);
                        Share.share(withmemberid);
                        Share.share(withappurl);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Invite a Friend",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, "/ShareHistory"),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/refer.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Share History",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/AddCard"),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Make New Card",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/ChangeTheme"),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/logo1.png",
                                  height: 35, width: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Theme",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        _logout();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: Colors.grey[600]))),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.power_settings_new, size: 35),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text("Logout",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ],
                          )),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
