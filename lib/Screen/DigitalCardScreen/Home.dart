import 'package:opicxo_studio_app/Components/DigitalCardComponents/CardShareComponent.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';

import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DashboardCountClass _dashboardCount =
      new DashboardCountClass(visitors: '0', calls: '0', share: '0');

  bool isLoading = false;
  bool isLoadingProfile = false;
  bool IsActivePayment = false;
  bool IsExpired = false;

  String MemberId = "";
  String Name = "";
  String UserName;
  String UserEmail;
  String UserPhone;
  String Company = "";
  String Photo = "";
  String CoverPhoto = "";
  String ReferCode = "";
  String ExpDate = "";
  String MemberType = "";
  String ShareMsg = "";
  String DigitalId = "";
  List<DigitalClass> digitalList = [];

  @override
  void initState() {
    super.initState();
    //GetProfileData();
    // GetDashboardCount();
    GetLocalData();
    GetProfile();
  }

  bool checkValidity() {
    if (ExpDate.trim() != null && ExpDate.trim() != "") {
      final f = new DateFormat('dd MMM yyyy');
      DateTime validTillDate = f.parse(ExpDate);
      print(validTillDate);
      DateTime currentDate = new DateTime.now();
      print(currentDate);
      if (validTillDate.isAfter(currentDate)) {
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isActivePayment = prefs.getBool(cnst.Session.IsActivePayment);

    if (isActivePayment != null)
      setState(() {
        IsActivePayment = isActivePayment;
        print(isActivePayment);
      });
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Digital Card"),
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

  GetProfileData() {
    setState(() {
      isLoadingProfile = true;
    });
    Services.GetMemberDetail().then((data) {
      setState(() {
        MemberId = data[0].Id;
        Name = data[0].Name;
        Company = data[0].Company;
        Photo = data[0].Image != null ? data[0].Image : "";
        CoverPhoto = data[0].CoverImage != null ? data[0].CoverImage : "";
        ReferCode = data[0].MyReferralCode;
        ExpDate = data[0].ExpDate;
        MemberType = data[0].MemberType;
        ShareMsg = data[0].ShareMsg;
        isLoadingProfile = false;
      });
      GetDashboardCount();
      print("MemberType : $MemberType");
    }, onError: (e) {
      setState(() {
        isLoadingProfile = false;
      });
    });
  }

  GetProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserPhone = prefs.getString(Session.Mobile);
      UserEmail = prefs.getString(Session.Email);
      UserName = prefs.getString(Session.Name);
    });

    CreateDigital(UserPhone, UserName, UserEmail);
  }

  GetDashboardCount() async {
    setState(() {
      isLoading = true;
    });
    Services.GetDashboardCount().then((val) async {
      print("val");
      print(val);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (val != null && val.length > 0) {
        await prefs.setString(
            cnst.Session.CardPaymentAmount, val[0].cardAmount);
        print("anirudh");
        print(val[0].cardAmount);
        setState(() {
          _dashboardCount = val[0];
        });
      }
      setState(() {
        isLoading = false;
      });
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
    });
  }

  //======by rinki
  CreateDigital(String Mobile, String Name, String Email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Future res = Services.MemberLogin(prefs.getString(cnst.Session.Mobile));
      setState(() {
        isLoading = true;
      });
      Services.CreateDigitalCard(
        Mobile,
        Name,
        Email,
      ).then((data) async {
        if (data != null && data.length > 0) {
          setState(() {
            isLoading = false;
          });
          print("length : ${data.length}");
          if (data.length > 0) {
            setState(() {
              isLoading = false;
              // isMultipleCard = true;
              digitalList = data;
            });
            print("========================succesfull");
            print("========================${digitalList[0].Id}");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(Session.digital_Id, digitalList[0].Id);
            DigitalId = prefs.getString(Session.digital_Id);
            GetProfileData();
          }
        } else {
          setState(() {
            isLoading = false;
          });
          showMsg("Data Send");
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        print("Error : Data Not Saved");
        showMsg("$e");
      });
    } catch (Ex) {
      setState(() {
        isLoading = false;
      });
      showMsg("Something Went Wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  ClipPath(
                    child: FadeInImage.assetNetwork(
                        placeholder: "images/profilebackground.png",
                        image: CoverPhoto,
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover),
                    clipper: MyClipper(),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.24),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Photo == ""
                            ? Container(
                                decoration: new BoxDecoration(
                                    color: appPrimaryMaterialColorPink,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75))),
                                width: 100,
                                height: 100,
                                child: Center(
                                    // child: Text(
                                    //     "${Name.toString().substring(0, 1)}",
                                    //     style: TextStyle(
                                    //         decoration: TextDecoration.none,
                                    //         fontSize: 30,
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w500),
                                    // ),
                                    ),
                              )
                            : Container(
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "images/users.png",
                                    image: Photo,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        !isLoadingProfile
                            ? Column(
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(Name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600))),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 0),
                                      child: Text(Company,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepOrange,
                                              fontWeight: FontWeight.w600))),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, "/ProfileDetail"),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Edit Profile",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      appPrimaryMaterialColorPink,
                                                  fontWeight: FontWeight.w600)),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Icon(Icons.edit,
                                                color:
                                                    appPrimaryMaterialColorPink,
                                                size: 17),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: appPrimaryMaterialColorPink,

                                  // boxShadow: [
                                  //   new BoxShadow(
                                  //     color: Colors.grey[500],
                                  //     blurRadius: 20.0,
                                  //     spreadRadius: 1.0,
                                  //   )
                                  // ],
                                ),
                                child: Column(
                                  children: <Widget>[
                                    !isLoading
                                        ? Text(_dashboardCount.visitors,
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))
                                        : SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                appPrimaryMaterialColorPink,
                                              ),
                                              strokeWidth: 3,
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text("Visitors",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                height: 85,
                                width: 85,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/ShareHistory'),
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      gradient: new LinearGradient(
                                          begin: FractionalOffset(0, 1.0),
                                          end: FractionalOffset(0, 0),
                                          colors: [
                                            appPrimaryMaterialColorPink,
                                            appPrimaryMaterialColorPink
                                          ]),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Colors.grey[500],
                                          blurRadius: 20.0,
                                          spreadRadius: 1.0,
                                        )
                                      ]),
                                  child: Column(
                                    children: <Widget>[
                                      !isLoading
                                          ? Text(_dashboardCount.share,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600))
                                          : SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
                                                strokeWidth: 3,
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Share",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                  ),
                                  height: 85,
                                  width: 85,
                                ),
                              ),
                            ),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: new LinearGradient(colors: [
                                      appPrimaryMaterialColorPink,
                                      appPrimaryMaterialColorPink
                                    ]),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.grey[500],
                                        blurRadius: 20.0,
                                        spreadRadius: 1.0,
                                      )
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    !isLoading
                                        ? Text(_dashboardCount.calls,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))
                                        : SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blue),
                                              strokeWidth: 3,
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text("Calls",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                                height: 85,
                                width: 85,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 5,
                                  textColor: Colors.white,
                                  color: appPrimaryMaterialColorPink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.share,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text("Share",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    bool val = checkValidity();
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, _, __) =>
                                                CardShareComponent(
                                          memberId: DigitalId,
                                          memberName: Name,
                                          isRegular: val,
                                          memberType: MemberType,
                                          shareMsg: ShareMsg,
                                          IsActivePayment: IsActivePayment,
                                        ),
                                      ),
                                    );
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 5,
                                  textColor: Colors.white,
                                  color: appPrimaryMaterialColorPink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset("images/logo1.png",
                                          height: 24, width: 24),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text("Refer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    String withrefercode = cnst.inviteFriMsg
                                        .replaceAll("#refercode", ReferCode);
                                    String withappurl = cnst.inviteFriMsg
                                        .replaceAll(
                                            "#appurl", cnst.playstoreUrl);
                                    String withmemberid =
                                        withappurl.replaceAll("#id", DigitalId);
                                    Share.share(withmemberid);
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: (IsActivePayment == true) &&
                                  (MemberType.toLowerCase() == "trial" ||
                                      checkValidity() == false)
                              ? MainAxisAlignment.spaceEvenly
                              : MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RaisedButton(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  elevation: 5,
                                  textColor: Colors.white,
                                  color: appPrimaryMaterialColorPink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text("View Card",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                      )
                                    ],
                                  ),
                                  onPressed: () async {
                                    String profileUrl = cnst.profileUrl
                                        .replaceAll("#id", DigitalId);
                                    if (await canLaunch(profileUrl)) {
                                      await launch(profileUrl);
                                    } else {
                                      throw 'Could not launch $profileUrl';
                                    }
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0))),
                            ),
                            (IsActivePayment == true) &&
                                    (MemberType.toLowerCase() == "trial" ||
                                        checkValidity() == false)
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      elevation: 5,
                                      textColor: Colors.white,
                                      color: cnst.buttoncolor,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "${cnst.Inr_Rupee}  Pay Now",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/Payment');
                                      },
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : WillPopScope(
            onWillPop: () => Navigator.pushNamedAndRemoveUntil(
                context, "/Dashboard", (Route<dynamic> route) => false),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
            ),
          );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
/*class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();


    path.lineTo(0, 0);
    path.quadraticBezierTo(
        size.width / 2, 80, size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height-80);
    //path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height, 0, size.height-80);


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}*/
