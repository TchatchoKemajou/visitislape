
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitislape/Services/visitorservice.dart';

class VisitorProvider  with ChangeNotifier{
  VisitorService visitorService = VisitorService();

  double? _visitorId;
  String? _visitorFullName;
  String? _visitorLastName;
  String? _visitorCardId;
  String? _visitorNumber;

  String? _requestMessage;


  double get visitorId => _visitorId!;

  set visitorId(double value) {
    _visitorId = value;
    notifyListeners();
  }

  String get visitorFullName => _visitorFullName!;

  set changeVisitorFullName(String value) {
    _visitorFullName = value;
    notifyListeners();
  }

  String get visitorLastName => _visitorLastName!;

  set changeVisitorLastName(String value) {
    _visitorLastName = value;
    notifyListeners();
  }

  String get visitorCardId => _visitorCardId!;

  set changeVisitorCardId(String value) {
    _visitorCardId = value;
    notifyListeners();
  }

  String get visitorNumber => _visitorNumber!;

  set changeVisitorNumber(String value) {
    _visitorNumber = value;
    notifyListeners();
  }


  String get requestMessage => _requestMessage!;

  set changeRequestMessage(String value) {
    _requestMessage = value;
    notifyListeners();
  }

  Future<List<dynamic>> findAllVisitor() async{
    var res = await visitorService.findAllVisitor();
    var body = json.decode(res.body);

    return body;
  }

  saveVisitor() async{
    print(toMapSaveVisitor());
    var res = await visitorService.saveVisitor(toMapSaveVisitor());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else{
      print(json.decode(res.statusCode));
      changeRequestMessage = "failed";
    }
  }


  Map<String, dynamic> toMapSaveVisitor(){
    return {
      "visitorFullName": _visitorFullName,
      "vistorLastName": _visitorLastName ?? "",
      "visitorCardId": _visitorCardId,
      "visitorNumber": _visitorNumber
    };
  }
}