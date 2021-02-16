import 'dart:convert';

class CouponDataClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<CouponClass> Data;

  CouponDataClass(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory CouponDataClass.fromJson(Map<String, dynamic> json) {
    return CouponDataClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<CouponClass>((json) => CouponClass.fromJson(json))
            .toList());
  }
}

class SaveDataClass1 {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;

  SaveDataClass1(
      {this.MESSAGE, this.ORIGINAL_ERROR, this.ERROR_STATUS, this.RECORDS});

  factory SaveDataClass1.fromJson(Map<String, dynamic> json) {
    return SaveDataClass1(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool);
  }
}

class PackageClassData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<PackageClass> Data;

  PackageClassData({
    this.MESSAGE,
    this.ORIGINAL_ERROR,
    this.ERROR_STATUS,
    this.RECORDS,
    this.Data,
  });

  factory PackageClassData.fromJson(Map<String, dynamic> json) {
    return PackageClassData(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<PackageClass>((json) => PackageClass.fromJson(json))
            .toList());
  }
}

class PaymentOrderIdClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  String Data;

  PaymentOrderIdClass(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory PaymentOrderIdClass.fromJson(Map<String, dynamic> json) {
    return PaymentOrderIdClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data'] as String);
  }
}

class PackageClass {
  String id;
  String name, durationYears, amount;

  PackageClass({
    this.id,
    this.name,
    this.durationYears,
    this.amount,
  });

  factory PackageClass.fromJson(Map<String, dynamic> json) {
    return PackageClass(
      id: json["Id"] as String,
      name: json['Name'] as String,
      durationYears: json['DurationYears'] as String,
      amount: json['Amount'] as String,
    );
  }
}

class CouponClass {
  String CouponId;
  String CouponCode;
  String CouponType;
  String CouponAmt;
  String StartDate;
  String EndDate;

  CouponClass({
    this.CouponId,
    this.CouponCode,
    this.CouponType,
    this.CouponAmt,
    this.StartDate,
    this.EndDate,
  });

  factory CouponClass.fromJson(Map<String, dynamic> json) {
    return CouponClass(
      CouponId: json['CouponId'] as String,
      CouponCode: json['CouponCode'] as String,
      CouponType: json['CouponType'] as String,
      CouponAmt: json['CouponAmt'] as String,
      StartDate: json['StartDate'] as String,
      EndDate: json['EndDate'] as String,
    );
  }
}

class ShareClass {
  String Id;
  String Name;
  String MobileNo;
  String Date;

  ShareClass({this.Id, this.Name, this.MobileNo, this.Date});

  factory ShareClass.fromJson(Map<String, dynamic> json) {
    return ShareClass(
        Id: json['Id'] as String,
        Name: json['Name'] as String,
        MobileNo: json['MobileNo'] as String,
        Date: json['Date'] as String);
  }
}

class SaveDataClass {
  String Message;
  bool IsSuccess;
  String Data;

  SaveDataClass({this.Message, this.IsSuccess, this.Data});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data'] as String);
  }
}


class stateClassData {
  String message;
  bool isSuccess;
  List<stateClass> data = [];

  stateClassData({this.message, this.isSuccess, this.data});

  factory stateClassData.fromJson(Map<String, dynamic> json) {
    return stateClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<stateClass>((json) => stateClass.fromJson(json))
            .toList());
  }
}

class stateClass {
  String id;
  String Name;

  stateClass({this.id, this.Name});

  factory stateClass.fromJson(Map<String, dynamic> json) {
    return stateClass(
        id: json['Id'].toString() as String,
        Name: json['Name'].toString() as String);
  }
}

class cityClassData {
  String message;
  bool isSuccess;
  List<cityClass> data = [];

  cityClassData({this.message, this.isSuccess, this.data});

  factory cityClassData.fromJson(Map<String, dynamic> json) {
    return cityClassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<cityClass>((json) => cityClass.fromJson(json))
            .toList());
  }
}

class cityClass {
  String id;
  String StateId;
  String Name;

  cityClass({this.id, this.StateId, this.Name});

  factory cityClass.fromJson(Map<String, dynamic> json) {
    return cityClass(
        id: json['Id'].toString() as String,
        StateId: json['StateId'].toString() as String,
        Name: json['Name'].toString() as String);
  }
}

class MemberDataClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass> Data;

  MemberDataClass(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory MemberDataClass.fromJson(Map<String, dynamic> json) {
    return MemberDataClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass>((json) => MemberClass.fromJson(json))
            .toList());
  }
}

class DashboardCountDataClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<DashboardCountClass> Data;

  DashboardCountDataClass(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory DashboardCountDataClass.fromJson(Map<String, dynamic> json) {
    return DashboardCountDataClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<DashboardCountClass>(
                (json) => DashboardCountClass.fromJson(json))
            .toList());
  }
}

class DashboardCountClass {
  String visitors;
  String share;
  String calls;
  String cardAmount;

  DashboardCountClass({this.visitors, this.share, this.calls, this.cardAmount});

  factory DashboardCountClass.fromJson(Map<String, dynamic> json) {
    return DashboardCountClass(
        visitors: json['visitors'] as String,
        share: json['share'] as String,
        calls: json['calls'] as String,
        cardAmount: json['cardAmount'] as String);
  }
}

class MemberClass {
  String Id;
  String Name;
  String Company;
  String Role;
  String website;
  String About;
  String Image;
  String Mobile;
  String Email;
  String Whatsappno;
  String Facebooklink;
  String CompanyAddress;
  String CompanyPhone;
  String CompanyUrl;
  String CompanyEmail;
  String GMap;
  String Twitter;
  String Google;
  String Linkedin;
  String Youtube;
  String Instagram;
  String CoverImage;
  String MyReferralCode;
  String RegistrationRefCode;
  String JoinDate;
  String ExpDate;
  String MemberType;
  String RegistrationPoints;
  String PersonalPAN;
  String CompanyPAN;
  String GstNo;
  String AboutCompany;
  String ShareMsg;
  bool IsActivePayment;

  MemberClass({
    this.Id,
    this.Name,
    this.Company,
    this.Role,
    this.website,
    this.About,
    this.Image,
    this.Mobile,
    this.Email,
    this.Whatsappno,
    this.Facebooklink,
    this.CompanyAddress,
    this.CompanyPhone,
    this.CompanyUrl,
    this.CompanyEmail,
    this.GMap,
    this.Twitter,
    this.Google,
    this.Linkedin,
    this.Youtube,
    this.Instagram,
    this.CoverImage,
    this.MyReferralCode,
    this.RegistrationRefCode,
    this.JoinDate,
    this.ExpDate,
    this.MemberType,
    this.RegistrationPoints,
    this.PersonalPAN,
    this.CompanyPAN,
    this.GstNo,
    this.AboutCompany,
    this.ShareMsg,
    this.IsActivePayment,
  });

  factory MemberClass.fromJson(Map<String, dynamic> json) {
    return MemberClass(
      Id: json['Id'] as String,
      Name: json['Name'] as String,
      Company: json['Company'] as String,
      Role: json['Role'] as String,
      website: json['website'] as String,
      About: json['About'] as String,
      Image: json['Image'] as String,
      Mobile: json['Mobile'] as String,
      Email: json['Email'] as String,
      Whatsappno: json['Whatsappno'] as String,
      Facebooklink: json['Facebooklink'] as String,
      CompanyAddress: json['CompanyAddress'] as String,
      CompanyPhone: json['CompanyPhone'] as String,
      CompanyUrl: json['CompanyUrl'] as String,
      CompanyEmail: json['CompanyEmail'] as String,
      GMap: json['Map'] as String,
      Twitter: json['Twitter'] as String,
      Google: json['Google'] as String,
      Linkedin: json['Linkedin'] as String,
      Youtube: json['Youtube'] as String,
      Instagram: json['Instagram'] as String,
      CoverImage: json['CoverImage'] as String,
      MyReferralCode: json['MyReferralCode'] as String,
      RegistrationRefCode: json['RegistrationRefCode'] as String,
      JoinDate: json['JoinDate'] as String,
      ExpDate: json['ExpDate'] as String,
      MemberType: json['MemberType'] as String,
      RegistrationPoints: json['RegistrationPoints'] as String,
      PersonalPAN: json['PersonalPAN'] as String,
      CompanyPAN: json['CompanyPAN'] as String,
      GstNo: json['GstNo'] as String,
      AboutCompany: json['AboutCompany'] as String,
      ShareMsg: json['ShareMsg'] as String,
      IsActivePayment: json['IsActivePayment'] as bool,
    );
  }
}

class ShareDataClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<ShareClass> Data;

  ShareDataClass(
      {this.MESSAGE,
        this.ORIGINAL_ERROR,
        this.ERROR_STATUS,
        this.RECORDS,
        this.Data});

  factory ShareDataClass.fromJson(Map<String, dynamic> json) {
    return ShareDataClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<ShareClass>((json) => ShareClass.fromJson(json))
            .toList());
  }
}

class MemberClassData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass> Data;

  MemberClassData({
    this.MESSAGE,
    this.ORIGINAL_ERROR,
    this.ERROR_STATUS,
    this.RECORDS,
    this.Data,
  });

  factory MemberClassData.fromJson(Map<String, dynamic> json) {
    return MemberClassData(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass>((json) => MemberClass.fromJson(json))
            .toList());
  }
}

class MemberClass1 {
  String memberId;
  String memberName;

  MemberClass1({this.memberId, this.memberName});

  factory MemberClass1.fromJson(Map<String, dynamic> json) {
    return MemberClass1(
        memberId: json['groupcode'] as String,
        memberName: json['groupname'] as String);
  }
}

class timeClassData {
  String Message;
  bool IsSuccess;
  List<timeClass> Data;

  timeClassData({
    this.Message,
    this.IsSuccess,
    this.Data,
  });

  factory timeClassData.fromJson(Map<String, dynamic> json) {
    return timeClassData(
        Message: json['Message'] as String,
        IsSuccess: json['IsSuccess'] as bool,
        Data: json['Data']
            .map<timeClass>((json) => timeClass.fromJson(json))
            .toList());
  }
}

class timeClass {
  String id;
  String time;
  String IsBooked;

  timeClass({this.id, this.time, this.IsBooked});

  factory timeClass.fromJson(Map<String, dynamic> json) {
    return timeClass(
      id: json['Id'].toString() as String,
      time: json['Title'].toString() as String,
      IsBooked: json['IsBooked'].toString() as String,
    );
  }
}

class GetBranchclassData {
  String message;
  bool isSuccess;
  List<GetBranchClass> data = [];

  GetBranchclassData({this.message, this.isSuccess, this.data});

  factory GetBranchclassData.fromJson(Map<String, dynamic> json) {
    return GetBranchclassData(
        message: json['Message'] as String,
        isSuccess: json['IsSuccess'] as bool,
        data: json['Data']
            .map<GetBranchClass>((json) => GetBranchClass.fromJson(json))
            .toList());
  }
}

class GetBranchClass {
  String id;
  String Address;

  GetBranchClass({this.id, this.Address});

  factory GetBranchClass.fromJson(Map<String, dynamic> json) {
    return GetBranchClass(
        id: json['Id'].toString() as String,
        Address: json['Address'].toString() as String);
  }
}
