import 'package:flutter/material.dart';

const String API_URL = "http://pictick.itfuturz.com/api/PhotographerAPI/";
const String ImgUrl = "http://pictick.itfuturz.com/";
const String profileUrl = "http://digitalcard.co.in?uid=#id";
const String playstoreUrl = "shorturl.at/rEFWY";
const String smsLink = "sms:#mobile?body=#msg"; //mobile no with country code
const String mailLink = "mailto:#mail?subject=#subject&body=#msg";
const String inviteFriMsg =
    "smart & simple app to manage your digital visiting card & business profile.\nDownload the app from #appurl and use my refer code “#refercode” to get 15 days free trial.";
const Color buttoncolor = Color.fromRGBO(85, 96, 128, 1);
const Inr_Rupee = "₹";

//const String API_URL = "${cnst.ImgUrl}api/AppAPI/";
//const String API_URL = "http://thestudioom.itfuturz.com/AppAPI/";
const Studio_Id = "8";
const Color appcolor = Color.fromRGBO(0, 171, 199, 1);
const Color secondaryColor = Color.fromRGBO(85, 96, 128, 1);

const String whatsAppLink =
    "https://wa.me/#mobile?text=#msg"; //mobile no with country code

class APIURL {
  static const String API_URL =
      "http://digitalcard.co.in/DigitalcardService.asmx/";
  static const String API_URL_RazorPay_Order =
      "http://razorpayapi.itfuturz.com/Service.asmx/";
  static const String API_Studio_Url =
      "http://pictick.itfuturz.com/api/PhotographerAPI/";
}

class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class Session {
  static const String CustomerId = "CustomerId";
  static const String Id = "Id";
  static const String Mobile = "Mobile";
  static const String MobileNo = "MobileNo";
  static const String Name = "Name";
  static const String Bio = "Bio";
  static const String Image = "Image";
  static const String AlternateMobile = "AlternateMobile";
  static const String CompanyName = "CompanyName";
  static const String Email = "Email";
  static const String Password = "Password";
  static const String IsVerified = "IsVerified";
  static const String StudioId = "Id";
  static const String BranchId = "BranchId";
  static const String StudioName = "StudioName";
  static const String contestId = "contestId";
  static const String Address = "Address";
  static const String CityId = "CityId";
  static const String type = "type";
  static const String CityName = "CityName";
  static const String StateId = "StateId";
  static const String AlbumId = "AlbumId";
  static const String StateName = "StateName";
  static const String PinCode = "PinCode";
  static const String Type = "Type";
  static const String PinSelection = "PinSelection";
  static const String SelectedPin = "SelectedPin";
  static const String Photo = "Photo";
  static const String IssueDate = "IssueDate";
  static const String ValidTill = "ValidTill";
  static const String CommitieId = "CommitieId";
  static const String SlideShowSpeed = "SlideShowSpeed";
  static const String PlayMusic = "PlayMusic";
  static const String MusicURLId = "MusicURLId";
  static const String MusicURL = "MusicURL";
  static const String SlideTime = "SlideTime";
  static const String digital_Id = "digital_Id";
  static const String forFirstTime = "forFirstTime";
}

Map<int, Color> appprimarycolorspink = {
  50: Color.fromRGBO(1, 102, 165, .1),
  100: Color.fromRGBO(1, 102, 165, .2),
  200: Color.fromRGBO(1, 102, 165, .3),
  300: Color.fromRGBO(1, 102, 165, .4),
  400: Color.fromRGBO(1, 102, 165, .5),
  500: Color.fromRGBO(1, 102, 165, .6),
  600: Color.fromRGBO(1, 102, 165, .7),
  700: Color.fromRGBO(1, 102, 165, .8),
  800: Color.fromRGBO(1, 102, 165, .9),
  900: Color.fromRGBO(1, 102, 165, 1)
};

MaterialColor appPrimaryMaterialColorPink =
    MaterialColor(0xFF0166a5, appprimarycolorspink);

Map<int, Color> appprimarycolorsyellow = {
  50: Color.fromRGBO(1, 102, 165, .1),
  100: Color.fromRGBO(1, 102, 165, .2),
  200: Color.fromRGBO(1, 102, 165, .3),
  300: Color.fromRGBO(1, 102, 165, .4),
  400: Color.fromRGBO(1, 102, 165, .5),
  500: Color.fromRGBO(1, 102, 165, .6),
  600: Color.fromRGBO(1, 102, 165, .7),
  700: Color.fromRGBO(1, 102, 165, .8),
  800: Color.fromRGBO(1, 102, 165, .9),
  900: Color.fromRGBO(1, 102, 165, 1)
};

MaterialColor appPrimaryMaterialColorYellow =
    MaterialColor(0xFF0166a5, appprimarycolorsyellow);

// const String inviteFriMsg = "Hi there, \nYou came to my mind as I was using this interesting App *'Digital Card'*.\nhttp://digitalcard.co.in?uid=#id.\nI have been using this App to manage my business smartly & in a digital way.\nYou can also create your own business profile.\n\n*Download the App from the below link*. #appurl";
// const String profileUrl = "http://digitalcard.co.in?uid=#id";
