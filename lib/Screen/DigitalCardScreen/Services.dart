import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/HeaderComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/LoadinComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/NoDataComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/ServiceComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;

class MemberServices extends StatefulWidget {
  @override
  _MemberServicesState createState() => _MemberServicesState();
}

class _MemberServicesState extends State<MemberServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () => Navigator.pushNamed(context, "/AddService"),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              HeaderComponent(
                title: "Services",
                image: "images/header/servicehearde.jpg",
                boxheight: 150,
              ),
              Container(
                  height: MediaQuery.of(context).size.height - 160,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 100),
                  child: FutureBuilder<List>(
                    future: Services.GetMemberServices(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.hasData
                              ? ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print("============================");
                                    print(snapshot.data);
                                    return ServiceComponent(
                                        snapshot.data[index]);
                                  },
                                )
                              : NoDataComponent()
                          : LoadinComponent();
                    },
                  ))
            ],
          ),
        ));
  }
}
