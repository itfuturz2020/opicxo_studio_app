import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/ImageView.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'NoDataComponent.dart';
import 'package:photo_view/photo_view.dart';

class SelectedPhotoListComponent extends StatefulWidget {
  var NewList;

  SelectedPhotoListComponent(this.NewList);
  @override
  _SelectedPhotoListComponentState createState() =>
      _SelectedPhotoListComponentState();
}

class _SelectedPhotoListComponentState
    extends State<SelectedPhotoListComponent> {
  ProgressDialog pr;
  bool isLoading = true;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageView(widget.NewList["Photo"]
                    ),
            ),
        );
        //Navigator.pushReplacementNamed(context, "/ImageView");
      },
      child: Container(
        padding: EdgeInsets.all(8),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: cnst.appcolor)),
            side: BorderSide(
                width: 0.10, color: cnst.appPrimaryMaterialColorPink),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Container(
            //padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                // Image.asset("images/b4.png"),
                ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: widget.NewList["Photo"] != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/no_image.png',
                          image: "${widget.NewList["Photo"]}",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.blue[100],
                        ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        /*   GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cnst.appPrimaryMaterialColorPink,
                              ),
                              */ /* child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 19,
                              ),*/ /*
                            )),
                        GestureDetector(
                          onTap: () {
                            //   _settingModalBottomSheet(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cnst.appPrimaryMaterialColorYellow,
                            ),
                            child: Icon(Icons.chat_bubble_outline,
                                size: 15, color: Colors.white),
                          ),
                        ),*/
                        /*Platform.isIOS ?
                              Container():
                          GestureDetector(
                            onTap: () {
                              _downloadFile(widget.albumData["Photo"]);
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: downloading == true
                                  ? Container(
                                child: CircularProgressIndicator(),
                              )
                                  : Icon(
                                Icons.file_download,
                                size: 17,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              shareFile("${cnst.ImgUrl}${widget.albumData["Photo"].toString()}");

                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Icon(
                                Icons.share,
                                size: 17,
                              ),
                            ),
                          ),*/
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
