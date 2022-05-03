import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visitislape/API/securityapi.dart';
class VisitorService{
  SecurityApi securityApi = SecurityApi();
  static const String _baseService = "visiteur";

  final String addVisitorRequest = _baseService + "/addVisitor";
  final String findAllVisitorRequest = _baseService + "/allVisitors";

  findAllVisitor() async{
    var fullUrl = securityApi.getUrl() + findAllVisitorRequest;
    final String token = await securityApi.getToken();
    return http.get(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  saveVisitor(data) async{
    var fullUrl = securityApi.getUrl() + addVisitorRequest;
    final String token = await securityApi.getToken();
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

}