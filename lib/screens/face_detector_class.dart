// ignore: import_of_legacy_library_into_null_safe

import 'package:audioplayers/audioplayers.dart';
import 'package:diplom_system_app/screens/geoUtils.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

double mouthCounter = 0.0;
double blinkCounter = 0.0;
double blinkTick = 0.0;
int alertCount = 0;
final stopwatchBT = Stopwatch();
final stopwatchMT = Stopwatch();
final stopwatchClosed = Stopwatch();

bool isDangerMT = false;
bool isDangerBT = false;
bool isDangerClosed = false;

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);
  int colorInt = 1;
  final constEAR = 0.25;
  final constMOUTH = 0.5;
  final constSecTickBlinks = 10.0; //60 sec
  final constSecTickMouth = 1200.0; //1200 sec = 20 min
  final constClosedEye = 1.2;
  final Size absoluteImageSize;
  final List<Face> faces;
  final player = AudioCache();

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.indigo,
    Colors.limeAccent,
    Colors.orange
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    try {
      Face face = faces[0];
      var contrLeftEye = face.getContour(FaceContourType.leftEye).positionsList;
      var contrRightEye =
          face.getContour(FaceContourType.rightEye).positionsList;
      var contrUpLip =
          face.getContour(FaceContourType.upperLipTop).positionsList;
      var contrBotLip =
          face.getContour(FaceContourType.lowerLipBottom).positionsList;

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
      //print('pR1: $pR1, pL1: $pL1');
      // print('pR2: $pR2, pL2: $pL2');
      // print('pR3: $pR3, pL3: $pL3');
      // print('pR4: $pR4, pL4: $pL4');
      // print('pR5: $pR5, pL5: $pL5');
      // print('pR6: $pR6, pL6: $pL6');
      double earRight = double.parse(
          (((pR2 - pR6).distance + (pR3 - pR5).distance) /
                  (2.0 * (pR1 - pR4).distance))
              .toStringAsFixed(2));
      double earLeft = double.parse(
          (((pL2 - pL6).distance + (pL3 - pL5).distance) /
                  (2.0 * (pL1 - pL4).distance))
              .toStringAsFixed(2));

      // print('Left EAR: $earLeft, Right EAR: $earRight');
      double medEar =
          double.parse(((earRight + earLeft) / 2.0).toStringAsFixed(2));

      // print('EAR: $medEar');

      // alarmEar.playAlarm();

      if (medEar < constEAR) {
        //print("BLINK");
        blinkCounter += 1.0;
        colorInt = 0;
        if (!stopwatchClosed.isRunning) {
          stopwatchClosed.start();
        } else {
          int currenTimeSec = stopwatchClosed.elapsedMilliseconds;
          double seconds =
              double.parse(((currenTimeSec / 1000) % 60).toStringAsFixed(2));
          // print('Глаза были закрыты ${seconds}sec');
          if (seconds > constClosedEye) {
            isDangerClosed = true;
            alertCount += 1;

            player.play('alert1.mp3');
          }
        }
      } else {
        colorInt = 1; //1
        if (stopwatchClosed.isRunning) {
          stopwatchClosed.reset();
          if (isDangerClosed) {
            isDangerClosed = false;
          }
        }
      }

      if (!stopwatchBT.isRunning) {
        stopwatchBT.start();
      } else {
        int currenTimeSec = stopwatchBT.elapsedMilliseconds;
        double seconds =
            double.parse(((currenTimeSec / 1000) % 60).toStringAsFixed(2));
        //print('Времени прошло ${seconds}sec');
        if (seconds >= constSecTickBlinks) {
          blinkTick = double.parse((blinkCounter / constSecTickBlinks).toStringAsFixed(2));
          blinkCounter = 0.0;
          if (blinkTick > 0.5) {
            isDangerBT = true;
            alertCount += 1;
            player.play('alert1.mp3');
          }
          stopwatchBT.reset();
        }
      }
      print(blinkTick);
      if (!stopwatchMT.isRunning) {
        stopwatchMT.start();
        // stopwatch.stop();
      } else {
        int currenTimeSec = stopwatchMT.elapsedMilliseconds;
        double seconds =
            double.parse(((currenTimeSec / 1000) % 60).toStringAsFixed(2));
        //print('Времени прошло ${seconds}sec');
        if (seconds >= constSecTickMouth && mouthCounter >= 3) {
          mouthCounter = 0.0;
          player.play('alert1.mp3');
          isDangerMT = true;
          alertCount += 1;

          stopwatchMT.reset();
        }
      }

      // print(alertCount);
      alertScore = alertCount.toString();

      final textStyle = TextStyle(
        color: Colors.red,
        fontSize: 25,
      );
      final textSpanEAR = TextSpan(
        text: 'EAR: $medEar',
        style: textStyle,
      );
      final textPainterEAR = TextPainter(
        text: textSpanEAR,
        textDirection: TextDirection.ltr,
      );
      textPainterEAR.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final xCenterEAR = 0.0;
      final yCenterEAR = 0.0;
      final offsetEAR = Offset(xCenterEAR, yCenterEAR);
      textPainterEAR.paint(canvas, offsetEAR);

      final textSpanBT = TextSpan(
        text: 'BT: $blinkTick',
        style: textStyle,
      );
      final textPainterBT = TextPainter(
        text: textSpanBT,
        textDirection: TextDirection.ltr,
      );
      textPainterBT.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final xCenterBT = 130.0;
      final yCenterBT = 0.0;
      final offsetBT = Offset(xCenterBT, yCenterBT);
      textPainterBT.paint(canvas, offsetBT);

      final textSpanMT = TextSpan(
        text: 'MT: 0.0',
        style: textStyle,
      );
      final textPainterMT = TextPainter(
        text: textSpanMT,
        textDirection: TextDirection.ltr,
      );
      textPainterMT.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final xCenterMT = 230.0;
      final yCenterMT = 0.0;
      final offsetMT = Offset(xCenterMT, yCenterMT);
      textPainterMT.paint(canvas, offsetMT);

      // final textSpanSpeed = TextSpan(
      //   text: 'Скорость: $curSpeed км/ч',
      //   style: textStyle,
      // );
      // final textPainterSpeed = TextPainter(
      //   text: textSpanSpeed,
      //   textDirection: TextDirection.ltr,
      // );
      // textPainterSpeed.layout(
      //   minWidth: 0,
      //   maxWidth: size.width,
      // );
      // final xCenterSP = 0.0;
      // final yCenterSP = 30.0;
      // final offsetSP = Offset(xCenterSP, yCenterSP);
      // textPainterSpeed.paint(canvas, offsetSP);

      // final textSpanBlinks = TextSpan(
      //   text: 'Моргнул: $blinkCounter',
      //   style: textStyle,
      // );
      // final textPainterBlinks = TextPainter(
      //   text: textSpanBlinks,
      //   textDirection: TextDirection.ltr,
      // );
      // textPainterBlinks.layout(
      //   minWidth: 0,
      //   maxWidth: size.width,
      // );
      // final xCenterBlinks = 0.0;
      // final yCenterBlinks = 30.0;
      // final offsetBlinks = Offset(xCenterBlinks, yCenterBlinks);
      // textPainterBlinks.paint(canvas, offsetBlinks);
      var lpT1 = contrUpLip[0];
      var lpT2 = contrUpLip[4];
      var lpT3 = contrUpLip[5];
      var lpT4 = contrUpLip[10];
      var lpB5 = contrBotLip[3];
      var lpB6 = contrBotLip[5];

      double mouthOpLevel = double.parse(
          (((lpT2 - lpB6).distance + (lpT3 - lpB5).distance) /
                  (2.0 * (lpT1 - lpT4).distance))
              .toStringAsFixed(2));

      if (mouthOpLevel > constMOUTH) {
        mouthCounter += 1.0;

        final textStyle = TextStyle(
          color: Colors.red,
          fontSize: 25,
        );
        final textSpanMouth = TextSpan(
          text: 'Зевок зафикисирован',
          style: textStyle,
        );
        final textPainterMouth = TextPainter(
          text: textSpanMouth,
          textDirection: TextDirection.ltr,
        );
        textPainterMouth.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        final xCenterMouth = 0.0;
        final yCenterMouth = 30.0;
        final offsetMouth = Offset(xCenterMouth, yCenterMouth);
        textPainterMouth.paint(canvas, offsetMouth);
        if (mouthCounter == 3.0) {}
      }

      var myTestX = (pR1.dx + pR4.dx) / 2.0;
      var myTestY = (pR1.dy + pR4.dy) / 2.0;
      final offsetTest = Offset(myTestX, myTestY);


      canvas.drawRect(
          // face.boundingBox,
          Rect.fromLTRB(
            face.boundingBox.left * scaleX,
            face.boundingBox.top * scaleY,
            face.boundingBox.right * scaleX,
            face.boundingBox.bottom * scaleY,
          ),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0
            ..color = colors[colorInt]);
    } catch (e) {
      print("noFaceDetected");
      mouthCounter = 0.0;
      blinkCounter = 0.0;
      alertCount = 0;
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
