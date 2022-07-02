import 'package:camera/camera.dart';
import 'package:diplom_system_app/animations.dart';
import 'package:diplom_system_app/rest/rest_api.dart';
import 'package:diplom_system_app/screens/geoUtils.dart';
import 'package:diplom_system_app/screens/login_screen.dart';
import 'package:diplom_system_app/screens/monitoring_screen.dart';
import 'package:diplom_system_app/screens/statistic_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(userId);
}

class _HomeScreenState extends State<HomeScreen> {
  String userId;
  _HomeScreenState(this.userId);

  Widget _buildStartMonitoringBTN() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () async{
          Position position = await _determinePosition();
          startLocation = 'Lat: ${position.latitude}, Long: ${position.longitude}';
          List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
          Placemark place = placemark[0];
          startAddress = '${place.name}, ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
          startTime = DateTime.now().toLocal().toString();

          // var options = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10);
          //
          // Geolocator.getPositionStream().listen((position) {
          //   var speedInMps = position.speed;
          //   print(speedInMps * 3.6);// this is your speed
          // });

          setState(() {

          });
          Route route = SlideLeftRoute(page: MonitoringScreen(userId: userId,));
          Navigator.push(context, route);
        },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'Начать отслеживание',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  Widget _buildShowStatisticingBTN() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () async {
          var arrStat = await askStatistic(userId);
          Route route = SlideLeftRoute(page: StatisticScreen(userId: userId, arrOfUserStatData: arrStat,));
          Navigator.push(context, route);
        },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'Показать статистику',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginBTN() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          Route route = SlideRightRoute(page: LoginScreen());
          Navigator.pop(context, route);
        },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'Выход',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
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
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 70.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Выбрать действие',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                  _buildStartMonitoringBTN(),
                  _buildShowStatisticingBTN(),
                  _buildBackToLoginBTN(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  askStatistic(String userId) async {
    var res = await userAskStatistic(userId.trim());
    if(res['success'] && res['message'].toString() != '[]'){
      // for(int i = 0; i < res['message'].length; i++){
      //   print(res['message'][i]);
      // }
      return res['message'];
    }
    else {
      return [];
    }
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

}
