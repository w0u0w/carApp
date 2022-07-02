import 'dart:ffi';

import 'package:diplom_system_app/rest/rest_api.dart';
import 'package:diplom_system_app/screens/detail_screen.dart';
import 'package:diplom_system_app/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../animations.dart';

class StatisticScreen extends StatefulWidget {
  final String userId;
  final List arrOfUserStatData;

  const StatisticScreen(
      {Key? key, required this.userId, required this.arrOfUserStatData})
      : super(key: key);

  @override
  _StatisticScreenState createState() =>
      _StatisticScreenState(userId, arrOfUserStatData);
}

class _StatisticScreenState extends State<StatisticScreen> {
  String userId;
  List arrOfUserStatData;
  _StatisticScreenState(this.userId, this.arrOfUserStatData);

  Widget _buildStatF(travelData) {
    String date = travelData['start_time'].toString().substring(0, 10);
    String startTime = travelData['start_time'].toString().substring(11, 19);
    String endTime = travelData['end_time'].toString().substring(11, 19);
    String startPoint = travelData['start_point'].toString().substring(0, 39);
    String endPoint = travelData['end_point'].toString().substring(0, 39);
    String maxSpeed = travelData['max_speed'].toString();
    String minSpeed = travelData['min_speed'].toString();
    String alertScore = travelData['alert_score'].toString();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        date: date,
                        startTime: startTime,
                        endTime: endTime,
                        maxSpeed: maxSpeed,
                        minSpeed: minSpeed,
                        startPoint: startPoint,
                        endPoint: endPoint,
                        alertScore: alertScore,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          height: 125,
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Дата: ' + date.toString(),
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                ),
              ),
              Text(
                'Время: ' + startTime + '-' + endTime,
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackToHomeBTN() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          // print(arrOfUserStatData.length);
          Route route = SlideRightRoute(
              page: HomeScreen(
            userId: userId,
          ));
          Navigator.pushReplacement(context, route);
        },
        elevation: 5.0,
        padding: EdgeInsets.all(15.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white,
        child: Text(
          'Назад',
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Center(
          child: Text(
            'Ваша статистика',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
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
        child: ListView.builder(
            itemCount: arrOfUserStatData.length,
            itemBuilder: (context, index) {
              // print(arrOfUserStatData[index]['id']);
              return _buildStatF(arrOfUserStatData[index]);
            }),
      ),
    );
  }
}
