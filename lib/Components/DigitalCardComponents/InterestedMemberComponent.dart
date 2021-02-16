import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:url_launcher/url_launcher.dart';

class InterestedMemberComponent extends StatelessWidget {
  final OfferInterestedClass offerInterestedClass;
  const InterestedMemberComponent(this.offerInterestedClass);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5,color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Image.asset("images/user.png",
                width: 50,height: 50,),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(offerInterestedClass.Name,
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: cnst.appcolor)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(offerInterestedClass.Company,
                        style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey[600])),
                  ),
                  Text(offerInterestedClass.Date,
                      style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.grey[600]))
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                launch("tel:${offerInterestedClass.Mobileno}");
              },
                child: Icon( Icons.phone_in_talk,size: 40,color: cnst.appcolor)
            )
          ],
        ),
      ),
    );
  }
}
