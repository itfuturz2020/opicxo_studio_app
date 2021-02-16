import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:opicxo_studio_app/common/Constants.dart';
import 'package:opicxo_studio_app/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAlbum extends StatefulWidget {
  String index = "";
  String GalleryId = "";
  Function addnewfolder;
  SaveAlbum({this.index,this.GalleryId,this.addnewfolder});
  @override
  _SaveAlbumState createState() => new _SaveAlbumState();
}

class _SaveAlbumState extends State<SaveAlbum> {
  File imageResized;
  List<Asset> images = List<Asset>();
  TextEditingController txtfoldername = new TextEditingController();
  List<Asset> resultList;
  String photoBase64;
  var photo;
  @override
  void initState() {
    super.initState();
  }

  Future getImage(ImageSource source) async {
     photo = await ImagePicker.pickImage(source: source);
    imageResized = await FlutterNativeImage.compressImage(photo.path,
        quality: 100, targetWidth: 120, targetHeight: 120);
    setState(() {
      List<int> imageBytes = imageResized.readAsBytesSync();
      photoBase64 = base64Encode(imageBytes);
      print("photosbase64");
      print(photoBase64);
    });
  }


  int imageslength;
  int ontap;

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String basename;
  var file;
  List extension=[],newList=[];
  int x;
  String img = '';

  getImageFileFromAsset(String path) async{
    File file = File(path);
    basename = file.path;
    return file;
  }

  _CreateFolder() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String studioId = prefs.getString(Session.StudioId);
        if (_image != null){
          for (int i = 0; i < _image.length; i++) {
            var path2 = await FlutterAbsolutePath.getAbsolutePath(_image[i].identifier);
            file = await getImageFileFromAsset(path2);
            print(file);
          }
          List<int> imageBytes = await file.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          img = base64Image;
        }
        var data;
        if(widget.index=="1"){
          print("inside folder");
           data = {
            'studioId': studioId,
            'FolderName': txtfoldername.text,
             'GalleryId' :widget.GalleryId,
            'imagecode': img,
          };
           print(data);
        }
        else {
           data = {
            'studioId': studioId,
            'FolderName': txtfoldername.text,
            'imagecode': img,
          };
        }
        FormData formData = new FormData.fromMap(data);
        if(widget.index=="1") {
          Services.SaveGallery(formData,name: "SaveAlbum").then((data) async {
            // ignore: unrelated_type_equality_checks
            print("data");
            print(data);
            if (data["IsSuccess"]=="true") {
              widget.addnewfolder("addnewfolder");
              showMsg("Album Successfully Created");
            }
            else{
              widget.addnewfolder("addnewfolder");
              showMsg("Album Successfully Created");
            }
          }, onError: (e) {
            print("e.tostring()");
            print(e.toString());
            showMsg("Please pick Image");
          });

        }
        else{
          Services.SaveGallery(formData,name: "").then((data) async {
            // ignore: unrelated_type_equality_checks
            if (data.isNotEmpty) {
              Fluttertoast.showToast(
                  msg: "Folder Successfully Created",
                  backgroundColor: appPrimaryMaterialColorYellow,
                  textColor: Colors.white,
                  gravity: ToastGravity.BOTTOM,
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.of(context).pop();
            }
          }, onError: (e) {
            showMsg("Please pick Image");
          });
        }
        extension.clear();
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      //pr.hide();

      showMsg("No Internet Connection.");
    }
  }

  List<Asset> _image = List<Asset>();

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

    if (!mounted) return;

    setState(() {
      _image = resultList;
    });
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

  @override
  Widget build(BuildContext context) {
    return
      new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: const Text('Add Folder'),

        ),
        body: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: GestureDetector(
            //     onTap: () => getImage(ImageSource.camera),
            //     child: new Center(
            //       child: photo == null
            //           ? Center(
            //         child: Text("No Image Selected"),)
            //           : new Container(
            //         height: MediaQuery.of(context).size.width - 100,
            //         width: MediaQuery.of(context).size.width - 100,
            //         decoration: new BoxDecoration(
            //           color: const Color(0xff7c94b6),
            //           image: new DecorationImage(
            //             image: new ExactAssetImage(photo.path),
            //             fit: BoxFit.cover,
            //           ),
            //           borderRadius: new BorderRadius.all(
            //               const Radius.circular(60.0)),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                height: 50,
                child: TextFormField(
                  validator: (value) {
                    if (value.trim() == "") {
                      return 'Please Name Folder';
                    }
                    return null;
                  },
                  controller: txtfoldername,
                  scrollPadding: EdgeInsets.all(0),
                  decoration: InputDecoration(
                      labelText: "Name Folder",
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Colors.purple),
                          borderRadius: BorderRadius.all(
                              Radius.circular(11))),
                      prefixIcon: Icon(
                        Icons.folder,
                        color: Colors.purple,
                      ),
                      counterText: "",
                      // hintText: "Address",
                      hintStyle: TextStyle(fontSize: 15)),
                  maxLength: 100,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: buildGridView(),
            ),
            Row(
              children: [
                RaisedButton(
                  child: Text("Pick image",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: loadAssets,
                ),
                RaisedButton(
                  child: Text("Create Folder",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: (){
                    if(txtfoldername.text==""){
                      showMsg("Please Enter Folder Name");
                    }else {
                      _CreateFolder();
                    }},
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
        ),

      );
  }
}