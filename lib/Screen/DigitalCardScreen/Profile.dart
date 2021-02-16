import 'package:flutter/material.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            ClipPath(
              child: Image.asset(
                "images/profilebg.jpg",
                height: 300,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              clipper: MyClipper(),
            ),
            Container(
              padding: EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 210),
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Container(
                      child: Image.asset("images/users.png",
                          height: 100, width: 100),
                    ),
                  ),
                  Center(
                    child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Akta Siddhpura",
                            style: TextStyle(fontSize: 20,color: Colors.grey[800],fontWeight: FontWeight.w600))),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: Text("Scoie Insurance And Advisory Services Llp - Telly Marketing Executive",
                          style: TextStyle(fontSize: 15,color: Colors.grey[600],fontWeight: FontWeight.w600))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset("images/profile_big.png",width: 60,fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Profile",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          width: 5,
                          height: 50,
                          decoration: BoxDecoration(
                              color: cnst.buttoncolor,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Image.asset("images/offers_big.png",width: 60,fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Offers",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          width: 5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: cnst.buttoncolor,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Image.asset("images/service_big.png",width: 60,fit: BoxFit.fill),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Services",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: ExpansionTile(
                        title: Text("About",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey[700])),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            width: MediaQuery.of(context).size.width - 40,
                            child: Text("She is working with Scoie insurance since aug 2018 as Telly marketing executive. She is hard working and honest.",
                                style: TextStyle(fontSize: 15,color: Colors.grey[700])),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: ExpansionTile(
                        title: Text("Company Profile",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey[700])),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text("COMPANY NAME",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Scoie Insurance And Advisory Services Llp - Telly Marketing Executive",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Phone",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("9034567890",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Email",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("company@gmail.com",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("WEBSITE",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("http://digitalcard.co.in",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("ADDRESS",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("216, sns arista, opp. happy residency, near prime shoppers, vesu, surat",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.all(0),
                      child: ExpansionTile(
                        title: Text("Contact Details",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.grey[700])),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            width: MediaQuery.of(context).size.width - 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Text("PHONE",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("9033608708",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("EMAIL",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("aktasiddhpura@scoie.com",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("ADDRESS",
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[700]))),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("216, sns arista, opp. happy residency, near prime shoppers, vesu, surat",
                                        style: TextStyle(fontSize: 15,color: Colors.grey[700]))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.6, size.height);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}