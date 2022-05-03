import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitislape/Services/employeeservice.dart';

class EmployeeProvider with ChangeNotifier{
  EmployeeService employeeService = EmployeeService();

  int? _empId;
  String? _empCode;
  String? _empMatricule;
  String? _empFullName;
  bool? _empEtatCarte;
  String? _requestMessage;


  String get requestMessage => _requestMessage!;

  set changeRequestMessage(String value) {
    _requestMessage = value;
    notifyListeners();
  }
  String get empCode => _empCode!;

  set changeEmpCode(String value) {
    _empCode = value;
  }

  int get empId => _empId!;

  set changeEmpId(int value) {
    _empId = value;
    notifyListeners();
  }
  String get empMatricule => _empMatricule!;

  set changeEmpMatricule(String value) {
    _empMatricule = value;
    notifyListeners();
  }

  String get empFullName => _empFullName!;

  set changeEmpFullName(String value) {
    _empFullName = value;
    notifyListeners();
  }

  bool get empEtatCarte => _empEtatCarte!;

  set changeEmpEtatCarte(bool value) {
    _empEtatCarte = value;
    notifyListeners();
  }

  Future<List<dynamic>> findAllEmployees() async{
    final res = await employeeService.findAllEmployees();
    var body = json.decode(res.body);
    return body;
  }

  updateEmployeeCard() async{
    final res = await employeeService.updateEmployeeCard(_empId);
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      print(json.decode(res.statusCode));
      changeRequestMessage = "failed";
    }
  }

  saveEmployee() async{
    final res = await employeeService.saveEmployee(tomapSave());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      changeRequestMessage = "failed";
    }
  }

  Map<String, dynamic> tomapSave(){
    return {
      "empMatricule": _empMatricule,
      "empCode": _empCode,
      "empFullName": _empFullName,
      "etatCarte": true
    };
  }
}