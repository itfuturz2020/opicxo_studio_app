import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/EarnComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/LoadinComponent.dart';
import 'package:opicxo_studio_app/Components/DigitalCardComponents/NoDataComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;


class EarnHistory extends StatefulWidget {
  @override
  _EarnHistoryState createState() => _EarnHistoryState();
}

class _EarnHistoryState extends State<EarnHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earn History'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<EarnHistoryClass>>(
          future: Services.GetEarnHistory(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EarnComponent(snapshot.data[index]);
                        },
                      )
                    : NoDataComponent()
                : LoadinComponent();
          },
        ),
      ),
    );
  }
}
