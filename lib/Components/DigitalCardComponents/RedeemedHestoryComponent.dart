import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;

class RedeemedHestoryComponent extends StatelessWidget {

  final RedeemHistoryClass redeemHistoryClass;
  const RedeemedHestoryComponent(this.redeemHistoryClass);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(redeemHistoryClass.Title,style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w600,color: cnst.appcolor)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("${redeemHistoryClass.Points} Points | ${redeemHistoryClass.Date} | ${redeemHistoryClass.OrderNo}",
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey[600])),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
