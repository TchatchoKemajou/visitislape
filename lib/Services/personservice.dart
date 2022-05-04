import 'package:http/http.dart' as http;
import 'dart:convert';
import '../API/securityapi.dart';

class PersonService{
  SecurityApi securityApi = SecurityApi();
  static const _baseService = "personne";

  final String allEmployeeRequest = _baseService + "/allemployees";
  final String allStudentRequest = _baseService +  "/allstudent";
  final String savePersonRequest = _baseService + "/savepersonne";
  final String updateCardRequest = _baseService + "/desactivatecard";

  updateCard(id) async{
    final fullUrl = securityApi.getUrl() + updateCardRequest + "/$id";
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

  findAllEmployees() async{
    final fullUrl = securityApi.getUrl() + allEmployeeRequest;
    final String token = await securityApi.getToken();
    return http.get(
        Uri.parse(fullUrl),
        headers: securityApi.setHeadersWithToken(token)
    );
  }

  savePerson(data) async{
    final fullUrl = securityApi.getUrl() + savePersonRequest;
    final String token = await securityApi.getToken();
    return http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: securityApi.setHeadersWithToken(token)
    );
  }

}