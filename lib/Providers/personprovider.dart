import 'package:flutter/material.dart';
import 'package:visitislape/Services/personservice.dart';
import 'dart:convert';

class PersonProvider with ChangeNotifier{
  PersonService personService = PersonService();
  int? _personId;
  String? _code;
  String? _matricule;
  String? _firstName;
  String? _lastName;
  String? _domaine;
  bool? _statusCard;
  String? _personType;
  String? _requestMessage;


  String get personType => _personType!;

  set changePersonType(String value) {
    _personType = value;
    notifyListeners();
  }

  int get personId => _personId!;

  set changePersonId(int value) {
    _personId = value;
    notifyListeners();
  }

  String get code => _code!;

  set changeCode(String value) {
    _code = value;
    notifyListeners();
  }

  String get requestMessage => _requestMessage!;

  set changeRequestMessage(String value) {
    _requestMessage = value;
    notifyListeners();
  }

  bool get statusCard => _statusCard!;

  set changeStatusCard(bool value) {
    _statusCard = value;
    notifyListeners();
  }

  String get domaine => _domaine!;

  set changeDomaine(String value) {
    _domaine = value;
    notifyListeners();
  }

  String get lastName => _lastName!;

  set changeLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String get firstName => _firstName!;

  set changeFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String get matricule => _matricule!;

  set changeMatricule(String value) {
    _matricule = value;
    notifyListeners();
  }


  Map<String, dynamic> toMapPerson(){
    return {
      "matricule": _matricule,
      "code": _code,
      "firstName": _firstName,
      "lastName": _lastName,
      "domaine": _domaine,
      "personType": _personType,
      "statusCard": true
    };
  }

  Future<List<dynamic>> findAllStudent() async{
    final res = await personService.findAllStudent();
    return json.decode(res.body);
  }

  Future<List<dynamic>> findAllEmployees() async{
    final res = await personService.findAllEmployees();
    var body = json.decode(res.body);
    return body;
  }

  savePerson() async{
    final res = await personService.savePerson(toMapPerson());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      changeRequestMessage = "failed";
    }
  }

  updateCard() async{
    final res = await personService.updateCard(_personId);
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      print(json.decode(res.statusCode));
      changeRequestMessage = "failed";
    }
  }

}