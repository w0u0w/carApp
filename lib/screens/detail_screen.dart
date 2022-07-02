import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final date;
  final startTime;
  final endTime;
  final startPoint;
  final endPoint;
  final maxSpeed;
  final minSpeed;
  final alertScore;
  const DetailScreen(
      {Key? key,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.maxSpeed,
      required this.minSpeed,
      required this.startPoint,
      required this.endPoint,
      required this.alertScore})
      : super(key: key);

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
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 70.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft, child: Text('Дата поездки: ' + date, style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Время начала поездки: ' + startTime, style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Время окончания поездки: ' + endTime, style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Старт: ' + startPoint, style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Конец: ' + endPoint, style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Максимальная скорость: ' + maxSpeed + ' км/ч', style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Минимальная скорость: ' + minSpeed + ' км/ч', style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
              SizedBox(height: 10.0,),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Количество опасных ситуаций: ' + alertScore, style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),)),
            ],
          ),
        ),
      ),
    );
  }
}
