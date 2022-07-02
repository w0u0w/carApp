// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:camera/camera.dart';
import 'package:diplom_system_app/alarmModule.dart';
import 'package:diplom_system_app/rest/rest_api.dart';
import 'package:diplom_system_app/screens/geoUtils.dart';
import 'package:diplom_system_app/screens/utils_scanner.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'face_detector_class.dart';

class CameraPreviewScanner extends StatefulWidget {
  final String userId;
  const CameraPreviewScanner({Key? key, required this.userId}) : super(key: key);

  @override
  _CameraPreviewScannerState createState() => _CameraPreviewScannerState(userId);
}

class _CameraPreviewScannerState extends State<CameraPreviewScanner> {
  String userId;
  _CameraPreviewScannerState(this.userId);
  dynamic _scanResults;
  CameraController? _camera;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;



  final FaceDetector _faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
          mode: FaceDetectorMode.accurate,
          enableLandmarks: true,
          enableClassification: true,
          enableContours: true
        // enableTracking: true
      ));


  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description =
    await ScannerUtils.getCamera(_direction);
    setState(() {});
    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.veryHigh
          : ResolutionPreset.high,
    );
    await _camera!.initialize().catchError((onError) => print(onError));

    _camera!.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      ScannerUtils.detect(
        image: image,
        detectInImage: _faceDetector.processImage,
        imageRotation: description.sensorOrientation,
      ).then(
            (dynamic results) {
          setState(() {
            _scanResults = results;
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Widget _buildResults() {
    Text noResultsText = Text('Поиск лица');

    if (_scanResults == null ||
        _camera == null ||
        !_camera!.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera!.value.previewSize!.height,
      _camera!.value.previewSize!.width,
    );
    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(imageSize, _scanResults);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
      child: _camera == null
          ? Center(
        child: Text(
          'Инициализация камеры...',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CameraPreview(_camera!),
            _buildResults(),
            // Text(face)
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            Position position = await _determinePosition();
            endLocation = 'Lat: ${position.latitude}, Long: ${position.longitude}';
            List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
            Placemark place = placemark[0];
            endAddress = '${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
            endTime = DateTime.now().toLocal().toString();
            doAddNewTravel(userId, startTime, endTime, maxSpeed, minSpeed, startAddress, endAddress, alertScore);
            setState(() {
            });
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Мониторинг',
        ),

        //?centerTitle: true,
      ),
      // drawer: MyDrawer(),
      body:
           _buildImage(),

    );
  }



  @override
  void dispose() {
    _camera!.dispose().then((_) {
      _faceDetector.close();
    });

    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  doAddNewTravel(String userId, String startTime, String endTime, String maxSpeed, String minSpeed, String startAddress, String endAddress, String alertScore) async {
    var res = await addNewTravel(
        userId, startTime.trim(), endTime.trim(), maxSpeed.trim(), minSpeed.trim(), startAddress.trim(), endAddress.trim(), alertScore.trim() );
    print(res.toString());
  }
}


