import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InviteFriends extends StatefulWidget {
  @override
  _InviteFriendsState createState() => _InviteFriendsState();
}

class _InviteFriendsState extends State<InviteFriends> {
  final key = new GlobalKey<ScaffoldState>();

  EarnRedeemCountClass _earnRedeemCount =
      new EarnRedeemCountClass(EarnCount: '0', RedeemCount: '0');

  bool isLoading = false;
  String MemberId = "";
  String ReferCode = "";

  @override
  void initState() {
    super.initState();
    GetLocalData();
    GetEarnRedeemCount();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.MemberId);
    String referCode = prefs.getString(cnst.Session.ReferCode);

    if (memberId != null && memberId != "")
      setState(() {
        MemberId = memberId;
      });
    if (referCode != null && referCode != "")
      setState(() {
        ReferCode = referCode;
      });
  }

  GetEarnRedeemCount() async {
    setState(() {
      isLoading = true;
    });
    List<EarnRedeemCountClass> _dashboardCountList =
        await Services.GetEarnRedeemCount();
    if (_dashboardCountList != null && _dashboardCountList.length > 0) {
      setState(() {
        _earnRedeemCount = _dashboardCountList[0];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Refer & Earn'),
        ),
        key: key,
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //margin: EdgeInsets.only(top: 100),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey[300]),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            color: Colors.grey[400],
                            offset: Offset(0, 2))
                      ]),
                  child: Row(
                    children: <Widget>[
                      Image.asset("images/wallet.png", height: 50, width: 50),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                            "Share your referral link and invite your friends via SMS / Email / WhatsApp / more. You earn 200 points on each.",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/EarnHistory");
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 0),
                        width: (MediaQuery.of(context).size.width - 50) / 2,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              child: !isLoading
                                  ? Text("${_earnRedeemCount.EarnCount}",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: cnst.appcolor))
                                  : CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text("EARNED",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: cnst.buttoncolor)),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: cnst.buttoncolor),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/RedeemHisory");
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 0, left: 0),
                        width: (MediaQuery.of(context).size.width - 50) / 2,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            !isLoading
                                ? Text("${_earnRedeemCount.RedeemCount}",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                        color: cnst.appcolor))
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text("REDEEMED",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: cnst.buttoncolor)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width - 160) / 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 5, color: cnst.buttoncolor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                "images/friend.png",
                                height: 55,
                                width: 55,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("Invite your friends to sign up",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: cnst.buttoncolor),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 160) / 3,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 5, color: cnst.buttoncolor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                "images/logo1.png",
                                height: 55,
                                width: 55,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("Your friend get product from us",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: cnst.buttoncolor),
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 160) / 3,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 5, color: cnst.buttoncolor),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Image.asset(
                                "images/earn.png",
                                height: 55,
                                width: 55,
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text("You get rewarded",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[700])),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text("YOUR REFERRAL CODE",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500])),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                      color: cnst.buttoncolor,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Text(ReferCode,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(new ClipboardData(text: ReferCode));
                    key.currentState.showSnackBar(new SnackBar(
                        content: new Text("Code Copied"),
                        duration: Duration(milliseconds: 2)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Copy Code",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: cnst.appcolor)),
                  ),
                ),
                Container(
                  width: 200,
                  child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      elevation: 5,
                      textColor: Colors.white,
                      color: cnst.buttoncolor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "Refer Now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        String withmemberid =
                            cnst.inviteFriMsg.replaceAll("#id", MemberId);
                        String withrefercode =
                            withmemberid.replaceAll("#refercode", ReferCode);
                        String withappurl = withrefercode.replaceAll(
                            "#appurl", cnst.playstoreUrl);
                        Share.share(withappurl);
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                      "Notes : you can use earn points to purchase / renew your digital card membership",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500])),
                ),
              ],
            ),
          ),
        ));
  }
}

class headerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
