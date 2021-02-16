import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import '../common/Services.dart';
import 'package:flutter/material.dart';
import '../common/Constants.dart' as cnst;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/ImagePickerHandlerComponent.dart';

class AddOffer extends StatefulWidget {
  @override
  _AddOfferState createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer>
    with TickerProviderStateMixin, ImagePickerListener {
  bool isLoading = false;
  List<Asset> _image = List<Asset>();
  AnimationController _controller;
  ImagePickerHandler imagePicker;

  TextEditingController txtTitle = new TextEditingController();
  TextEditingController txtDate = new TextEditingController();
  TextEditingController txtDesc = new TextEditingController();

  DateTime date = new DateTime.now();
  String StudioId = "";

  @override
  void initState() {
    super.initState();
    GetLocalData();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    txtDate.text = date.year.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.day.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StudioId = prefs.getString(cnst.Session.StudioId);
  }

  getImageFileFromAsset(String path) async {
    File file = File(path);
    return file;
  }

  SaveOffer() async {
    if (txtTitle.text != '' && txtDate.text != '' && txtDesc.text != '') {
      setState(() {
        isLoading = true;
      });
      var file;
      String img = '';
      if (_image != null) {
        for (int i = 0; i < _image.length; i++) {
          var path2 =
              await FlutterAbsolutePath.getAbsolutePath(_image[i].identifier);
          file = await getImageFileFromAsset(path2);
          print(file);
        }
        List<int> imageBytes = await file.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        img = base64Image;
      }

      print('base64 Img : $img');

      FormData data1 = new FormData.fromMap({
        'studioid': StudioId.toString(),
        'title': txtTitle.text,
        'desc': txtDesc.text,
        'validtilldate': txtDate.text,
        'imagecode': img,
      });
      var printdata = {
        'studioid': StudioId.toString(),
        'title': txtTitle.text,
        'desc': txtDesc.text,
        'validtilldate': txtDate.text,
        'imagecode': img,
      };
      print(printdata);
      Future res = Services.AddOffer(data1);
      res.then((data) {
        setState(() {
          isLoading = false;
        });
        if (data != null) {
          Fluttertoast.showToast(
              msg: "Data Saved",
              backgroundColor: Colors.green,
              gravity: ToastGravity.TOP);
          Navigator.pushReplacementNamed(context, '/Dashboard');
        } else {
          Fluttertoast.showToast(
              msg: "Data Not Saved" + data.MESSAGE,
              backgroundColor: Colors.red,
              gravity: ToastGravity.TOP,
              toastLength: Toast.LENGTH_LONG);
        }
      }, onError: (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please Enter Data First",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 15.0);
    }
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(_image.length, (index) {
        Asset asset = _image[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: _image,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _image = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/Dashboard");
              },
            ),
            title: Text('Add Offer'),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            //margin: EdgeInsets.only(top: 110),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      border: new Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: txtTitle,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.title), hintText: "Title"),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            locale: 'en',
                            minYear: 1970,
                            maxYear: 2020,
                            initialYear: DateTime.now().year,
                            initialMonth: DateTime.now().month,
                            initialDate: DateTime.now().day,
                            cancel: Text('cancel'),
                            confirm: Text('confirm'),
                            dateFormat: 'dd-mmm-yyyy',
                            onChanged: (year, month, date) {},
                            onConfirm: (year, month, date) {
                              txtDate.text = year.toString() +
                                  '-' +
                                  month.toString() +
                                  '-' +
                                  date.toString();
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.5),
                              border: new Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: TextFormField(
                            controller: txtDate,
                            enabled: false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                hintText: "Date"),
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                          ),
                          //height: 40,
                          width: MediaQuery.of(context).size.width - 80,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                      ),
                      GestureDetector(
                          onTap: () {
                            txtDate.text = "";
                          },
                          child: Icon(Icons.close)),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      border: new Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    maxLines: 5,
                    controller: txtDesc,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.description),
                        hintText: "Description"),
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Colors.black),
                  ),
                  //height: 40,
                  width: MediaQuery.of(context).size.width - 40,
                ),
                RaisedButton(
                  child: Text(
                    "Pick Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: loadAssets,
                ),
                Expanded(
                  child: buildGridView(),
                )
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //       child: buildGridView(),
                //     // onTap: () => imagePicker.showDialog(context),
                //     // child: new Center(
                //     //   child: _image == null
                //     //       ? Image.asset(
                //     //     "images/logo1.png",
                //     //     height: MediaQuery.of(context).size.width - 100,
                //     //     width: MediaQuery.of(context).size.width - 100,
                //     //   )
                //     //       : new Container(
                //     //     height: MediaQuery.of(context).size.width - 100,
                //     //     width: MediaQuery.of(context).size.width - 100,
                //     //     decoration: new BoxDecoration(
                //     //       color: const Color(0xff7c94b6),
                //     //       image: new DecorationImage(
                //     //         image: new ExactAssetImage(_image),
                //     //         fit: BoxFit.cover,
                //     //       ),
                //     //       border: Border.all(
                //     //           color: cnst.buttoncolor, width: 2.0),
                //     //       borderRadius: new BorderRadius.all(
                //     //           const Radius.circular(60.0)),
                //     //     ),
                //     //   ),
                //     // ),
                // ),
                ,
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 10),
                  child: MaterialButton(
                    color: appPrimaryMaterialColorPink,
                    minWidth: MediaQuery.of(context).size.width - 20,
                    onPressed: () {
                      if (isLoading == false) this.SaveOffer();
                    },
                    child: setUpButtonChild(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // @override
  // userImage(File _image) {
  //   setState(() {
  //     this._image = _image;
  //   });
  // }

  Widget setUpButtonChild() {
    if (isLoading == false) {
      return new Text(
        "Add Offer",
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  @override
  userImage(File _image) {
    // TODO: implement userImage
    throw UnimplementedError();
  }
}
