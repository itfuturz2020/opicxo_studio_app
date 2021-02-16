import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//Custom Files
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:xml2json/xml2json.dart';

import '../Constants.dart';
import 'ClassList.dart';
import 'ClassList.dart';

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {
  static Future<List<MemberClass>> MemberLogin(String mobileno) async {
    String url =
        APIURL.API_URL + 'Member_login?type=mobilelogin&mobileno=$mobileno';
    print("MemberLogin URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        List<MemberClass> list = [];
        print("MemberLogin Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        MemberDataClass memberDataClass =
            new MemberDataClass.fromJson(jsonResponse);

        if (memberDataClass.ERROR_STATUS == false)
          list = memberDataClass.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<String> UpdateDigitalProfileMember(
    String Image,
    String CoverImage,
    String Name,
    String Mobile,
    String Email,
    String website,
    String Whatsappno,
    String PersonalPAN,
    String Facebooklink,
    String Twitter,
    String Google,
    String Linkedin,
    String YouTube,
    String Instagram,
    String About,
    String Company,
    String Role,
    String CompanyPhone,
    String CompanyPAN,
    String GstNo,
    String Map,
    String CompanyEmail,
    String CompanyUrl,
    String CompanyAddress,
    String AboutCompany,
    String ShareMsg,
    String memberid,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    String message = "";

    String url = APIURL.API_URL +
        'UpdateMemberProfile?type=profile&Image=$Image&CoverImage=$CoverImage&Name=$Name&Mobile=$Mobile&Email=$Email&website=$website&Whatsappno=$Whatsappno&PersonalPAN=$PersonalPAN&Facebooklink=$Facebooklink&Twitter=$Twitter&Google=$Google&Linkedin=$Linkedin&YouTube=$YouTube&Instagram=$Instagram&About=$About&Company=$Company&Role=$Role&CompanyPhone=$CompanyPhone&CompanyPAN=$CompanyPAN&GstNo=$GstNo&Map=$Map&CompanyEmail=$CompanyEmail&CompanyUrl=$CompanyUrl&CompanyAddress=$CompanyAddress&AboutCompany=$AboutCompany&ShareMsg=$ShareMsg&memberid=$memberid';
    print("UpdateMemberProfile URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        print("UpdateMemberProfile Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        UpdateDigitalProfile updateTheme =
            new UpdateDigitalProfile.fromJson(jsonResponse);

        if (updateTheme.ERROR_STATUS == false)
          message = "Successfully Inserted!";

        return message;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<DigitalClass>> CreateDigitalCard(
      String mobileNo, String name, String email) async {
    String url = APIURL.API_URL +
        'CheckDigitalCardMember?mobileNo=$mobileNo&name=$name&email=$email';
    print("CheckDigitalCardMember URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        List<DigitalClass> list = [];
        print("CheckDigitalCardMember Response: " + response.body);

        final jsonResponse = json.decode(response.body);
        DigitalDataClass memberDataClass =
            new DigitalDataClass.fromJson(jsonResponse);

        if (memberDataClass.ERROR_STATUS == false)
          list = memberDataClass.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Login Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }
  /*static Future<SaveDataClass> uploadBrochure(data) async {
    String url = APIURL.API_URL + 'UpdateBrochure';
    print("UpdateBrochure URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("UpdateBrochure response :" + jsonResponse.toString());
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }*/

  static Future<SaveDataClass> uploadBrochure(body) async {
    print(body.toString());
    String url = APIURL.API_URL + 'UpdateBrochure';
    print("UpdateBrochure : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.data);
        print("UpdateBrochure response =" + jsonResponse.toString());
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List<DashboardCountClass>> GetDashboardCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    List<DashboardCountClass> list = [];

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL +
          'GetDashboardCount?type=dashboardcount&Member_Id=$memberId';
      print("MemberLogin URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          DashboardCountDataClass dashboardCountDataClass =
              new DashboardCountDataClass.fromJson(jsonResponse);

          if (dashboardCountDataClass.ERROR_STATUS == false)
            list = dashboardCountDataClass.Data;
          else
            list = [];

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetDashboardCount Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } else
      return list;
  }

  static Future<List<EarnRedeemCountClass>> GetEarnRedeemCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);
    String referCode = prefs.getString(cnst.Session.ReferCode);

    List<EarnRedeemCountClass> list = [];

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL +
          'GetEarnRedeemCount?type=earnredeemcount&referCode=$referCode&memberid=$memberId';
      print("GetEarnRedeemCount URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          EarnRedeemCountDataClass earnRedeemCountDataClass =
              new EarnRedeemCountDataClass.fromJson(jsonResponse);

          if (earnRedeemCountDataClass.ERROR_STATUS == false)
            list = earnRedeemCountDataClass.Data;
          else
            list = [];

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetDashboardCount Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } else
      return list;
  }

  static Future<List> GetMemberServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String Id = prefs.getString(Session.StudioId);
    String url = APIURL.API_Studio_Url +
        //'GetMemberServices?type=memberservices&memberid=$memberId';
        'GetStudioServices?studioid=$Id';
    // String url = API_URL + 'GetPhotographerNotificationList?photographerId=$Id';
    print("GetStudioServices URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetStudioServices: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("something went wrong");
      }
    } catch (e) {
      print("GetPhotographerNotificationList Error : " + e.toString());
      throw Exception("something went wrong");
    }
  }
  // static Future<Map> GetMemberServices() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String memberId = prefs.getString(Session.StudioId);
  //
  //   Map list = {};
  //
  //   if (memberId != null && memberId != "") {
  //     String url = APIURL.API_Studio_Url +
  //         //'GetMemberServices?type=memberservices&memberid=$memberId';
  //         'GetStudioServices?studioid=$memberId';
  //     print("GetStudioServices URL: " + url);
  //     final response = await http.get(url);
  //     try {
  //       if (response.statusCode == 200) {
  //         //if (!response.body.contains('"Data":null')) {
  //         final jsonResponse = json.decode(response.body);
  //
  //         // ServicesDataClass servicesDataClass =
  //         //     new ServicesDataClass.fromJson(jsonResponse);
  //
  //         // if (servicesDataClass.ERROR_STATUS == false &&
  //         //     servicesDataClass.Data.length > 0)
  //         //   list = servicesDataClass.Data;
  //         // else
  //         //   list = null;
  //         //}
  //         return jsonResponse["Data"];
  //       } else {
  //         throw Exception(MESSAGES.INTERNET_ERROR);
  //       }
  //     } catch (e) {
  //       print("GetStudioServices Erorr : " + e.toString());
  //       throw Exception(MESSAGES.INTERNET_ERROR);
  //     }
  //   } else
  //     return list;
  // }

  static Future<List<OfferClass>> GetMemberOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    List<OfferClass> list = [];

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL +
          'GetMemberOffers?type=memberoffers&memberid=$memberId';
      print("GetMemberOffers URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          OfferDataClass offerDataClass =
              new OfferDataClass.fromJson(jsonResponse);

          if (offerDataClass.ERROR_STATUS == false &&
              offerDataClass.Data.length > 0)
            list = offerDataClass.Data;
          else
            list = null;

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetMemberOffers Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } else
      return list;
  }

  static Future<List<OfferInterestedClass>> GetOfferInterested(
      String offerid) async {
    List<OfferInterestedClass> list = [];
    String url = APIURL.API_URL +
        'GetOfferInterested?type=offerinterested&offerid=$offerid';
    print("GetOfferInterested URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        OfferInterestedDataClass offerInterestedDataClass =
            new OfferInterestedDataClass.fromJson(jsonResponse);

        if (offerInterestedDataClass.ERROR_STATUS == false &&
            offerInterestedDataClass.Data.length > 0)
          list = offerInterestedDataClass.Data;
        else
          list = null;

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMemberOffers Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<EarnHistoryClass>> GetEarnHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String referCode = prefs.getString(cnst.Session.ReferCode);
    List<EarnHistoryClass> list = [];
    if (referCode != null && referCode != "") {
      String url =
          APIURL.API_URL + 'GetEarnHistory?type=earn&referCode=$referCode';
      print("GetOfferInterested URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          EarnHistoryDataClass earnHistoryDataClass =
              new EarnHistoryDataClass.fromJson(jsonResponse);

          if (earnHistoryDataClass.ERROR_STATUS == false &&
              earnHistoryDataClass.Data.length > 0)
            list = earnHistoryDataClass.Data;
          else
            list = null;

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetMemberOffers Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    }
  }

  static Future<List<RedeemHistoryClass>> GetRedemHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    List<RedeemHistoryClass> list = [];

    if (memberId != null && memberId != "") {
      String url =
          APIURL.API_URL + 'GetRedemHistory?type=redeem&memberid=$memberId';
      print("GetOfferInterested URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          RedeemHistoryDataClass redeemHistoryDataClass =
              new RedeemHistoryDataClass.fromJson(jsonResponse);

          if (redeemHistoryDataClass.ERROR_STATUS == false)
            list = redeemHistoryDataClass.Data;
          else
            list = [];

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetMemberOffers Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    }
  }

  static Future<List<ShareClass>> GetShareHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    List<ShareClass> list = [];

    if (memberId != null && memberId != "") {
      String url =
          APIURL.API_URL + 'GetShareHistory?type=share&memberid=$memberId';
      print("GetShareHistory URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          ShareDataClass shareDataClass =
              new ShareDataClass.fromJson(jsonResponse);

          if (shareDataClass.ERROR_STATUS == false &&
              shareDataClass.Data.length > 0)
            list = shareDataClass.Data;
          else
            list = null;

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("GetShareHistory Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    }
  }

  static Future<List<ThemeChange>> ChangeThemeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);
    print("memberid");
    print(memberId);
    List<ThemeChange> list = [];

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL + 'GetThemes?type=themes';
      print("GetThemeImage URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          print(jsonResponse);
          ChangeThemeData ThemeChange =
              new ChangeThemeData.fromJson(jsonResponse);
          if (ThemeChange.ERROR_STATUS == false && ThemeChange.Data.length > 0)
            list = ThemeChange.Data.toList();
          else
            list = [];
          print("list");
          print(list);
          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("ChangeThemeImage Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    }
  }

  static Future<SaveDataClass> SaveOffer(data) async {
    String url = APIURL.API_URL + 'AddOffer';
    print("AddOffer URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
        return data;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> DeleteOffer(data) async {
    String url = APIURL.API_URL + 'DeleteOffer';
    print("DeleteOffer URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("DeleteOffer Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> UpdateOffer(data) async {
    String url = APIURL.API_URL + 'UpdateOffer';
    print("UpdateOffer URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateOffer Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }
// static Future<SaveDataClass> SaveService(data) async {
//     String url = APIURL.API_Studio_Url + 'AddStudioService';
//     print("AddService URL: " + url);
//     final response = await http.post(url, body: data);
//     try {
//       if (response.statusCode == 200) {
//         SaveDataClass data;
//         final jsonResponse = json.decode(response.body);
//         SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
//         return saveDataClass;
//         return data;
//       } else {
//         print("==================>${response.body}");
//       }
//     } catch (e) {
//       print("SaveTA Erorr : " + e.toString());
//       throw Exception(MESSAGES.INTERNET_ERROR);
//     }
//   }

  static Future<Map<String, dynamic>> SaveService(body) async {
    String url = "";
    url = APIURL.API_Studio_Url + 'AddStudioService';
    print("AddService : " + url);
    try {
      final response = await dio.post(url, data: body);
      print("==================${response.data}");
      if (response.statusCode == 200) {
        var responseData = response.data;
        var xmlString = responseData.toString();
        final Xml2Json xml2Json = Xml2Json();
        xml2Json.parse(xmlString);
        var jsonString = xml2Json.toParker();
        var jsondata = jsonDecode(jsonString);
        print("jsondata");
        print(jsondata);
        print("AddService Response: " + jsondata.toString());
        return jsondata;
      } else {
        print("AddService Error");
        print(response.data.toString());
      }
    } catch (e) {
      print("AddService Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteService(data) async {
    String url = APIURL.API_URL + 'DeleteService';
    print("DeleteService URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("DeleteService Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> UpdateService(data) async {
    String url = APIURL.API_URL + 'UpdateService';
    print("UpdateService URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateService Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> MemberSignUp(data) async {
    String url = APIURL.API_URL + 'MemberSignUp';
    print("AddOffer URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> SaveShare(data) async {
    String url = APIURL.API_URL + 'AddShare';
    print("AddShare URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> UpdateProfile(data) async {
    String url = APIURL.API_URL + 'UpdateProfile';
    print("UpdateProfile URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
        return data;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateProfile Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> SaveGallery(data) async {
    String url =
        "http://digitalcard.co.in/DigitalcardService.asmx/" + 'AddGalleryCover';
    print("SaveGallery : " + url);
    try {
      //final response = await dio.get(url);
      final response = await http.post(url, body: data);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass =
            new SaveDataClass1.fromJson(jsonResponse);
        print("savedataclass");
        print(saveDataClass.Data);
        return saveDataClass;
        // SaveDataClass1 saveData =
        // new SaveDataClass1(Message: 'No Data', IsSuccess: false, Data: '0');
        // var responseData = response.body;
        //
        // print("SaveGallery Response: " + responseData.toString());

        // saveData.Message = responseData["Message"].toString();
        // saveData.IsSuccess = responseData["IsSuccess"];
        // saveData.Data = responseData["Data"].toString();
        // return saveData;
      } else {
        print("SaveGallery Error");
        // throw Exception(response.data.toString());
      }
    } catch (e) {
      print("SaveGallery Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List<MemberClass>> GetMemberDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);
    List<MemberClass> list = [];

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL +
          'GetMemberDetail?type=memberdetail&memberid=$memberId';
      print("MemberLogin URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          print("MemberLogin Response: " + response.body);

          final jsonResponse = json.decode(response.body);
          MemberDataClass memberDataClass =
              new MemberDataClass.fromJson(jsonResponse);

          if (memberDataClass.ERROR_STATUS == false)
            list = memberDataClass.Data;
          else
            list = [];

          return list;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("Check Login Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } else
      return list;
  }

  static Future<String> UpdateTheme(String memberid, String themeid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(Session.digital_Id);

    String message = "";

    if (memberId != null && memberId != "") {
      String url = APIURL.API_URL +
          'UpdateTheme?type=updatetheme&memberid=$memberid&themeid=$themeid';
      print("MemberLogin URL: " + url);
      final response = await http.get(url);
      try {
        if (response.statusCode == 200) {
          print("UpdateTheme Response: " + response.body);

          final jsonResponse = json.decode(response.body);
          Updatetheme updateTheme = new Updatetheme.fromJson(jsonResponse);

          if (updateTheme.ERROR_STATUS == false)
            message = "Successfully Inserted!";

          return message;
        } else {
          throw Exception(MESSAGES.INTERNET_ERROR);
        }
      } catch (e) {
        print("Check Login Erorr : " + e.toString());
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } else
      return message;
  }

  static Future<SaveDataClass> CardPayment(data) async {
    String url = APIURL.API_URL + 'MemberPayment';
    print("CardPayment URL: " + url);
    final response = await http.post(url, body: data);
    try {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardPayment Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> CardPaymentWithPackage(data) async {
    String url = APIURL.API_URL + 'MemberPaymentWithPackage';
    print("CardPaymentWithPackage URL: " + url);
    final response = await http.post(url, body: data);
    try {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("payment response :" + jsonResponse.toString());
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardPaymentWithPackage Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  //denish ubhal
  static Future<List<CouponClass>> GetCoupon(String CouponCode) async {
    List<CouponClass> list = [];

    String url =
        APIURL.API_URL + 'getCoupon?type=coupon&couponCode=$CouponCode';
    print("MemberLogin URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        CouponDataClass dashboardCountDataClass =
            new CouponDataClass.fromJson(jsonResponse);

        if (dashboardCountDataClass.ERROR_STATUS == false)
          list = dashboardCountDataClass.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetDashboardCount Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<PackageClass>> GetPackages() async {
    List<PackageClass> list = [];
    String url = APIURL.API_URL + 'GetPackage?type=package';
    print("GetPackages URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        PackageClassData packageClassData =
            new PackageClassData.fromJson(jsonResponse);

        if (packageClassData.ERROR_STATUS == false)
          list = packageClassData.Data;
        else
          list = [];

        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetPackages Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<PaymentOrderIdClass> GetOrderIDForPayment(
      int amount, String receiptNo) async {
    String id = "";
    String url = APIURL.API_URL_RazorPay_Order +
        'GetDigitalCardPaymentOrderID?amount=$amount&receiptNo=$receiptNo';
    print("GetOrderIDForPayment URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        PaymentOrderIdClass paymentOrderIdClass =
            new PaymentOrderIdClass.fromJson(jsonResponse);
        print("Response " + jsonResponse.toString());

        return paymentOrderIdClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetOrderIDForPayment Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<PaymentOrderIdClass> GetOrderId(body) async {
    print(body.toString());
    String url = APIURL.API_URL_RazorPay_Order + 'GetDigitalCardPaymentOrderID';
    print("GetOrderId : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.data);
        print("GetOrderId response =" + jsonResponse.toString());
        PaymentOrderIdClass saveDataClass =
            new PaymentOrderIdClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
