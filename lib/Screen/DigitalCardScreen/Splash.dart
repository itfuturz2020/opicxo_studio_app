import 'dart:async';

import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticIn,
    );
    animationController.forward();

    Timer(Duration(milliseconds: 4500), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String MemberId = prefs.getString(cnst.Session.MemberId);

      bool IsAppIntroCompleted =
          prefs.getBool(cnst.Session.IsAppIntroCompleted);

      if (MemberId != null && MemberId != "")
        Navigator.pushReplacementNamed(context, '/Dashboard1');
      else {
        if (IsAppIntroCompleted != null && IsAppIntroCompleted == true)
          Navigator.pushReplacementNamed(context, '/MobileLogin');
        else
          Navigator.pushReplacementNamed(context, '/AppIntro');
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RotationTransition(
            turns: animation,
            child: Container(
              height: 80,
              width: 80,
              child: Image.asset("images/logo1.png", height: 80, width: 80),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          FadeIn(
            3,

            Text(
              'Digital Card',
              style: TextStyle(
                  color: cnst.appMaterialColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                  //fontSize: 18.0,
                  ),
            ),
          )
        ],
      ),
    ));
  }
}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 3000), Tween(begin: 0.0, end: 1.0)),
      Track("translateX").add(
          Duration(milliseconds: 3000), Tween(begin: 0.0, end: 0.0),
          curve: Curves.easeOut)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (1000 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}
