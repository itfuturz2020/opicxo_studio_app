import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:opicxo_studio_app/Components/ImageHandlerComponent.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:opicxo_studio_app/common/Constants.dart' as constant;
//
// class AddService extends StatefulWidget {
//   @override
//   _AddServiceState createState() => _AddServiceState();
// }
//
// class _AddServiceState extends State<AddService>
//     with TickerProviderStateMixin, ImagePickerListener {
//   bool isLoading = false;
//   String MemberId = "";
//   TextEditingController txtTitle = new TextEditingController();
//   TextEditingController txtDesc = new TextEditingController();
//   List<Asset> _image = List<Asset>();
//   ImagePickerHandler imagePicker;
//   File _Image;
//   AnimationController _controller;
//   DateTime date = new DateTime.now();
//
//   @override
//   void initState() {
//     super.initState();
//     GetLocalData();
//     _controller = new AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     imagePicker = new ImagePickerHandler(this, _controller);
//     imagePicker.init();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   getImageFileFromAsset(String path) async {
//     File file = File(path);
//     return file;
//   }
//   // Future getFromCamera() async {
//   //   var image = await ImagePicker.pickImage(source: ImageSource.camera);
//   //   if (image != null) {
//   //     setState(() {
//   //       _Image = image;
//   //     });
//   //   }
//   // }
//   //
//   // Future getFromGallery() async {
//   //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//   //   if (image != null) {
//   //     setState(() {
//   //       _Image = image;
//   //     });
//   //   }
//   // }
//   //
//   // void _settingModalBottomSheet() {
//   //   showModalBottomSheet(
//   //       context: context,
//   //       builder: (BuildContext bc) {
//   //         return Container(
//   //           child: new Wrap(
//   //             children: <Widget>[
//   //               Column(
//   //                 crossAxisAlignment: CrossAxisAlignment.start,
//   //                 children: [
//   //                   Padding(
//   //                     padding: const EdgeInsets.only(
//   //                         top: 15.0, left: 15, bottom: 10),
//   //                     child: Text(
//   //                       "Add Photo",
//   //                       style: TextStyle(
//   //                         fontSize: 22,
//   //                         color: cnst.buttoncolor,
//   //                         //fontWeight: FontWeight.bold
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   GestureDetector(
//   //                     onTap: () {
//   //                       getFromCamera();
//   //                       Navigator.of(context).pop();
//   //                     },
//   //                     child: ListTile(
//   //                       leading: Padding(
//   //                         padding: const EdgeInsets.only(right: 10.0, left: 15),
//   //                         child: Container(
//   //                             height: 20,
//   //                             width: 20,
//   //                             child: Image.asset(
//   //                               "assets/camera.png",
//   //                               color: cnst.buttoncolor,
//   //                             )),
//   //                       ),
//   //                       title: Text(
//   //                         "Take Photo",
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   Padding(
//   //                     padding: const EdgeInsets.only(left: 15, right: 15),
//   //                     child: Divider(),
//   //                   ),
//   //                   GestureDetector(
//   //                     onTap: () {
//   //                       getFromGallery();
//   //                       Navigator.of(context).pop();
//   //                     },
//   //                     child: ListTile(
//   //                       leading: Padding(
//   //                         padding: const EdgeInsets.only(right: 10.0, left: 15),
//   //                         child: Container(
//   //                             height: 20,
//   //                             width: 20,
//   //                             child: Image.asset(
//   //                               "assets/gallery.png",
//   //                               color: cnst.buttoncolor,
//   //                             )),
//   //                       ),
//   //                       title: Text(
//   //                         "Choose from Gallery",
//   //                       ),
//   //                     ),
//   //                   ),
//   //                   Align(
//   //                     alignment: AlignmentDirectional.bottomEnd,
//   //                     child: Padding(
//   //                       padding: const EdgeInsets.only(right: 25.0, bottom: 5),
//   //                       child: FlatButton(
//   //                         onPressed: () {
//   //                           Navigator.of(context).pop();
//   //                         },
//   //                         child: Text(
//   //                           "Cancel",
//   //                           style: TextStyle(
//   //                             fontSize: 18,
//   //                             color: cnst.buttoncolor,
//   //                             //fontWeight: FontWeight.bold
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     ),
//   //                   ),
//   //                 ],
//   //               )
//   //             ],
//   //           ),
//   //         );
//   //       });
//   // }
//
//   GetLocalData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String memberId = prefs.getString(constant.Session.StudioId);
//
//     if (memberId != null && memberId != "")
//       setState(() {
//         MemberId = memberId;
//       });
//   }
//
//   Widget buildGridView() {
//     return GridView.count(
//       crossAxisCount: 3,
//       children: List.generate(_image.length, (index) {
//         Asset asset = _image[index];
//         return AssetThumb(
//           asset: asset,
//           width: 300,
//           height: 300,
//         );
//       }),
//     );
//   }
//
//   Future<void> loadAssets() async {
//     List<Asset> resultList = List<Asset>();
//     String error = 'No Error Dectected';
//
//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 300,
//         enableCamera: true,
//         selectedAssets: _image,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _image = resultList;
//     });
//   }
//
//   SaveService() async {
//     if (txtTitle.text != '' && txtDesc.text != '') {
//       setState(() {
//         isLoading = true;
//       });
//       var file;
//       String img = '';
//       if (_image != null) {
//         for (int i = 0; i < _image.length; i++) {
//           var path2 =
//               await FlutterAbsolutePath.getAbsolutePath(_image[i].identifier);
//           file = await getImageFileFromAsset(path2);
//           print(file);
//         }
//         List<int> imageBytes = await file.readAsBytesSync();
//         String base64Image = base64Encode(imageBytes);
//         img = base64Image;
//       }
//       print('base64 Img : $img');
//
//       FormData data1 = new FormData.fromMap({
//         'type': 'service',
//         'title': txtTitle.text.replaceAll("'", "''"),
//         'desc': txtDesc.text.replaceAll("'", "''"),
//         'studioid ': MemberId.toString(),
//         'imagecode ': img
//       });
//       var printdata = {
//         'type': 'service',
//         'title': txtTitle.text.replaceAll("'", "''"),
//         'desc': txtDesc.text.replaceAll("'", "''"),
//         'studioid ': MemberId.toString(),
//         'imagecode ': img
//       };
//       print(printdata);
//       Future res = Services.SaveService(data1);
//       res.then((data) {
//         setState(() {
//           isLoading = false;
//         });
//         if (data != null) {
//           Fluttertoast.showToast(
//               msg: "Data Saved",
//               backgroundColor: Colors.green,
//               gravity: ToastGravity.TOP);
//           Navigator.pushReplacementNamed(context, '/Dashboard');
//         } else {
//           Fluttertoast.showToast(
//               msg: "Data Not Saved" + data.MESSAGE,
//               backgroundColor: Colors.red,
//               gravity: ToastGravity.TOP,
//               toastLength: Toast.LENGTH_LONG);
//         }
//       }, onError: (e) {
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(
//             msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
//       });
//     } else {
//       Fluttertoast.showToast(
//           msg: "Please Enter Data First",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.yellow,
//           textColor: Colors.black,
//           fontSize: 15.0);
//     }
//   }
//
//   // SaveService() async {
//   //   if (txtTitle.text != '' && txtDesc.text != '') {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     // String filename = "";
//   //     // String filePath = "";
//   //     // File compressedFile;
//   //     // if (_Image != null) {
//   //     //   ImageProperties properties =
//   //     //       await FlutterNativeImage.getImageProperties(_Image.path);
//   //     //
//   //     //   compressedFile = await FlutterNativeImage.compressImage(
//   //     //     _Image.path,
//   //     //     quality: 80,
//   //     //     targetWidth: 600,
//   //     //     targetHeight: (properties.height * 600 / properties.width).round(),
//   //     //   );
//   //     //
//   //     //   filename = _Image.path.split('/').last;
//   //     //   filePath = compressedFile.path;
//   //     // }
//   //
//   //     String img = '';
//   //     if (_Image != null) {
//   //       List<int> imageBytes = await _Image.readAsBytesSync();
//   //       String base64Image = base64Encode(imageBytes);
//   //       img = base64Image;
//   //     }
//   //
//   //     print('base64 Img : $img');
//   //
//   //     var data = {
//   //       'type': 'service',
//   //       'title': txtTitle.text.replaceAll("'", "''"),
//   //       'desc': txtDesc.text.replaceAll("'", "''"),
//   //       'studioid ': MemberId.toString(),
//   //       'imagecode ': img
//   //     };
//   //
//   //     Future res = Services.SaveService(data);
//   //     res.then((data) {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       if (data != null && data.ERROR_STATUS == false) {
//   //         Fluttertoast.showToast(
//   //             msg: "Data Saved",
//   //             backgroundColor: Colors.green,
//   //             gravity: ToastGravity.TOP);
//   //         Navigator.popAndPushNamed(context, '/Dashboard1');
//   //       } else {
//   //         Fluttertoast.showToast(
//   //             msg: "Data Not Saved" + data.MESSAGE,
//   //             backgroundColor: Colors.red,
//   //             gravity: ToastGravity.TOP,
//   //             toastLength: Toast.LENGTH_LONG);
//   //       }
//   //     }, onError: (e) {
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //       Fluttertoast.showToast(
//   //           msg: "Data Not Saved" + e.toString(), backgroundColor: Colors.red);
//   //     });
//   //   } else {
//   //     Fluttertoast.showToast(
//   //         msg: "Please Enter Data First",
//   //         toastLength: Toast.LENGTH_LONG,
//   //         gravity: ToastGravity.TOP,
//   //         backgroundColor: Colors.yellow,
//   //         textColor: Colors.black,
//   //         fontSize: 15.0);
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Add Service'),
//         ),
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.all(20),
//           //margin: EdgeInsets.only(top: 110),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0),
//                   decoration: BoxDecoration(
//                       color: Color.fromRGBO(255, 255, 255, 0.5),
//                       border: new Border.all(width: 1),
//                       borderRadius: BorderRadius.all(Radius.circular(5))),
//                   child: TextFormField(
//                     controller: txtTitle,
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.title), hintText: "Title"),
//                     keyboardType: TextInputType.text,
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   //height: 40,
//                   width: MediaQuery.of(context).size.width - 40,
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 0),
//                   margin: EdgeInsets.only(top: 20),
//                   decoration: BoxDecoration(
//                       color: Color.fromRGBO(255, 255, 255, 0.5),
//                       border: new Border.all(width: 1),
//                       borderRadius: BorderRadius.all(Radius.circular(5))),
//                   child: TextFormField(
//                     controller: txtDesc,
//                     maxLines: 10,
//                     decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.description),
//                         hintText: "Description"),
//                     keyboardType: TextInputType.multiline,
//                     style: TextStyle(color: Colors.black),
//                   ),
//                   //height: 40,
//                   width: MediaQuery.of(context).size.width - 40,
//                 ),
//                 RaisedButton(
//                   child: Text(
//                     "Pick Image",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   onPressed: loadAssets,
//                 ),
//                 Expanded(
//                   child: buildGridView(),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 25.0),
//                 //   child: Container(
//                 //     height: MediaQuery.of(context).size.height * 0.17,
//                 //     width: MediaQuery.of(context).size.height * 0.17,
//                 //     decoration: BoxDecoration(
//                 //       color: Colors.white,
//                 //       border: Border.all(color: cnst.buttoncolor, width: 1),
//                 //       borderRadius: BorderRadius.all(Radius.circular(16.0)),
//                 //       // boxShadow: [
//                 //       //   BoxShadow(
//                 //       //       color: appPrimaryMaterialColor.withOpacity(0.2),
//                 //       //       blurRadius: 2.0,
//                 //       //       spreadRadius: 2.0,
//                 //       //       offset: Offset(3.0, 5.0))
//                 //       // ],
//                 //     ),
//                 //     child: _Image != null
//                 //         ? Image.file(_Image)
//                 //         : Center(child: Text("Select Image")),
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding:
//                 //       const EdgeInsets.only(top: 30.0, left: 25, right: 25),
//                 //   child: Container(
//                 //     width: MediaQuery.of(context).size.width,
//                 //     height: 40,
//                 //     child: RaisedButton(
//                 //         color: cnst.buttoncolor,
//                 //         shape: RoundedRectangleBorder(
//                 //           borderRadius: BorderRadius.circular(5),
//                 //         ),
//                 //         onPressed: () {
//                 //           _settingModalBottomSheet();
//                 //         },
//                 //         child: Text("Upload Offer",
//                 //             style: TextStyle(
//                 //                 color: Colors.white,
//                 //                 fontWeight: FontWeight.w500,
//                 //                 fontSize: 17))),
//                 //   ),
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 20),
//                 //   child: GestureDetector(
//                 //     onTap: () => imagePicker.showDialog(context),
//                 //     child: new Center(
//                 //       child: _image == null
//                 //           ? Image.asset(
//                 //               "images/logo1.png",
//                 //               height: MediaQuery.of(context).size.width - 100,
//                 //               width: MediaQuery.of(context).size.width - 100,
//                 //             )
//                 //           : new Container(
//                 //               height: MediaQuery.of(context).size.width - 100,
//                 //               width: MediaQuery.of(context).size.width - 100,
//                 //               decoration: new BoxDecoration(
//                 //                 color: const Color(0xff7c94b6),
//                 //                 image: new DecorationImage(
//                 //                   image: new ExactAssetImage(_image.path),
//                 //                   fit: BoxFit.cover,
//                 //                 ),
//                 //                 border: Border.all(
//                 //                     color: cnst.buttoncolor, width: 2.0),
//                 //                 borderRadius: new BorderRadius.all(
//                 //                     const Radius.circular(60.0)),
//                 //               ),
//                 //             ),
//                 //     ),
//                 //   ),
//                 // ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(top: 10),
//                   child: MaterialButton(
//                     color: cnst.buttoncolor,
//                     minWidth: MediaQuery.of(context).size.width - 20,
//                     onPressed: () {
//                       if (isLoading == false) this.SaveService();
//                     },
//                     child: setUpButtonChild(),
//                   ) /*RaisedButton(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             elevation: 5,
//                             textColor: Colors.white,
//                             color: cnst.buttoncolor,
//                             child: Text("Add Service",
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 15)),
//                             onPressed: () {
//                               Navigator.pushNamed(context, "/Dashboard");
//                             },
//                             shape: new RoundedRectangleBorder(
//                                 borderRadius: new BorderRadius.circular(30.0)))*/
//                   ,
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget setUpButtonChild() {
//     if (isLoading == false) {
//       return new Text(
//         "Add Service",
//         style: TextStyle(
//             color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
//       );
//     } else {
//       return CircularProgressIndicator(
//         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//       );
//     }
//   }
//
//   @override
//   userImage(File _image) {
//     // TODO: implement userImage
//     throw UnimplementedError();
//   }
//   // @override
//   // userImage(File _image) {
//   //   setState(() {
//   //     this._image = _image;
//   //   });
//   // }
// }

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService>
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  GetLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    StudioId = prefs.getString(constant.Session.StudioId);
  }

  getImageFileFromAsset(String path) async {
    File file = File(path);
    return file;
  }

  SaveService() async {
    if (txtTitle.text != '' && txtDesc.text != '') {
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
        'description': txtDesc.text,
        'type': 'service',
        'imagecode': img,
      });
      var printdata = {
        'studioid': StudioId.toString(),
        'title': txtTitle.text,
        'description': txtDesc.text,
        'imagecode': img,
        'type': "service"
      };
      print(printdata);
      Future res = Services.SaveService(data1);
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
            title: Text('Add Service'),
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
                    color: Colors.redAccent,
                    minWidth: MediaQuery.of(context).size.width - 20,
                    onPressed: () {
                      if (isLoading == false) this.SaveService();
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
        "Add Service",
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
