import 'package:flutter/material.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:contacts_service/contacts_service.dart';

class ContactComponent extends StatelessWidget {

  final Contact contact;
  const ContactComponent(this.contact);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width - 20,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 2), spreadRadius: 1, color: Colors.grey[200])
          ]),
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 111,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(contact.displayName,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cnst.appcolor)),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(contact.middleName,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600])),
                )
              ],
            ),
          ),
          Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                color: cnst.buttoncolor,
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text("24",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600,fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("Jan 19",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600,fontSize: 12)),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
