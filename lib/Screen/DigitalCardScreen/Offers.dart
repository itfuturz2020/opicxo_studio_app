import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/HeaderComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/LoadinComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/NoDataComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/OfferComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;


class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () => Navigator.pushNamed(context, "/AddOffer"),
          child: Icon(Icons.add,
          color: Colors.white,
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              HeaderComponent(
                title: "Offers",
                image: "images/header/offerheader.jpg",
                boxheight: 150,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 160,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 100),
                child: FutureBuilder<List<OfferClass>>(
                  future: Services.GetMemberOffers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? snapshot.hasData
                            ? ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return OfferComponent(snapshot.data[index]);
                                },
                              )
                            : NoDataComponent()
                        : LoadinComponent();
                  },
                ),
              )
            ],
          ),
        ));
  }
}
