
import 'package:shared_preferences/shared_preferences.dart';

class SecurityApi{
  static const String baseUrl = "http://localhost:8080";

  //static const String baseUrl = "http://192.168.43.15:8080";

  final String _url = baseUrl + "/api/v1/";

  //static const String token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNyxXaWxsaWFtIiwiaXNzIjoiQ29kZUphdmEiLCJpYXQiOjE2NTA3MDUwMjksImV4cCI6MTY1MDc5MTQyOX0.vQSptGxEQIBgFyLx7rytoOtLB8joePIb0HQSBC0SXRbOBc2MgwKgWW_PAaE5KE2Rgl7w-AbDpcVYcgOrzyyFbg";

  getUrl() => _url;


  setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };

  setHeadersWithToken(String token) => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    "Authorization" : 'Bearer $token',
  };
  setHeadersFormdata() => {
    //'method': 'PUT',
    'Content-type' : 'multipart/form-data',
    'Accept' : 'multipart/form-data',
  };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '$token';
  }
  setToken(String token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', token);
  }

  deleteToken() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }

  setGuard(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt('guard', id);
  }

  setSite(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setInt('site', id);
  }

  getSite() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var site = localStorage.getInt('site');
    return site;
  }

  getGuard() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var guard = localStorage.getInt('guard');
    return guard;
  }

  deleteGuard() async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('guard');
  }


}