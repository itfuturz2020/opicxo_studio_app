import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/DigitalCardScreen/MemberSelection.dart';
import 'package:opicxo_studio_app/Screen/Login.dart';
import 'package:opicxo_studio_app/Screen/ProfileScreen.dart';
import 'package:opicxo_studio_app/Screen/RedeemOffers.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'ReferAndEarn.dart';
import '../common/DigitalCardCommon/Services.dart' as digitalcardservice;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List bannerImage = [];
  TextEditingController txtMobile = new TextEditingController();
  String Name, url, Id, Mobile, studioid = "";
  DateTime currentBackPressTime;
  Map refercode = {};
  bool isLoading = true;
  double num = 0;
  double den = 0;
  double ans = 0;
  int _current = 0;

  List _list = [
    {
      "logo": "images/add1.png",
      "title": "Customer",
      "screen": "/CustomerList",
    },
    {
      "logo": "images/desk1.png",
      "title": "Branch",
      "screen": "/Branch",
    },
    {
      "logo": "images/photo.png",
      "title": "Add Offer",
      "screen": "/AddOffers",
    },
    /* {
      "logo": "images/trophy.png",
      "title": "Winners",
      "screen": "/WinnerScreen",
    },*/
  ];
  ProgressDialog pr;

  _getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      url = prefs.getString(cnst.Session.Image);
      Id = prefs.getString(cnst.Session.Id);
      Mobile = prefs.getString(cnst.Session.Mobile);
      studioid = prefs.getString(cnst.Session.StudioId);
      Name = prefs.getString(cnst.Session.Name);
    });
    txtMobile.text = "";
  }

  String s, s1;

  @override
  void initState() {
    _getLocal();
    _getBannerList();
    _getRefearlAndEarnCodeById();
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

  _getRefearlAndEarnCodeById() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var studioid = prefs.getString(Session.StudioId);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetRefearlAndEarnCodeById(studioid);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              refercode = data;
              num = refercode["UploadImageCount"];
              den = refercode["TotalImages"];
              ans = num / den;
              s = num.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
              print(num);
              s1 = den.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
              print(num);
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

  _getBannerList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetBannerList();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            List images = data;
            for (int i = 0; i < images.length; i++) {
              setState(() {
                bannerImage.add(cnst.ImgUrl + images[i]["Image"]);
              });
            }
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              bannerImage.clear();
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on Chapter Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("PICTIK"),
          content: new Text("Are You Sure You Want To Logout ?"),
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
                _logout();
              },
            ),
          ],
        );
      },
    );
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

  _logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     fit: BoxFit.fill, image: AssetImage('images/drawerimage.png')),
            color: appPrimaryMaterialColorPink),
        child: Stack(children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileScreen(url: url)));
              },
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: url != "" && url != null
                            ? FadeInImage.assetNetwork(
                                placeholder: "images/person.png",
                                height: 45.0,
                                width: 45.0,
                                fit: BoxFit.fill,
                                image: "${cnst.ImgUrl}" + "$url")
                            : Image.asset(
                                "images/person.png",
                                height: 45.0,
                                width: 45.0,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Welcome,${Name}",
                              style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RedeemOffers(
                      studioid: studioid,
                    )));
      },
      child: ListTile(
        title: Row(
          children: <Widget>[
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        // onTap: text=="Redeem & Offers" ?  Navigator.push(context,
        //   MaterialPageRoute(builder: (context) => RedeemOffers()),
        // ) : onTap,
      ),
    );
  }

  List ids = [];

  Future _scan() async {
    String barcode = await scanner.scan();
    print(barcode);
    ids = barcode.split("-");
    ScanOfferQRCode();
  }

  ScanOfferQRCode() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Services.ScanOfferQRCode(ids[0], ids[1], ids[2]).then((data) async {
          pr.hide();
          if (data.isNotEmpty) {
            Fluttertoast.showToast(
                msg: "Customer's Data Added Successfully",
                backgroundColor: cnst.appPrimaryMaterialColorYellow,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_SHORT);
            // Navigator.pushNamedAndRemoveUntil(
            //     context, "/RedeemOffers", (Route<dynamic> route) => false);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RedeemOffers(studioid: ids[2])),
            );
            showMsg() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    elevation: 2,
                    title: Center(
                      child: new Text(
                        data["Name"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    content: new Text(
                      data["Mobile"],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
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

            showMsg();
          } else {
            showMsg("Try Again");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  String mobileno = "";

  CheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileno = prefs.getString(Session.Mobile);
    Future res = digitalcardservice.Services.MemberLogin(mobileno);
    res.then((data) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isLoading = false;
      });

      if (data != null && data.length > 0) {
        print("length : ${data.length}");
        if (data.length > 1) {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MemberSelection(memberList: data),
          //   ),
          // );
          setSelectedMember(int index, String id) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(id, data[index].Id);
            await prefs.setString(cnst.Session.Name, data[index].Name);
            await prefs.setString(cnst.Session.Mobile, data[index].Mobile);
            await prefs.setString(cnst.Session.Email, data[index].Email);
            // await prefs.setString(
            //     cnst.Session.Company, widget.memberList[index].Company);
            // await prefs.setString(
            //     cnst.Session.ReferCode, widget.memberList[index].MyReferralCode);
            // await prefs.setBool(
            //     cnst.Session.IsActivePayment, widget.memberList[index].IsActivePayment);
          }

          setSelectedMember(0, cnst.Session.StudioId);
          setSelectedMember(0, cnst.Session.CustomerId);
          Navigator.pushReplacementNamed(context, "/Dashboard1");
        }
      } else {
        showMsg("Invalid login details");
      }
    }, onError: (e) {
      print("Error : on Login Call");
      showMsg("$e");
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryMaterialColorPink,
          actions: <Widget>[
            GestureDetector(
              onTap: _scan,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png",
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  _showConfirmDialog();
                },
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          title: Center(
            child: Text(
              "Home Page",
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _createHeader(),
              _createDrawerItem(
                icon: Icons.contacts,
                text: 'Privacy Policy',
              ),
              _createDrawerItem(
                icon: Icons.event,
                text: 'Terms & Conditions',
              ),
              _createDrawerItem(
                icon: Icons.local_offer,
                text: 'Redeem & Offers',
              ),
              Divider(),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "images/5-compressed.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: <Widget>[
                  isLoading
                      ? Container(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()))
                      : bannerImage.length > 0
                          ? CarouselSlider(
                              height: 180,
                              viewportFraction: 0.9,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 1500),
                              reverse: false,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              autoPlay: true,
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              items: bannerImage.map((i) {
                                return Builder(builder: (BuildContext context) {
                                  return ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11)),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: 'images/bnnr.png',
                                      image: i,
                                      height: 125,
                                      width: MediaQuery.of(context).size.width /
                                          1.13,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                  /*Image.asset(i,
                          width: MediaQuery.of(context).size.width);*/
                                });
                              }).toList(),
                            )
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Divider(
                              height: 4,
                              thickness: 1,
                              color: Colors.black54,
                              indent: MediaQuery.of(context).size.width / 100,
                              endIndent: MediaQuery.of(context).size.width / 50,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Divider(
                              height: 4,
                              thickness: 1,
                              color: Colors.black54,
                              indent: MediaQuery.of(context).size.width / 100,
                              endIndent: MediaQuery.of(context).size.width / 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: _list.length,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // _list[index]["screen"]=="/PhotoContest"?
                              // Fluttertoast.showToast(
                              //     msg: "Coming Soon",
                              //     backgroundColor: cnst.appPrimaryMaterialColorYellow,
                              //     textColor: Colors.white,
                              //     gravity: ToastGravity.BOTTOM,
                              //     toastLength: Toast.LENGTH_SHORT):
                              Navigator.pushReplacementNamed(
                                  context, _list[index]["screen"]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                /*
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  cnst.appPrimaryMaterialColorYellow,
                                  cnst.appPrimaryMaterialColorPink
                                ])),*/
                                child: Card(
                                  color: appPrimaryMaterialColorPink,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Image.asset(
                                        _list[index]["logo"],
                                        width: 50,
                                        height: 50,
                                        color: Colors.white,
                                        fit: BoxFit.fill,
                                      ),
                                      Text(
                                        _list[index]["title"],
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Photos Uploaded",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ":",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${s} / ${s1}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                                value: ans,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReferAndEarn()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appPrimaryMaterialColorPink,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Pay Online",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReferAndEarn()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: appPrimaryMaterialColorPink,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Refer & Earn",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       Navigator.pushReplacementNamed(context, "/Dashboard");
                            //     },
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         color: appPrimaryMaterialColorPink,
                            //         borderRadius: BorderRadius.circular(5),
                            //       ),
                            //       child: Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Text("Share",style: TextStyle(
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 19,
                            //         ),),
                            //       ),
                            //     ),
                            //
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                //CheckLogin();

                                Navigator.of(context).pushNamed('/Dashboard1');
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.78,
                                decoration: BoxDecoration(
                                  color: appPrimaryMaterialColorPink,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Manage My Digital Card",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;

  SizeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
            ),
          ),
        );
}
