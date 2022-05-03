import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:visitislape/Services/authservice.dart';

class AuthProvider with ChangeNotifier{
  AuthService authService = AuthService();

  int? _siteId;
  String? _siteName;
  String? _siteActive;
  String? _siteCreateDate;

  int? _guardId;
  String? _guardFullName;
  String? _guardUserName;
  String? _guardIsActive;
  String? _guardCreateDate;
  String? _guardRole;
  String? _guardPassword;



  String? _siteRequestMessage;
  String? _guardRequestMessage;
  String? _token;


  String get token => _token!;

  set changeToken(String value) {
    _token = value;
    notifyListeners();
  }

  String get guardPassword => _guardPassword!;

  set changeGuardPassword(String value) {
    _guardPassword = value;
    notifyListeners();
  }

  String get siteRequestMessage => _siteRequestMessage!;

  set changeGiteRequestMessage(String value) {
    _siteRequestMessage = value;
    notifyListeners();
  }

  int get siteId => _siteId!;

  set changeSiteId(int value) {
    _siteId = value;
    notifyListeners();
  }

  String get siteName => _siteName!;

  set changeSiteName(String value) {
    _siteName = value;
    notifyListeners();
  }

  String get siteActive => _siteActive!;

  set changeSiteActive(String value) {
    _siteActive = value;
    notifyListeners();
  }

  String get siteCreateDate => _siteCreateDate!;

  set changeSiteCreateDate(String value) {
    _siteCreateDate = value;
    notifyListeners();
  }

  String get guardRole => _guardRole!;

  set changeGuardRole(String value) {
    _guardRole = value;
    notifyListeners();
  }

  String get guardCreateDate => _guardCreateDate!;

  set changeGuardCreateDate(String value) {
    _guardCreateDate = value;
    notifyListeners();
  }

  String get guardIsActive => _guardIsActive!;

  set changeGuardIsActive(String value) {
    _guardIsActive = value;
    notifyListeners();
  }

  String get guardUserName => _guardUserName!;

  set changeGuardUserName(String value) {
    _guardUserName = value;
    notifyListeners();
  }

  String get guardFullName => _guardFullName!;

  set changeGuardFullName(String value) {
    _guardFullName = value;
    notifyListeners();
  }

  int get guardId => _guardId!;

  set changeGuardId(int value) {
    _guardId = value;
    notifyListeners();
  }

  String get guardRequestMessage => _guardRequestMessage!;

  set changeGuardRequestMessage(String value) {
    _guardRequestMessage = value;
    notifyListeners();
  }

  Map<String, dynamic> toMapSite(){
    return {
      "siteNama": _siteName,
      "siteCreateDate": "",
      "siteIsActif": _siteActive
    };
  }

  Map<String, dynamic> toMapGuard(){
    return {
      "guardCreateDate": "",
      "guardFullName": _guardFullName,
      "guardUserName": _guardUserName,
      "guardIsActif": "active",
      "guardPassword": _guardPassword,
      "role": _guardRole
    };
  }

  Map<String, dynamic> toMapAuth(){
    return {
      "guardUserName": _guardUserName,
      "guardPassword": _guardPassword,
    };
  }

  createSite() async{
    print(toMapSite());
    var res = await authService.createSite(toMapSite());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeGiteRequestMessage = "success";
      _siteId = body['siteId'];
      notifyListeners();
    }else {
      changeGiteRequestMessage = "failed";
    }
  }

  createGuard() async{
    print(toMapGuard());
    var res = await authService.createGuard(toMapGuard());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeGuardRequestMessage = "success";
    }else {
      changeGuardRequestMessage = "failed";
    }
  }

  authGuard() async{
    print(toMapAuth());
    var res = await authService.authGuard(toMapAuth());
    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      changeGiteRequestMessage = "success";
      _token = body["accessToken"];
      _guardId = body["user"]['guardId'];
      notifyListeners();
    }else {
      changeGiteRequestMessage = "failed";
    }
  }
}