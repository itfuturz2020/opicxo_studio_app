import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;

class ReferralCode extends StatefulWidget {
  @override
  _ReferralCodeState createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                "images/congo.png",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.7,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Card(
                    elevation:10,
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 19.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: Text(
                            "We Are So delighted",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800,color: cnst.appPrimaryMaterialColorPink),
                          ),
                        ),
                        Text(
                          "you're here!",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800,color: cnst.appPrimaryMaterialColorPink),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                              child: Image.asset(
                            "images/giftbox.png",
                            height: 100,
                            width: 100,
                          )),
                        ),
                        Text(
                          "Collect Your Gift",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400,color: cnst.appPrimaryMaterialColorPink),
                        ),
                        Text(
                          "On Entering Invite Code",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400,color: cnst.appPrimaryMaterialColorPink),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Text(
                            "Enter Referral Code",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: MediaQuery.of(context).size.width / 3,
                          child: TextFormField(),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: MediaQuery.of(context).size.width / 9,
                          width: MediaQuery.of(context).size.width / 2.6,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    cnst.appPrimaryMaterialColorYellow,
                                    cnst.appPrimaryMaterialColorPink
                                  ])),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(9.0)),
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Dashboard1', (Route<dynamic> route) => false);
                            },
                            child: Text(
                              "REDEEM NOW!",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Dashboard1', (Route<dynamic> route) => false);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                  color: cnst.appPrimaryMaterialColorPink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),

                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
