import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Components/CustomerListComponent.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Components/NoDataComponent.dart';
import 'package:opicxo_studio_app/Screen/AddCustomerForm.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'Dashboard.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List NewList = [];
  ProgressDialog pr;
  bool isLoading = true;

  TextEditingController _controller = TextEditingController();

  List searchList = new List();

  List WingData = new List();
  bool _isSearching = false,
      isfirst = false,
      isFilter = false,
      isMemberLoading = false;
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  Widget appBarTitle = new Text(
    "Directory",
    style: TextStyle(fontSize: 18),
  );

  void searchOperation(String searchText) {
    searchList = [];
    if (searchText != null) {
      isfirst = true;
      for (int i = 0; i < NewList.length; i++) {
        String name = NewList[i]["Name"];
        if (name.toLowerCase().contains(_controller.text.toLowerCase())) {
          searchList.add(NewList[i]);
        }
      }
    }
    setState(() {});
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
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

  @override
  void initState() {
    _getCustomerList();
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

  _getCustomerList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String StudioId = await preferences.getString(cnst.Session.Id);
        // String photographerId = await preferences.getString(cnst.Session.Id);

        Future res = Services.GetCustomerList(StudioId);
        setState(() {
          isLoading = true;
        });

        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              NewList = data;
              isLoading = false;
            });
            NewList.sort((a, b) => a["Selected"].compareTo(b["Selected"]));
            NewList = new List.from(NewList.reversed);
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
    print("_onRefresh");
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    searchList.add((searchList.length + 1).toString());
    if (mounted) print(searchList.length);
    setState(() {
      searchList.length += 1;
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
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
            "Customer List",
            style: GoogleFonts.aBeeZee(
              textStyle: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                                      prefixIcon: new Icon(Icons.search,
                                          color: Colors.white),
                                      hintText: "Search...",
                                      hintStyle:
                                          new TextStyle(color: Colors.white)),
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
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : searchList.length > 0
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: searchList.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return
                                        // AnimationConfiguration.staggeredList(
                                        // position: index,
                                        // duration:
                                        //     const Duration(milliseconds: 600),
                                        // child: SlideAnimation(
                                        //   verticalOffset: 70,
                                        //   child: FadeInAnimation(
                                        //     child:
                                        CustomerListComponent(
                                      searchList[index],
                                      //       ),
                                      //
                                      //     ),
                                      //   ),
                                    );
                                  }),
                            ),
                          )
                        : NewList.length > 0
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      itemCount: NewList.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return
                                            // AnimationConfiguration
                                            //   .staggeredList(
                                            // position: index,
                                            // duration:
                                            //     const Duration(milliseconds: 600),
                                            // child: SlideAnimation(
                                            //   horizontalOffset: 70,
                                            //   child: FadeInAnimation(
                                            //     child:
                                            CustomerListComponent(
                                          NewList[index],
                                          //     ),
                                          //   ),
                                          // ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: RaisedButton(
                      child: Text(
                        "Add Customer",
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
                              builder: (context) => AddCustomerForm(),
                            ));
                      },
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
