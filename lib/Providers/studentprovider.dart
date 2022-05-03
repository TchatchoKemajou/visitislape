
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitislape/Services/studentservice.dart';

class StudentProvider with ChangeNotifier{
StudentServices studentServices = StudentServices();
  int? _studentId;
  String? _studentCode;
  String? _studentMat;
  String? _studentFullName;
  String? _studentSpecial;
  String? _studentNiveau;
  bool? _studentEtatCard;
  String? _requestMessage;


String get requestMessage => _requestMessage!;

set changeRequestMessage(String value) {
  _requestMessage = value;
  notifyListeners();
}

int get studentId => _studentId!;

  set changeStudentId(int value) {
    _studentId = value;
    notifyListeners();
  }

  String get studentCode => _studentCode!;

  set changeStudentCode(String value) {
    _studentCode = value;
    notifyListeners();
  }

  bool get studentEtatCard => _studentEtatCard!;

  set changeStudentEtatCard(bool value) {
    _studentEtatCard = value;
    notifyListeners();
  }

  String get studentNiveau => _studentNiveau!;

  set changeStudentNiveau(String value) {
    _studentNiveau = value;
    notifyListeners();
  }

  String get studentSpecial => _studentSpecial!;

  set changeStudentSpecial(String value) {
    _studentSpecial = value;
    notifyListeners();
  }

  String get studentFullName => _studentFullName!;

  set changeStudentFullName(String value) {
    _studentFullName = value;
    notifyListeners();
  }

  String get studentMat => _studentMat!;

  set changeStudentMat(String value) {
    _studentMat = value;
    notifyListeners();
  }

  Future<List<dynamic>> findAllStudent() async{
    final res = await studentServices.findAllStudent();
    return json.decode(res.body);
  }

  Map<String, dynamic> toMapStudent(){
    return {
      "etuMatricule": _studentMat,
      "etuCode": _studentCode,
      "etuFullName": _studentFullName,
      "specialite": _studentSpecial,
      "niveau": studentNiveau,
      "etatCarte": true
    };
  }

  saveStudent() async{
    final res = await studentServices.saveStudent(toMapStudent());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      changeRequestMessage = "failed";
    }
  }

  updateStudentCard() async{
    final res = await studentServices.updateStudentCard(_studentId);
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      print(json.decode(res.statusCode));
      changeRequestMessage = "failed";
    }
  }
}