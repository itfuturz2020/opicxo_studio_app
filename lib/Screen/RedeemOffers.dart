import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Components/CustomerListComponent.dart';
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import '../common/Constants.dart' as cnst;
import 'AddCustomerForm.dart';
import 'RedeemOffersComponents.dart';
class RedeemOffers extends StatefulWidget {
  String studioid="";
  RedeemOffers({this.studioid});
  @override
  _RedeemOffersState createState() => _RedeemOffersState();
}

class _RedeemOffersState extends State<RedeemOffers> {

  TextEditingController _controller = TextEditingController();
  List searchList = new List();
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    "Directory",
    style: TextStyle(fontSize: 18),
  );

  void initState() {
    super.initState();
    GetOfferRedeem();
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
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

  List offerRedeemdata =[];
  GetOfferRedeem() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetOfferRedeem(widget.studioid.toString());
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              offerRedeemdata = data;
            });
          } else {
            setState(() {
              offerRedeemdata = [];
            });
          }
        }, onError: (e) {
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
  bool isfirst = false,_isSearching = false,isLoading = true;
  void searchOperation(String searchText) {
    searchList = [];
    if (searchText != null) {
      isfirst = true;
      for (int i = 0; i < offerRedeemdata.length; i++) {
        String name = offerRedeemdata[i]["Name"];
        if (name.toLowerCase().contains(_controller.text.toLowerCase())) {
          searchList.add(offerRedeemdata[i]);
        }
      }
    }
    setState(() {});
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text('Customer Directory');
      _isSearching = false;
      isfirst = false;
      searchList.clear();
      _controller.clear();
    });
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("offerRedeemdata");
    print(offerRedeemdata);
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
            "Redeem Offers",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        body:  Stack(
          children: <Widget>[
            Container(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  "images/13-compressed.jpg",
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.height / 1.7,
                    child: TextField(
                      controller: _controller,
                      onChanged: searchOperation,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          prefixIcon: GestureDetector(
                            onTap: () {
                              if (this.icon.icon == Icons.search) {
                                this.icon = new Icon(
                                  Icons.close,
                                  color: Colors.white,
                                );
                                this.appBarTitle = new TextField(
                                  controller: _controller,
                                  style: new TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: new InputDecoration(
                                      prefixIcon:
                                      new Icon(Icons.search, color: Colors.white),
                                      hintText: "Search...",
                                      hintStyle: new TextStyle(color: Colors.white)),
                                );
                                _handleSearchStart();
                              } else {
                                _handleSearchEnd();
                              }
                            },
                            child: Icon(
                              Icons.search,
                              color: cnst.appPrimaryMaterialColorPink,
                            ),
                          ),
                          counterText: "",
                          hintText: "Search",
                          hintStyle: TextStyle(fontSize: 17)),
                    ),
                  ),
                ),
                searchList.length > 0
                    ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: searchList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child:
                            AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds : 600),
                              child: SlideAnimation(
                                verticalOffset: 70,
                                child: FadeInAnimation(
                                  child: RedeemOffersComponents(
                                    searchList[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
                    : offerRedeemdata.length > 0
                    ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: offerRedeemdata.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child:
                            AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds : 600),
                              child: SlideAnimation(
                                horizontalOffset: 70,
                                child: FadeInAnimation(
                                  child: RedeemOffersComponents(
                                    offerRedeemdata[index],
                                    redeemoffers:0,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
                    : Expanded(child: NoDataComponent())
                /*Center(
                                  child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 250.0),
                                    child: Text(
                                      "No Data Found",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ))*/
              ],
            ),
          ],
        ),
    );
  }
}
