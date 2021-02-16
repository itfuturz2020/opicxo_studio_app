import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/LoadinComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/NoDataComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/RedeemedHestoryComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;


class RedeemHisory extends StatefulWidget {
  @override
  _RedeemHisoryState createState() => _RedeemHisoryState();
}

class _RedeemHisoryState extends State<RedeemHisory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Redeemed History'),
        ),
        body:  Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          child: FutureBuilder<List<RedeemHistoryClass>>(
            future: Services.GetRedemHistory(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? snapshot.hasData
                  ? ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return RedeemedHestoryComponent(snapshot.data[index]);
                },
              )
                  : NoDataComponent()
                  : LoadinComponent();
            },
          ),
        )
    );
  }
}