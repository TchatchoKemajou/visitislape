import 'dart:convert';

import 'package:visitislape/API/securityapi.dart';
import 'package:http/http.dart' as http;

class AuthService{
  SecurityApi securityApi = SecurityApi();
  static const String _baseService1 = "site";
  static const String _baseService2 = "gardien";

  final String createSiteRequest = _baseService1 + "/addSite";
  final String createGuardRequest = _baseService2 + "/addGuard";
  final String authGuardRequest = "auth/login";

  createSite(data) async{
    final fullUrl = securityApi.getUrl() + createSiteRequest;
    final token = await securityApi.getToken();

    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeaders()
    );
  }

  createGuard(data) async{
    final fullUri = securityApi.getUrl() + createGuardRequest;
    final token = await securityApi.getToken();

    return http.post(
      Uri.parse(fullUri),
      body: jsonEncode(data),
      headers: securityApi.setHeaders()
    );
  }

  authGuard(data) async{
    final fullUri = securityApi.getUrl() + authGuardRequest;

    return http.post(
        Uri.parse(fullUri),
        body: jsonEncode(data),
        headers: securityApi.setHeaders()
    );
  }

}