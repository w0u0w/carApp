import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:diplom_system_app/rest/login_utils.dart';

import 'package:http/http.dart' as http;

Future userLogin(String email, String password) async {
  final response = await http.post(LUtils.loginUrl,
      headers: {"Accept": "Application/json"},
      body: {'email': email, 'password': password});
  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future userRegistration(
    String name, String email, String number, String password) async {
  final response = await http.post(LUtils.registrationUrl, headers: {
    "Accept": "Application/json"
  }, body: {
    'name': name,
    'email': email,
    'phone': number,
    'password': password
  });
  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future userAskStatistic(String userId) async {
  final response = await http.post(LUtils.statisticUrl, headers: {
    "Accept": "Application/json"
  }, body: {
    'user_id': userId
  });
  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future addNewTravel(String userId, String startTime, String endTime, String maxSpeed, String minSpeed, String startCoord, String endCoord, String alertScore) async {
  final response = await http.post(LUtils.newTravelUrl, headers: {
    "Accept": "Application/json"
  }, body: {
    'user_id': userId,
    'start_time': startTime,
    'end_time': endTime,
    'max_speed': maxSpeed,
    'min_speed': minSpeed,
    'start_point': startCoord,
    'end_point': endCoord,
    'alert_score': alertScore,

  });
  var decodeData = jsonDecode(response.body);
  return decodeData;
}