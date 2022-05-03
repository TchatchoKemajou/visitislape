import 'package:http/http.dart' as http;
import 'package:visitislape/API/securityapi.dart';
import 'dart:convert';

class EmployeeService{
  SecurityApi securityApi = SecurityApi();
  static const String _baseService = "employee";

  final String allEmployeeRequest = _baseService + "/allemployees";
  final String saveEmployeeRequest = _baseService + "/saveemployee";
  final String updateEmployeeCardRequest = _baseService + "/desactivateemployee";


  updateEmployeeCard(id) async{
    final fullUrl = securityApi.getUrl() + updateEmployeeCardRequest + "/$id";
    final String token = await securityApi.getToken();
    return http.put(
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

  saveEmployee(data) async{
    final fullUrl = securityApi.getUrl() + saveEmployeeRequest;
    final String token = await securityApi.getToken();
    return http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: securityApi.setHeadersWithToken(token)
    );
  }

}