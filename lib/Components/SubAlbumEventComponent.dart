import 'package:flutter/material.dart';
import 'package:opicxo_studio_app/Common/Constants.dart' as cnst;
import 'package:opicxo_studio_app/Screen/SelectedPhotoList.dart';

class SubAlbumEventComponent extends StatefulWidget {
  var NewList;

  SubAlbumEventComponent(this.NewList);
  @override
  _SubAlbumEventComponentState createState() => _SubAlbumEventComponentState();
}

class _SubAlbumEventComponentState extends State<SubAlbumEventComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                SelectedPhotoList(widget.NewList["Id"],widget.NewList["Name"])));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        margin: EdgeInsets.all(7),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              child: widget.NewList["Photo"] != "" &&
                      widget.NewList["Photo"] != null
                  ? FadeInImage.assetNetwork(
                      placeholder: "",
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      fit: BoxFit.fill,
                      image: "${cnst.ImgUrl}" + widget.NewList["Photo"])
                  : Image.asset(
                      "images/logo1.png",
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      fit: BoxFit.fill,
                    ),
              /*ClipRRect(
                        //borderRadius: new BorderRadius.circular(6.0),

                        child: widget.GalleryData["GalleryCover"] != null
                            ? FadeInImage.assetNetwork(
                          placeholder: 'images/OM.png',
                          image:
                          "${cnst.ImgUrl}${widget.GalleryData["GalleryCover"]}",
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Colors.grey[100],
                        ),
                      ),*/
            ),
            /*Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5),
                      Color.fromRGBO(0, 0, 0, 0.5)
                    ],
                  ),
                  borderRadius: new BorderRadius.all(Radius.circular(6)),
                ),
              ),*/
            Container(
              //height: 190,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 5, top: 5),
                    child: Text(
                      "${widget.NewList["Name"]}",
                      /*'${widget.AlbumData["Name"]}',*/
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //height: 190,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 5),
                    child: Text(
                      "${widget.NewList["SelectedCount"]}/${widget.NewList["AllCount"]}",
                      /*'${widget.AlbumData["SelectedPhotoCount"]}/${widget.AlbumData["NoOfPhoto"]}',*/
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
