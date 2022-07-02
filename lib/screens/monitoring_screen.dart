import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';

class MonitoringScreen extends StatefulWidget {
  final String userId;
  const MonitoringScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MonitoringScreenState createState() => _MonitoringScreenState(userId);
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  String userId;
  _MonitoringScreenState(this.userId);

  @override
  Widget build(BuildContext context) {
    return CameraPreviewScanner(userId: userId,);
  }
}

