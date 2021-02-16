import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberSelection extends StatefulWidget {
  final List memberList;

  const MemberSelection({Key key, this.memberList}) : super(key: key);

  @override
  _MemberSelectionState createState() => _MemberSelectionState();
}

class _MemberSelectionState extends State<MemberSelection> {
  setSelectedMember(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(cnst.Session.MemberId, widget.memberList[index].Id);
    await prefs.setString(cnst.Session.Name, widget.memberList[index].Name);
    await prefs.setString(cnst.Session.Mobile, widget.memberList[index].Mobile);
    await prefs.setString(cnst.Session.Email, widget.memberList[index].Email);
    await prefs.setString(
        cnst.Session.Company, widget.memberList[index].Company);
    await prefs.setString(
        cnst.Session.ReferCode, widget.memberList[index].MyReferralCode);
    await prefs.setBool(
        cnst.Session.IsActivePayment, widget.memberList[index].IsActivePayment);
    Navigator.pushReplacementNamed(context, "/Dashboard1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                "Pick One Company",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.memberList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setSelectedMember(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                        height: 4,
                                        color: index % 2 == 0
                                            ? cnst.appMaterialColor
                                            : cnst.buttoncolor),
                                    Container(
                                      height: 90,
                                      margin:
                                          EdgeInsets.only(left: 20, right: 80),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              "${widget.memberList[index].Company}",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: index % 2 == 0
                                                      ? cnst.appMaterialColor
                                                      : cnst.buttoncolor)),
                                          Text(
                                              "${widget.memberList[index].Email}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: index % 2 == 0
                                                      ? cnst.appMaterialColor
                                                      : cnst.buttoncolor)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 0,
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0)),
                                  color: index % 2 == 0
                                      ? cnst.appMaterialColor
                                      : cnst.buttoncolor,
                                  onPressed: () {
                                    setSelectedMember(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Select",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                  /*return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () {
                          setSelectedMember(index);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 35),
                          color: cnst.appMaterialColor,
                          child: Center(
                            child: Text(
                              "${widget.memberList[index].Company}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
