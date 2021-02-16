import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';

class AppIntro extends StatelessWidget {
  final pages = [
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        // iconImageAssetPath: 'assets/air-hostess.png',
        bubble: Image.asset('images/logo1.png'),
        body: Text(
          'Create your Own Digital Business Card It takes just 5 minutes to create your own business card.',
          style: TextStyle(fontSize: 20),
        ),
        title: Text(''),
        /*title: Text( 'Create Digital Card', style: TextStyle(fontSize: 20)),*/
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset( 'images/logo1.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      bubble: Image.asset('images/savetophone.png'),
      body: Text(
        'Save to Your Device in the form of App or Link It is accessible anytime from anywhere.',
        style: TextStyle(fontSize: 20),
      ),
      title: Text(''),
      /*title: Text('Save To Phone',style: TextStyle(fontSize: 20),),*/
      mainImage: Image.asset(
        'images/savetophone.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      bubble: Image.asset("images/introappshare.png"),
      body: Text(
        'Share with friends, colleagues & clients through a variety of channels.',
        style: TextStyle(fontSize: 20),
      ),
      title: Text(''),
      /*title: Text('Share',style: TextStyle(fontSize: 20),),*/
      mainImage: Image.asset(
        'images/introappshare.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          onTapDoneButton: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool(cnst.Session.IsAppIntroCompleted, true);
            Navigator.pushNamed(context, "/MobileLogin");
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    );
  }
}
