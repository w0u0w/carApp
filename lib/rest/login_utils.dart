import 'dart:convert';

class LUtils{
  static Uri loginUrl = Uri.parse('http://192.168.43.106:3000/users/login');
  static Uri registrationUrl = Uri.parse('http://192.168.43.106:3000/users/register');
  static Uri statisticUrl = Uri.parse('http://192.168.43.106:3000/travels/statistic');
  static Uri newTravelUrl = Uri.parse('http://192.168.43.106:3000/travels/new');
  // static Uri loginUrl = Uri.parse('http://192.168.43.106:3000/users/login');
  // static Uri registrationUrl = Uri.parse('http://192.168.1.127:3000/users/register');
  // static Uri statisticUrl = Uri.parse('http://192.168.1.127:3000/travels/statistic');
  // static Uri newTravelUrl = Uri.parse('http://192.168.1.127:3000/travels/new');
  static var key = utf8.encode('p@ssw0rd');
}