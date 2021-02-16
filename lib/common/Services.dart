import 'dart:convert';
import 'dart:io';

import 'package:opicxo_studio_app/common/Constants.dart' as cnst;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'ClassList.dart';
import 'Constants.dart';
import 'package:http/http.dart' as http;

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {

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

  static Future<SaveDataClass1> CardPaymentWithPackage(data) async {
    String url = APIURL.API_URL + 'MemberPaymentWithPackage';
    print("CardPaymentWithPackage URL: " + url);
    final response = await http.post(url, body: data);
    try {
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("payment response :"+jsonResponse.toString());
        SaveDataClass1 saveDataClass1 = new SaveDataClass1.fromJson(jsonResponse);
        return saveDataClass1;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CardPaymentWithPackage Erorr : " + e.toString());
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

  static Future<List<ShareClass>> GetShareHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.CustomerId);

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
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("SaveTA Erorr : " + e.toString());
      throw Exception("No Internet Connection");
    }
  }

  static Future<List<DashboardCountClass>> GetDashboardCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.CustomerId);

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

  static Future<SaveDataClass1> UpdateProfile(data) async {
    String url = APIURL.API_URL + 'UpdateProfile';
    print("UpdateProfile URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        SaveDataClass1 data;
        final jsonResponse = json.decode(response.body);
        SaveDataClass1 saveDataClass1 = new SaveDataClass1.fromJson(jsonResponse);
        return saveDataClass1;
        return data;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateProfile Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass1> uploadBrochure(body) async {
    print(body.toString());
    String url = APIURL.API_URL + 'UpdateBrochure';
    print("UpdateBrochure : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.data);
        print("UpdateBrochure response =" + jsonResponse.toString());
        SaveDataClass1 saveDataClass1 = new SaveDataClass1.fromJson(jsonResponse);
        return saveDataClass1;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List<MemberClass>> GetMemberDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.CustomerId);

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

  static Future<SaveDataClass> SavePhotographer(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'SavePhotographer';
    print("SavePhotographer : " + url);

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);
        //var responseData = response.data;
        print("SavePhotographer Response: " + responseData.toString());
        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();
        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> PhotographerLogin(String mobileNo,String username,String password) async {
    String url = cnst.API_URL + 'PhotographerLogin?mobileNo=$mobileNo&Username=$username&Password=$password';
    print("PhotographerLogin URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("PhotographerLogin Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("PhotographerLogin Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> SendVerificationCode(
      String mobileNo, String code) async {
    String url =
        cnst.API_URL + 'SendVerificationCode?mobileNo=$mobileNo&Code=$code';
    print("SendVerificationCode URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = response.data;

        print("SendVerificationCode Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("SendVerificationCode Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> PhotographerOTPVerification(
      String photographerId) async {
    String url = cnst.API_URL +
        'PhotographerOTPVerification?photographerId=$photographerId';
    print("PhotographerOTPVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = response.data;

        print(
            "PhotographerOTPVerification Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("PhotographerOTPVerification Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdatePhotgrapherData(
      String photographerId, String name, String mobile, String userName,String password,String Bio) async {
    String url = API_URL +
        'UpdatePhotgrapherData?photographerId=$photographerId&name=$name&mobile=$mobile&userName=$userName&password=$password';
    print(" UpdatePhotgrapherData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("UpdatePhotgrapherData Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error UpdatePhotgrapherData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UpdatePhotgrapherData URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<SaveDataClass> SaveCustomer(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomer';
    print("SaveCustomer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("SaveCustomer Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error SaveCustomer");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveCustomer ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<Map> ScanOfferQRCode(String offerid, String customerid,String studioid) async {
    String url = API_URL + 'ScanOfferQRCode?offerid=$offerid&customerid=$customerid&studioid=$studioid';
    print("ScanOfferQRCode url : " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        Map list;
        print("ScanOfferQRCode Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = {};
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Error ScanOfferQRCode ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetCustomerList(
      String studioId ) async {
    String url = cnst.API_URL +
        'GetCustomerList?studioId=$studioId';
    print("GetCustomerList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetCustomerList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetContest() async {
    String url = cnst.API_URL + 'GetContest';
    print("GetContest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetContest Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetContest Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetContestWinner(String contestId) async {
    String url = cnst.API_URL + 'GetContestWinner?contestId=$contestId';
    print("GetContestWinner URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetContestWinner Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetContestWinner Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<Map> GetRefearlAndEarnCodeById(String studioId) async {
    String url = cnst.API_URL +
        'StudioReferral?studioid=${studioId}';
    print("GetRefearlAndEarnCodeById URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        Map list;
        print(
            "GetRefearlAndEarnCodeById Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list;
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetRefearlAndEarnCodeById Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetAddressBranch(String studioId) async {
    String url = cnst.API_URL + 'GetAddressBranch?studioId=$studioId';
    print("GetAddressBranch URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAddressBranch Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAddressBranch Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> DeleteAddressBranch(String id) async {
    String url = API_URL + 'DeleteAddressBranch?id=$id';
    print(" DeleteAddressBranch URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("DeleteAddressBranch Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error DeleteAddressBranch");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("DeleteAddressBranch URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  static Future<List<stateClass>> GetStates() async {
    String url = cnst.API_URL + "GetStates";
    print("GetStates url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<stateClass> list = [];
        print("GetStates Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          stateClassData stateclassdata =
              new stateClassData.fromJson(jsonResponse);

          list = stateclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetStates error" + e);
      throw Exception(e);
    }
  }

  static Future<List<cityClass>> GetCity(String stateId) async {
    String url = cnst.API_URL + "GetCity?StateId=$stateId";
    print("GetCity url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<cityClass> list = [];
        print("GetCity Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          cityClassData cityclassdata =
              new cityClassData.fromJson(jsonResponse);
          list = cityclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetCity error" + e);
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdatePhotographerPhoto(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'UpdatePhotographerPhoto';
    print("UpdatePhotographerPhoto : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("UpdatePhotographerPhoto Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess = responseData["ResultData"]["IsSuccess"] == "true";
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetCustomerGalleryList(
      String customerId, String studioId) async {
    String url = cnst.API_URL +
        'GetCustomerGalleryList?customerId=$customerId&studioId=$studioId';
    print("GetCustomerGalleryList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetCustomerGalleryList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetCustomerGalleryList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetOfferRedeem(String studioid) async {
    String url = cnst.API_URL +
        'GetOfferRedeem?studioid=$studioid';
    print("GetOfferRedeem URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetOfferRedeem Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetCustomerGalleryList Erorr : " + e.toString());
      throw Exception(e);
    }
  }


  static Future<Map<String,dynamic>> SaveGallery(body, {String name}) async {
    String url="";
    if(name!="")
     url = cnst.API_URL + '${name}';
    else
       url = cnst.API_URL + 'SaveGallery';

    print("SaveGallery : " + url);
    try {
      final response = await dio.post(url,data: body);
      if (response.statusCode == 200) {
        var responseData = response.data;
        var xmlString = responseData.toString();
        final Xml2Json xml2Json = Xml2Json();
        xml2Json.parse(xmlString);
        var jsonString = xml2Json.toParker();
        var jsondata = jsonDecode(jsonString);
        print("jsondata");
        print(jsondata);
        print("SaveGallery Response: " + jsondata.toString());
        return jsondata;
      } else {
        print("SaveGallery Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("SaveGallery Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<Map<String,dynamic>> AddOffer(body) async {
    String url="";
      url = cnst.API_URL + 'AddOffer';
    print("AddOffer : " + url);
    try {
      final response = await dio.post(url,data: body);
      if (response.statusCode == 200) {
        var responseData = response.data;
        var xmlString = responseData.toString();
        final Xml2Json xml2Json = Xml2Json();
        xml2Json.parse(xmlString);
        var jsonString = xml2Json.toParker();
        var jsondata = jsonDecode(jsonString);
        print("jsondata");
        print(jsondata);
        print("AddOffer Response: " + jsondata.toString());
        return jsondata;
      } else {
        print("AddOffer Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("AddOffer Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }


  static Future<List> GetAlbumList(String GalleryId) async {
    String url = cnst.API_URL + 'GetAlbumList?GalleryId=$GalleryId';
    print("GetAlbumList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetAlbumList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetAlbumList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> SaveAddressBranch(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'SaveAddressBranch';
    print("SaveAddressBranch : " + url);

    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        var responseData = response.data;

        print("SaveAddressBranch Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SaveCustomerAlbum(body) async {
    print(body.toString());
    String url = API_URL + 'SaveCustomerAlbum';
    print("SaveCustomerAlbum url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("SaveCustomerAlbum Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error SaveCustomerAlbum");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveCustomerAlbum ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetSelectedAlbumPhotoList(String AlbumId) async {
    String url = cnst.API_URL + 'GetSelectedAlbumPhotoList?AlbumId=$AlbumId';
    print("GetSelectedAlbumPhotoList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print(
            "GetSelectedAlbumPhotoList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetSelectedAlbumPhotoList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetPhotographerNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String Id = prefs.getString(Session.Id);

    String url = API_URL + 'GetPhotographerNotificationList?photographerId=$Id';
    print("GetPhotographerNotificationList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetPhotographerNotificationList: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
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

  static Future<List> GetTermsAndCondition() async {
    String url = cnst.API_URL + 'GetTermsAndCondition';
    print("GetTermsAndCondition URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetTermsAndCondition Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetTermsAndCondition Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<String> CheckDigitalCardMember(String mobileNo,String name,String email) async {
    String url = cnst.APIURL.API_URL + 'CheckDigitalCardMember?mobileNo=$mobileNo&name=$name&email=$email';
    print("CheckDigitalCardMember URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String list = "";
        print("CheckDigitalCardMember Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["MESSAGE"] == "Successfully !") {
          list = responseData["Data"][0]["Id"];
        } else {
          list = "";
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("CheckDigitalCardMember Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetBannerList() async {
    String url = cnst.API_URL + 'GetBannerList';
    print("GetBannerList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBannerList Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetBannerList Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateAddressBranch(
      String Id,
      String StudioId,
      String StudioName,
      String Mobile,
      String AlternateMobile,
      String Email,
      String StateId,
      String CityId,
      String Address,
      String LatLong,
      String Pincode) async {
    String url = API_URL +
        'UpdateAddressBranch?Id=$Id&StudioId=$StudioId&StudioName=$StudioName&Mobile=$Mobile&AlternateMobile=$AlternateMobile&Email=$Email&StateId=$StateId&CityId=$CityId&Address=$Address&LatLong=$LatLong&Pincode=$Pincode';
    print(" UpdateAddressBranch URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "0");
        print("UpdateAddressBranch Response: " + response.data.toString());
        var memberDataClass = response.data;
        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error UpdateAddressBranch");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("UpdateAddressBranch URL : " + e.toString());
      throw Exception("something went wrong");
    }
  }

  /*static Future<SaveDataClass> UpdateAddressBranch(body) async {
    print(body.toString());
    String url = cnst.API_URL + 'UpdateAddressBranch';
    print("UpdateAddressBranch : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = response.data;

        print("UpdateAddressBranch Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }*/

  static Future<List<GetBranchClass>> GetBranch(String studioName) async {
    String url = cnst.API_URL + "GetBranch?studioName=$studioName";
    print("GetBranch url = " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<GetBranchClass> list = [];
        print("GetBranch Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          final jsonResponse = response.data;
          GetBranchclassData stateclassdata =
              new GetBranchclassData.fromJson(jsonResponse);

          list = stateclassdata.data;

          return list;
        }
      }
    } catch (e) {
      print("GetBranch error" + e);
      throw Exception(e);
    }
  }
}
