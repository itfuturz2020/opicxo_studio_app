import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opicxo_studio_app/Screen/DigitalCardScreen/Home.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'dart:async';

import 'AnimatedBottomBar.dart';
import 'More.dart';
import 'Offers.dart';
import 'Services.dart';
//Screens

class Dashboard1 extends StatefulWidget {
  final List<BarItem> barItems = [
    BarItem(
        text: "Home", iconData: Icons.home, color: appPrimaryMaterialColorPink),
    BarItem(
        text: "Service",
        iconData: Icons.people,
        color: appPrimaryMaterialColorPink),
    BarItem(
        text: "Offer",
        iconData: Icons.local_offer,
        color: appPrimaryMaterialColorPink),
    BarItem(
        text: "More", iconData: Icons.apps, color: appPrimaryMaterialColorPink),
  ];

  @override
  _Dashboard1State createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print("Push Messaging token: $token");
    // });
  }

  final List<Widget> _children = [
    Home(),
    MemberServices(),
    Offers(),
    More(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: AnimatedBottomBar(
            barItems: widget.barItems,
            animationDuration: Duration(milliseconds: 200),
            onBarTab: (index) {
              setState(() {
                _currentIndex = index;
              });
            }));
  }
}
