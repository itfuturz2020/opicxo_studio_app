import 'dart:io';
import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/ImagePickerHandlerComponent.dart';
import 'package:opicxo_studio_app/Components/HeaderComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  bool showProfileEdit = false;
  bool showCompanyEdit = false;

  MemberClass memberdata = new MemberClass();

  TextEditingController txtDate = new TextEditingController();

  TextEditingController txtName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController txtAbout = new TextEditingController();
  TextEditingController txtEmail = new TextEditingController();
  TextEditingController txtWebsite = new TextEditingController();
  TextEditingController txtWhatsApp = new TextEditingController();
  TextEditingController txtFaceboook = new TextEditingController();
  TextEditingController txtTwitter = new TextEditingController();
  TextEditingController txtGoogle = new TextEditingController();
  TextEditingController txtLinkedin = new TextEditingController();
  TextEditingController txtYoutube = new TextEditingController();
  TextEditingController txtIntagram = new TextEditingController();
  TextEditingController txtImage = new TextEditingController();
  TextEditingController txtCoverImage = new TextEditingController();

  TextEditingController txtCompany = new TextEditingController();
  TextEditingController txtRole = new TextEditingController();
  TextEditingController txtCompanyUrl = new TextEditingController();
  TextEditingController txtAddress = new TextEditingController();
  TextEditingController txtPhone = new TextEditingController();
  TextEditingController txtCompanyEmail = new TextEditingController();
  TextEditingController txtMap = new TextEditingController();

  DateTime date = new DateTime.now();

  var profileHeight = 510.0;
  var profileHeightMax = 510.0;

  var profileEditHeight = 0.0;
  var profileEditHeightMax = 875.0;

  var companyHeight = 300.0;
  var companyHeightMax = 300.0;

  var companyEditHeight = 0.0;
  var companyEditHeightMax = 580.0;

  @override
  void initState() {
    super.initState();
    GetProfileData();
    txtDate.text = date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GetProfileData() {
    Services.GetMemberDetail().then((data) {
      setState(() {
        memberdata = data[0];
      });
      SetDataToController();
    });
  }

  SetDataToController() {
    //Profile Data
    txtName.text = memberdata.Name;
    txtMobile.text = memberdata.Mobile;
    txtEmail.text = memberdata.Email;
    txtWebsite.text = memberdata.website;
    txtWhatsApp.text = memberdata.Whatsappno;
    txtFaceboook.text = memberdata.Facebooklink;
    txtTwitter.text = memberdata.Twitter;
    txtGoogle.text = memberdata.Google;
    txtLinkedin.text = memberdata.Linkedin;
    txtYoutube.text = memberdata.Youtube;
    txtIntagram.text = memberdata.Instagram;
    txtAbout.text = memberdata.About;

    //Company Data
    txtCompany.text = memberdata.Company;
    txtRole.text = memberdata.Role;
    txtPhone.text = memberdata.CompanyPhone;
    txtCompanyEmail.text = memberdata.CompanyEmail;
    txtCompanyUrl.text = memberdata.CompanyUrl;
    txtAddress.text = memberdata.CompanyAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: <Widget>[
          HeaderComponent(
            title: "Profile",
            image: "images/header/offerheader.jpg",
            boxheight: 100,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(top: 110),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _coverImagePopup(context),
                        child: memberdata.CoverImage != null
                            ? Image.network(memberdata.CoverImage,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover)
                            : Image.asset("images/profilebg.jpg",
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, top: 50),
                        child: GestureDetector(
                          onTap: () => imagePicker.showDialog(context),
                          child: new Center(
                            child: memberdata.Image != null
                                ? ClipOval(
                                    child: Image.network(memberdata.Image,
                                        height: 100.0, width: 100.0,fit: BoxFit.fill),
                                  )
                                : Image.asset(
                                    "images/user.png",
                                    height: 100.0,
                                    width: 100.0,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Profile View
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: profileHeight,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: Colors.grey[600], width: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Profile",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                  onTap: () {
                                    /*setState(() {
                                              showProfileEdit = true;
                                              profileHeight = 0.0;
                                            })*/
                                    profileHeight = 0.0;
                                    profileEditHeight = profileEditHeightMax;
                                    setState(() {});
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/user24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Name != null
                                          ? memberdata.Name
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/telephone24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Mobile != null
                                          ? memberdata.Mobile
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/gmail24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Email != null
                                          ? memberdata.Email
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/domain24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.website != null
                                          ? memberdata.website
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/whatsapp24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Whatsappno != null
                                          ? memberdata.Whatsappno
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/facebook24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Facebooklink != null
                                            ? memberdata.Facebooklink
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/twitter24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Twitter != null
                                            ? memberdata.Twitter
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/googleplus24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Google != null
                                            ? memberdata.Google
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/linkedin24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Linkedin != null
                                            ? memberdata.Linkedin
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/youtube24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Youtube != null
                                            ? memberdata.Youtube
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/social/instagram24.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                        memberdata.Instagram != null
                                            ? memberdata.Instagram
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/negotiation24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: Text(
                                        memberdata.About != null
                                            ? memberdata.About
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Edit Profile
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: profileEditHeight,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: Colors.grey[600], width: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Edit Profile",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                  onTap: () {
                                    /*setState(() {
                                                showProfileEdit = false;
                                                profileHeight = 200.0;
                                              });*/
                                    profileHeight = profileHeightMax;
                                    profileEditHeight = 0.0;
                                    setState(() {});
                                  },
                                  child: Icon(Icons.done_outline))
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtName,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Image.asset("images/profile/user24.png"),
                                  hintText: "Name"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtMobile,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/profile/telephone24.png"),
                                  hintText: "Mobile"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtEmail,
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Image.asset("images/profile/gmail24.png"),
                                  hintText: "Email"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtWebsite,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/profile/domain24.png"),
                                  hintText: "website"),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtWhatsApp,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/whatsapp24.png"),
                                  hintText: "Whatsapp No"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtFaceboook,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/facebook24.png"),
                                  hintText: "Facebook"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtTwitter,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/twitter24.png"),
                                  hintText: "Twitter"),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtGoogle,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/googleplus24.png"),
                                  hintText: "Google"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtLinkedin,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/linkedin24.png"),
                                  hintText: "Linkedin"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtYoutube,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/youtube24.png"),
                                  hintText: "Youtube"),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtIntagram,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/social/instagram24.png"),
                                  hintText: "Instagram"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                                border: new Border.all(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: txtAbout,
                              maxLines: 3,
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                      "images/profile/negotiation24.png"),
                                  hintText: "About"),
                              keyboardType: TextInputType.text,
                              style: TextStyle(color: Colors.black),
                            ),
                            //height: 40,
                            width: MediaQuery.of(context).size.width - 60,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Company View
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: companyHeight,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10, bottom: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: Colors.grey[600], width: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("Company",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                  onTap: () {
                                    companyHeight = 0.0;
                                    companyEditHeight = companyEditHeightMax;
                                    setState(() {});
                                  },
                                  child: Icon(Icons.edit))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/office24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Company != null
                                          ? memberdata.Company
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/role24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.Role != null
                                          ? memberdata.Role
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                    "images/profile/telephoneold24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.CompanyPhone != null
                                          ? memberdata.CompanyPhone
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/gmail24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                      memberdata.CompanyEmail != null
                                          ? memberdata.CompanyEmail
                                          : "",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/domain24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: Text(
                                        memberdata.CompanyUrl != null
                                            ? memberdata.CompanyUrl
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("images/profile/google24.png"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 90,
                                    child: Text(
                                        memberdata.CompanyAddress != null
                                            ? memberdata.CompanyAddress
                                            : "",
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Edit Company
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: companyEditHeight,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: Colors.grey[600], width: 0.5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Edit Company",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            GestureDetector(
                                onTap: () {
                                  companyHeight = companyHeightMax;
                                  companyEditHeight = 0.0;
                                  setState(() {});
                                },
                                child: Icon(Icons.done_outline))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtCompany,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset("images/profile/office24.png"),
                                hintText: "Company Name"),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtRole,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset("images/profile/role24.png"),
                                hintText: "Role"),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtPhone,
                            decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                    "images/profile/telephoneold24.png"),
                                hintText: "Phone"),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtCompanyEmail,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset("images/profile/gmail24.png"),
                                hintText: "Gmail"),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtCompanyUrl,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset("images/profile/domain24.png"),
                                hintText: "Website"),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtMap,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Image.asset("images/profile/google24.png"),
                                hintText: "Google Map"),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtAddress,
                            maxLines: 3,
                            decoration: InputDecoration(
                                prefixIcon: Image.asset(
                                    "images/profile/placeholder24.png"),
                                hintText: "Address"),
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

void _coverImagePopup(context){
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.camera_alt),
                  title: new Text('Camera'),
                  onTap: () => {}
              ),
              new ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Gallery'),
                onTap: () => {},
              ),
            ],
          ),
        );
      }
  );
}
