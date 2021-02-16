import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/vec2d.dart';
import 'package:flare_flutter/flare_controls.dart';
import '../../common/DigitalCardCommon/Constants.dart' as cnst;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opicxo_studio_app/Screen/DigitalCardScreen/MemberSelection.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/ClassList.dart';
import 'package:opicxo_studio_app/common/DigitalCardCommon/Services.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TeddyController extends FlareControls {
  // Store a reference to our face control node (the "ctrl_look" node in Flare)
  ActorNode _faceControl;

  // Storage for our matrix to get global Flutter coordinates into Flare world coordinates.
  Mat2D _globalToFlareWorld = Mat2D();

  // Caret in Flutter global coordinates.
  Vec2D _caretGlobal = Vec2D();

  // Caret in Flare world coordinates.
  Vec2D _caretWorld = Vec2D();

  // Store the origin in both world and local transform spaces.
  Vec2D _faceOrigin = Vec2D();
  Vec2D _faceOriginLocal = Vec2D();

  bool _hasFocus = false;

  // Project gaze forward by this many pixels.
  static const double _projectGaze = 60.0;

  String _mobileno;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    super.advance(artboard, elapsed);
    Vec2D targetTranslation;
    if (_hasFocus) {
      // Get caret in Flare world space.
      Vec2D.transformMat2D(_caretWorld, _caretGlobal, _globalToFlareWorld);

      // To make it more interesting, we'll also add a sinusoidal vertical offset.
      _caretWorld[1] +=
          sin(new DateTime.now().millisecondsSinceEpoch / 300.0) * 70.0;

      // Compute direction vector.
      Vec2D toCaret = Vec2D.subtract(Vec2D(), _caretWorld, _faceOrigin);
      Vec2D.normalize(toCaret, toCaret);
      Vec2D.scale(toCaret, toCaret, _projectGaze);

      // Compute the transform that gets us in face "ctrl_face" space.
      Mat2D toFaceTransform = Mat2D();
      if (Mat2D.invert(toFaceTransform, _faceControl.parent.worldTransform)) {
        // Put toCaret in local space, note we're using a direction vector
        // not a translation so transform without translation
        Vec2D.transformMat2(toCaret, toCaret, toFaceTransform);
        // Our final "ctrl_face" position is the original face translation plus this direction vector
        targetTranslation = Vec2D.add(Vec2D(), toCaret, _faceOriginLocal);
      }
    } else {
      targetTranslation = Vec2D.clone(_faceOriginLocal);
    }

    // We could just set _faceControl.translation to targetTranslation, but we want to animate it smoothly to this target
    // so we interpolate towards it by a factor of elapsed time in order to maintain speed regardless of frame rate.
    Vec2D diff =
        Vec2D.subtract(Vec2D(), targetTranslation, _faceControl.translation);
    Vec2D frameTranslation = Vec2D.add(Vec2D(), _faceControl.translation,
        Vec2D.scale(diff, diff, min(1.0, elapsed * 5.0)));

    _faceControl.translation = frameTranslation;

    return true;
  }

  // Fetch references for the `ctrl_face` node and store a copy of its original translation.
  @override
  void initialize(FlutterActorArtboard artboard) {
    super.initialize(artboard);
    _faceControl = artboard.getNode("ctrl_face");
    if (_faceControl != null) {
      _faceControl.getWorldTranslation(_faceOrigin);
      Vec2D.copy(_faceOriginLocal, _faceControl.translation);
    }
    play("idle");
  }

  onCompleted(String name) {
    play("idle");
  }

  // Called every frame by the wrapping [FlareActor].
  // Updates the matrix that transforms Global-Flutter-coordinates into Flare-World-coordinates.
  @override
  void setViewTransform(Mat2D viewTransform) {
    Mat2D.invert(_globalToFlareWorld, viewTransform);
  }

  // Transform the [Offset] into a [Vec2D].
  // If no caret is provided, lower the [_hasFocus] flag.
  void lookAt(Offset caret) {
    if (caret == null) {
      _hasFocus = false;
      return;
    }
    _caretGlobal[0] = caret.dx;
    _caretGlobal[1] = caret.dy;
    _hasFocus = true;
  }

  void setMobile(String value) {
    _mobileno = value;
  }

  Future<List<MemberClass>> CheckLogin() async {
    try {
      List<MemberClass> data = await Services.MemberLogin(_mobileno);
      return data;
    } catch (e) {
      print("Error : on Login Call : $e");
      Fluttertoast.showToast(
          msg: "Error : on Login Call",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
      return null;
    }
  }

  Future<bool> submitLogin(BuildContext context) async {
    if (_mobileno != null && _mobileno != "") {
      CheckLogin().then((data) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (data != null && data.length > 0) {
          if (data.length > 1) {
            play("success");
            Fluttertoast.showToast(
                msg: "Login Successfully !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 15.0);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MemberSelection(memberList: data),
              ),
            );
          }
          else {
            await prefs.setString(cnst.Session.MemberId, data[0].Id);
            await prefs.setString(cnst.Session.Name, data[0].Name);
            await prefs.setString(cnst.Session.Mobile, data[0].Mobile);
            await prefs.setString(cnst.Session.Company, data[0].Company);
            await prefs.setString(cnst.Session.Email, data[0].Email);
            await prefs.setString(cnst.Session.ReferCode, data[0].MyReferralCode);
            await prefs.setBool(cnst.Session.IsActivePayment, data[0].IsActivePayment);

            play("success");
            Fluttertoast.showToast(
                msg: "Login Successfully !",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 15.0);
            Timer(Duration(seconds: 2), () async {
              Navigator.pushReplacementNamed(context, '/Dashboard1');
            });
          }
        } else {
          play("fail");
          Fluttertoast.showToast(
              msg: "Invalid login details",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 15.0);
          return data;
        }
      });
    } else {
      play("fail");
      Fluttertoast.showToast(
          msg: "Please Enter Mobile No !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
      return false;
    }
  }
}
