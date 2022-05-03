import 'package:visitislape/API/securityapi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentServices{
  SecurityApi securityApi = SecurityApi();
  static const _baseService = "etudiant";

  final String allStudentRequest = _baseService +  "/allstudent";
  final String saveStudentRequest = _baseService + "/saveetudiant";
  final String updateStudentCardRequest = _baseService + "/desactivateetudiant";

  updateStudentCard(id) async{
    final fullUrl = securityApi.getUrl() + updateStudentCardRequest + "/$id";
    final String token = await securityApi.getToken();
    return http.put(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  findAllStudent() async{
    final fullUrl = securityApi.getUrl() + allStudentRequest;
    final String token = await securityApi.getToken();
    return http.get(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

  saveStudent(data) async{
    final fullUrl = securityApi.getUrl() + saveStudentRequest;
    final String token = await securityApi.getToken();
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeadersWithToken(token)
    );
  }
}