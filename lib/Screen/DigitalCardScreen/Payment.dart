import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String MemberId = "";
  String Name = "";
  String Mobile = "";
  String Email = "";
  String Amount = "";
  String OriginalAmount = "";
  String AmountCopy = "";
  String packageId = "";

  //String Amount = "99900";
  String PaymentStatus = "InProcess";
  String PaymentMessage = "";
  bool isLoading = false;
  var couponStatus = false;
  CouponClass couponclass;

  List<PackageClass> packageData = [];
  PackageClass _packageClass;

  TextEditingController edtCouponCode = new TextEditingController();

  Map paymentResponse;
  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetLocalData();
    _getPackageData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(cnst.Session.MemberId);
    String name = prefs.getString(cnst.Session.Name);
    String mobile = prefs.getString(cnst.Session.Mobile);
    String email = prefs.getString(cnst.Session.Email);
    String cardPaymentAmount = prefs.getString(cnst.Session.CardPaymentAmount);

    if (cardPaymentAmount != null && cardPaymentAmount != "") {
      OriginalAmount = cardPaymentAmount + "00";
      Amount = cardPaymentAmount + "00";
      AmountCopy = cardPaymentAmount;
    } else {
      OriginalAmount = "99900";
      Amount = "99900";
      AmountCopy = "999";
    }

    if (memberId != null && memberId != "")
      setState(() {
        MemberId = memberId;
      });
    if (name != null && name != "")
      setState(() {
        Name = name;
      });
    if (mobile != null && mobile != "")
      setState(() {
        Mobile = mobile;
      });
    if (email != null && email != "")
      setState(() {
        Email = email;
      });
  }

  _getPackageData() async {
    Future res = Services.GetPackages();
    res.then((data) async {
      if (data != null && data.length > 0) {
        setState(() {
          isLoading = false;
          packageData = data;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          textColor: Colors.white,
          msg: "Something went Wrong",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP);
    });
  }


  startPayment() async {
    Services.GetOrderIDForPayment(int.parse(Amount), 'ORD1001').then(
        (data) async {
      if (data != null && data.ERROR_STATUS == false) {
        print("order Id---> ${data.Data}");
        var options = {
          'image': 'https://kavitabatras.com/Resources/logo.png',
          'key': 'rzp_live_pU4motxSsKfdW3',
          'order_id': data.Data,
          'amount': Amount,
          'name': 'Digital Card',
          'description': 'Buy Digital Card Online',
          'prefill': {'contact': Mobile, 'email': Email},
        };
        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Payment Gateway Not Open" + data.ORIGINAL_ERROR,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
      }
    }, onError: (e) {
      Fluttertoast.showToast(
          msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("sucess:" + response.toString());
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId,
        timeInSecForIos: 4,
        backgroundColor: cnst.appMaterialColor);
    cardPayment(response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("error::: ${response.message}");
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4,
        backgroundColor: cnst.appMaterialColor);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        timeInSecForIos: 4,
        backgroundColor: cnst.appMaterialColor);
  }

  /*startPayment() async {
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Razorpay T-Shirt");
    options.putIfAbsent("image", () => "https://www.73lines.com/web/image/12427");
    options.putIfAbsent("description", () => "This is a real transaction");
    options.putIfAbsent("amount", () => "100");
    options.putIfAbsent("email", () => "test@testing.com");
    options.putIfAbsent("contact", () => "9988776655");
    //Must be a valid HTML color.
    options.putIfAbsent("theme", () => "#FF0000");
    //Notes -- OPTIONAL
    Map<String, String> notes = new Map();
    notes.putIfAbsent('key', () => "value");
    notes.putIfAbsent('randomInfo', () => "haha");
    options.putIfAbsent("notes", () => notes);
    options.putIfAbsent("api_key", () => "rzp_live_ud7vCnNUUZNr9F");
    Map<dynamic,dynamic> paymentResponse = new Map();
    paymentResponse = await Razorpay.showPaymentForm(options);
    print("response $paymentResponse");

  }*/

  cardPayment(PaymentMessage) {
    setState(() {
      isLoading = true;
    });
    var data = {
      'type': 'payment',
      'points': '0',
      'orderno': PaymentMessage,
      'memberid': MemberId,
      'paymenttype': 'Online',
      'amount': (int.parse(Amount) / 100).toString(),
      'packageid': packageId
    };
    print(data);
    Services.CardPaymentWithPackage(data).then((data) {
      if (data != null && data.ERROR_STATUS == false) {
        Fluttertoast.showToast(
            msg: "Payment Saved",
            backgroundColor: Colors.green,
            gravity: ToastGravity.TOP);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacementNamed(context, '/Dashboard1');
      } else {
        Fluttertoast.showToast(
            msg: "Data Not Saved " + data.MESSAGE,
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            toastLength: Toast.LENGTH_LONG);
        setState(() {
          isLoading = false;
        });
      }
    }, onError: (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
    });
  }

  checkCoupon() async {
    if (edtCouponCode.text != "") {
      setState(() {
        isLoading = true;
      });
      Services.GetCoupon(edtCouponCode.text).then((val) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //couponclass = new CouponClass();
        if (val != null && val.length > 0) {
          couponclass = val[0];
          setAmountCalculation();
        }
        setState(() {
          couponStatus = true;
          isLoading = false;
        });
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: "Enter Coupon Code", backgroundColor: Colors.red);
    }
  }

  setAmountCalculation() async {
    int decimals = 0;
    int fac = pow(10, decimals);
    String couponType = couponclass.CouponType;
    double couponAmt = double.parse(couponclass.CouponAmt);
    double amt = double.parse(AmountCopy);
    if (couponType.toLowerCase() == "fixed") {
      amt = amt - couponAmt;
      setState(() {
        amt = (amt * fac).round() / fac;
        Amount = (amt * 100).toStringAsFixed(0);
      });
    } else {
      amt = (amt * fac).round() / fac;
      double calculateAmt = (amt * couponAmt) / 100;
      double amt1 = amt - calculateAmt;
      amt1 = (amt1 * fac).round() / fac;
      setState(() {
        Amount = (amt1 * 100).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Card Payment',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              PaymentStatus == 'InProcess'
                  ? Card(
                      margin: EdgeInsets.all(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Buy Digital Card',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600)),
                            Divider(),
                            packageData != null && packageData.length >= 0
                                ? SizedBox(
                                    child: InputDecorator(
                                        decoration: new InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          //labelText: "",
                                          fillColor: Colors.white,
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(5.0),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<PackageClass>(
                                            //isDense: true,
                                            hint: new Text("Select Package"),
                                            value: _packageClass,
                                            onChanged: (val) {
                                              setState(() {
                                                _packageClass = val;
                                                packageId = val.id;
                                                OriginalAmount =
                                                    val.amount + "00";
                                                Amount = val.amount + "00";
                                                AmountCopy = val.amount;
                                              });
                                            },
                                            items: packageData
                                                .map((PackageClass package) {
                                              return new DropdownMenuItem<
                                                  PackageClass>(
                                                value: package,
                                                child: new Text(
                                                  package.name,
                                                  style: new TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                    width: (MediaQuery.of(context).size.width -
                                        40),
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: _packageClass != null
                                  ? Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                                width: 90,
                                                child: Text('Name',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade600))),
                                            Text('$Name',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.grey.shade600)),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  width: 90,
                                                  child: Text('Mobile',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600))),
                                              Text('$Mobile',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors
                                                          .grey.shade600)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  width: 90,
                                                  child: Text('Email',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600))),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      170,
                                                  child: Text('$Email',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600))),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  width: 90,
                                                  child: Text('Amount',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .grey.shade600))),
                                              Text(
                                                  '${double.parse(OriginalAmount) / 100}',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors
                                                          .grey.shade600)),
                                            ],
                                          ),
                                        ),
                                        couponclass != null &&
                                                couponStatus == true
                                            ? Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 20),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: <Widget>[
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    '${couponclass.CouponCode}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600)),
                                                                Text("Applied",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        color: Colors
                                                                            .grey)),
                                                              ],
                                                            )),
                                                        Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.5,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: <
                                                                  Widget>[
                                                                couponclass.CouponType
                                                                            .toLowerCase() !=
                                                                        "fixed"
                                                                    ? Text(
                                                                        '${couponclass.CouponAmt}%',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            color: Colors
                                                                                .grey.shade600))
                                                                    : Text(
                                                                        '${cnst.Inr_Rupee} ${couponclass.CouponAmt}',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: Colors.grey.shade600)),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.4,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                child: TextFormField(
                                                  controller: edtCouponCode,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter Coupon Code',
                                                      labelText:
                                                          'Enter Coupon Code',
                                                      suffixStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .green)),
                                                ),
                                              ),
                                            ),
                                            MaterialButton(
                                                color: cnst.appMaterialColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text('Check\nCoupon',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                                ),
                                                //padding: EdgeInsets.only(t),
                                                onPressed: () {
                                                  //startPayment();
                                                  checkCoupon();
                                                }),
                                          ],
                                        ),
                                        couponclass == null &&
                                                couponStatus == true
                                            ? Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    'Wrong Coupon Code',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Padding(
                                            padding: EdgeInsets.only(top: 15)),
                                        Text(
                                          'Amount Payable :  ${double.parse(Amount) / 100}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade600),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 15)),
                                        MaterialButton(
                                            minWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                80,
                                            color: Colors.green,
                                            child: Text('Pay Now',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            padding: EdgeInsets.all(10),
                                            onPressed: () {
                                              startPayment();
                                            })
                                      ],
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                    )
                  : PaymentStatus == 'Success'
                      ? Card(
                          margin: EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  'https://cdn4.iconfinder.com/data/icons/generic-interaction/143/yes-tick-success-done-complete-check-allow-512.png',
                                  height: 100,
                                  width: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text('OrderID : $PaymentMessage',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Text('Payment Done Successfully',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600)),
                                ),
                                MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 80,
                                  color: Colors.green,
                                  child: Text('Go Back To Home',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  padding: EdgeInsets.all(10),
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/Dashboard1'),
                                )
                              ],
                            ),
                          ),
                        )
                      : Card(
                          margin: EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.network(
                                  'https://www.safetysign.com/images/source/large-images/J6520.png',
                                  height: 100,
                                  width: 100,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text('$PaymentMessage',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Text(
                                      'Payment Faild \nTry After Some Time',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade600)),
                                ),
                                MaterialButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 80,
                                  color: Colors.green,
                                  child: Text('Go Back To Home',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                  padding: EdgeInsets.all(10),
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, '/Dashboard1'),
                                )
                              ],
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
