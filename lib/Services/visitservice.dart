
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visitislape/API/securityapi.dart';

class VisitService{
  SecurityApi securityApi = SecurityApi();
  static const String baseService = "visite";

  final String allVisitRequest = baseService + "/allvisite";
  final String visitOfDayRequest = baseService + "/allvisiteday";
  final String saveVisitRequest = baseService + "/addvisite";
  final String saveAttenteRequest = baseService + "/addattente";
  final String endVisitRequest = baseService + "/endvisite/";
  final String startVisitRequest = baseService + "/startvisite/";
  final String downloadPdfRequest = baseService + "/downloadpdf";

  downloadPdf() async{
    final fullUrl = securityApi.getUrl() + downloadPdfRequest;
    final String token = await securityApi.getToken();
    return http.get(
        Uri.parse(fullUrl),
        headers: securityApi.setHeadersWithToken(token)
    );
  }

  findAllVisite() async{
    final String token = await securityApi.getToken();
    final int site = await securityApi.getSite();
    final fullUrl = securityApi.getUrl() + allVisitRequest + "/$site";
    return http.get(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  findVisitOfDay() async{
    final String token = await securityApi.getToken();
    final int site = await securityApi.getSite();
    final fullUrl =  securityApi.getUrl() + visitOfDayRequest + "/$site";
    return http.get(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  saveViSite(data) async{
    var fullUrl = securityApi.getUrl() + saveVisitRequest;
    final String token = await securityApi.getToken();
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  saveAttente(data) async{
    var fullUrl = securityApi.getUrl() + saveAttenteRequest;
    final String token = await securityApi.getToken();
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  endVisit(id) async{
    var fullUrl = securityApi.getUrl() + endVisitRequest + "$id";
    final String token = await securityApi.getToken();
    return http.put(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  startVisite(id) async{
    var fullUrl = securityApi.getUrl() + startVisitRequest + "$id";
    final String token = await securityApi.getToken();
    return http.put(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }



}