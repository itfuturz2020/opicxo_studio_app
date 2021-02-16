import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;

class EarnComponent extends StatelessWidget {
  final EarnHistoryClass earnHistoryClass;

  const EarnComponent(this.earnHistoryClass);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        width: MediaQuery.of(context).size.width - 20,
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/user.png',
                    image: earnHistoryClass.Image,
                    height: 65,
                    width: 65,
                    fit: BoxFit.cover,
                  ),
                )
                /*(earnHistoryClass.Image != null && earnHistoryClass.Image != "") ? FadeInImage.assetNetwork(
                placeholder: 'images/user.png',
                image: earnHistoryClass.Image,
                height: 50, width: 50, fit: BoxFit.contain,
              ) : Image.asset("images/user.png",width: 50,height: 50,),*/
                ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(earnHistoryClass.Name,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cnst.appcolor)),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                      "${earnHistoryClass.RegistrationPoints} Points | ${earnHistoryClass.JoinDate}",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
