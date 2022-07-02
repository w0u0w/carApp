import 'dart:async';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

bool isDelayStarted = false;
double counterEyeClose = 0.0;
class AlarmModule {
  AlarmModule(this.faces);
  final List<Face> faces;


  double calcEar() {
      Face face = faces[0];
      var contrLeftEye = face.getContour(FaceContourType.leftEye).positionsList;
      var contrRightEye =
          face.getContour(FaceContourType.rightEye).positionsList;
      var pR1 = contrRightEye[0];
      var pR2 = contrRightEye[3];
      var pR3 = contrRightEye[5];
      var pR4 = contrRightEye[8];
      var pR5 = contrRightEye[11];
      var pR6 = contrRightEye[13];
      var pL1 = contrLeftEye[0];
      var pL2 = contrLeftEye[3];
      var pL3 = contrLeftEye[5];
      var pL4 = contrLeftEye[8];
      var pL5 = contrLeftEye[11];
      var pL6 = contrLeftEye[13];

      double earRight = double.parse(
          (((pR2 - pR6).distance + (pR3 - pR5).distance) /
              (2.0 * (pR1 - pR4).distance))
              .toStringAsFixed(2));
      double earLeft = double.parse(
          (((pL2 - pL6).distance + (pL3 - pL5).distance) /
              (2.0 * (pL1 - pL4).distance))
              .toStringAsFixed(2));

      double medEar =
      double.parse(((earRight + earLeft) / 2.0).toStringAsFixed(2));

      print('EAR: $medEar');
      return medEar;
  }

  bool isEyeOpen(double ear) {
    bool isOpen = ear < 0.24 ? false : true;
    print('Eye $isOpen');
    return isOpen;
  }

  double eyeTick(bool isOpen) {
    double eyeT = 0.0;
    if(!isOpen) {
      counterEyeClose += 1.0;

    }
    // delayForEyeCounter(counterEyeClose);
    // print(counterEyeClose);
    return eyeT;
  }
}

// Future<double> delayForEyeCounter(counterEyeClose) {
//   // Imagine that this function is fetching user info from another service or database.
//   return Future.delayed(const Duration(seconds: 10), Future<double> count(counterEyeClose) {return (counterEyeClose / 10.0)});
// }