import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opicxo_studio_app/Screen/AddOffers.dart';
import 'package:opicxo_studio_app/Screen/LoginWithMobile.dart';

import 'package:opicxo_studio_app/common/Constants.dart' as cnst;
import 'Screen/AddBranch.dart';
import 'Screen/AddCustomerForm.dart';
import 'Screen/AllAlbum.dart';
import 'Screen/Branch.dart';
import 'Screen/CustomerList.dart';
import 'Screen/Dashboard.dart';
import 'Screen/DigitalCardScreen/AddCard.dart';
import 'Screen/DigitalCardScreen/AddService.dart';
import 'Screen/DigitalCardScreen/ChangeTheme.dart';
import 'Screen/DigitalCardScreen/EarnHistory.dart';
import 'Screen/DigitalCardScreen/EditProfile.dart';
import 'Screen/DigitalCardScreen/FlareLogin/FlareLogin.dart';
import 'Screen/DigitalCardScreen/InviteFriends.dart';
import 'Screen/DigitalCardScreen/MobileLogin.dart';
import 'Screen/DigitalCardScreen/More.dart';
import 'Screen/DigitalCardScreen/OfferInterestedMembers.dart';
import 'Screen/DigitalCardScreen/Payment.dart';
import 'Screen/DigitalCardScreen/PhoneContact.dart';
import 'Screen/DigitalCardScreen/ProfileDetail.dart';
import 'Screen/DigitalCardScreen/RedeemHisory.dart';
import 'Screen/DigitalCardScreen/ShareHistory.dart';
import 'Screen/DigitalCardScreen/Signup.dart';
import 'Screen/Login.dart';
import '././Login.dart';
import 'Screen/ManageBranch.dart';
import 'Screen/NotificationScreen.dart';
import 'Screen/OTPVerification.dart';
import 'Screen/PhotoContest.dart';
import 'Screen/ProfileScreen.dart';
import 'Screen/RedeemOffers.dart';
import 'Screen/ReferAndEarn.dart';
import 'Screen/ReferralCode.dart';
import 'Screen/Registration.dart';
import 'Screen/Splash.dart';
import 'Screen/TermsandConditions.dart';
import 'Screen/WinnerScreen.dart';
import './Screen/DigitalCardScreen/Dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return BackGestureWidthTheme(
      backGestureWidth: BackGestureWidth.fraction(1 / 2),
      child: MaterialApp(
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS:
                CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
          }),
          textTheme: GoogleFonts.aBeeZeeTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: cnst.appPrimaryMaterialColorPink,
          accentColor: cnst.appPrimaryMaterialColorPink,
          buttonColor: cnst.appPrimaryMaterialColorPink,
        ),
        title: "PICTIK_PHOTOGRAPHER",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/Login': (context) => Login(),
          '/Registration': (context) => Registration(),
          '/ReferralCode': (context) => ReferralCode(),
          '/OTPVerification': (context) => OTPVerification(),
          '/Dashboard': (context) => Dashboard(),
          '/NotificationScreen': (context) => NotificationScreen(),
          '/ReferAndEarn': (context) => ReferAndEarn(),
          '/AddBranch': (context) => AddBranch(),
          '/ProfileScreen': (context) => ProfileScreen(),
          //'/Customer': (context) => Customer(),
          '/Branch': (context) => Branch(),
          '/AddOffers': (context) => AddOffer(),
          '/WinnerScreen': (context) => WinnerScreen(),
          '/CustomerList': (context) => CustomerList(),
          '/PhotoContest': (context) => PhotoContest(),
          '/TermsandConditions': (context) => TermsandConditions(),
          '/AddCustomerForm': (context) => AddCustomerForm(),
          '/ManageBranch': (context) => ManageBranch(),
          '/RedeemOffers': (context) => RedeemOffers(),
          //  '/ImageView': (context) => ImageView(),
          '/Dashboard1': (context) => Dashboard1(),
          '/More': (context) => More(),
          '/ChangeTheme': (context) => ChangeTheme(),
          //'/OfferDetail': (context) => OfferDetail(),
          '/OfferInterestedMembers': (context) => OfferInterestedMembers(),
          '/InviteFriends': (context) => InviteFriends(),
          '/EarnHistory': (context) => EarnHistory(),
          '/RedeemHisory': (context) => RedeemHisory(),
          '/Signup': (context) => Signup(),
          '/LoginDigital': (context) => LoginDigital(),
          '/ShareHistory': (context) => ShareHistory(),
          '/PhoneContact': (context) => PhoneContact(),
          '/AddOffer': (context) => AddOffer(),
          '/AddService': (context) => AddService(),
          '/EditProfile': (context) => EditProfile(),
          '/ProfileDetail': (context) => ProfileDetail(),
          '/FlareLogin': (context) => FlareLogin(),
          '/MobileLogin': (context) => MobileLogin(),
          '/Payment': (context) => Payment(),
          '/AddCard': (context) => AddCard(),

          //'/AllAlbum': (context) => AllAlbum(),
          // '/SubAlbumEvent': (context) => SubAlbumEvent(),
          // '/SelectedPhotoList': (context) => SelectedPhotoList(),
        },
      ),
    );
  }
}
