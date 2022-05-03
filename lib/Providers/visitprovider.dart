
import 'package:flutter/material.dart';
import 'package:visitislape/Services/visitservice.dart';
import 'dart:convert';

class VisitProvider with ChangeNotifier{
  VisitService visitService = VisitService();

  int? _visitId;
  int? _visitorId;
  int? _siteId;
  int? _guardId;
  String? _visitDate;
  String? _visitTimeStart;
  String? _visitTimeEnd;
  String? _visitStatus;
  String? _visitDescription;
  String? _visitHost;
  String? _visitTempCard;
  String? _requestMessage;


  String get requestMessage => _requestMessage!;

  set changeRequestMessage(String value) {
    _requestMessage = value;
    notifyListeners();
  }

  int get visitId => _visitId!;

  set changeVisitId(int value) {
    _visitId = value;
    notifyListeners();
  }

  int get visitorId => _visitorId!;

  set changeVisitorId(int value) {
    _visitorId = value;
    notifyListeners();
  }

  int get siteId => _siteId!;

  set changeSiteId(int value) {
    _siteId = value;
    notifyListeners();
  }

  int get guardId => _guardId!;

  set changeGuardId(int value) {
    _guardId = value;
    notifyListeners();
  }

  String get visitDate => _visitDate!;

  set changeVisitDate(String value) {
    _visitDate = value;
    notifyListeners();
  }

  String get visitTimeStart => _visitTimeStart!;

  set changeVisitTimeStart(String value) {
    _visitTimeStart = value;
    notifyListeners();
  }

  String get visitTimeEnd => _visitTimeEnd!;

  set changeVisitTimeEnd(String value) {
    _visitTimeEnd = value;
    notifyListeners();
  }

  String get visitStatus => _visitStatus!;

  set changeVisitStatus(String value) {
    _visitStatus = value;
    notifyListeners();
  }

  String get visitDescription => _visitDescription!;

  set changeVisitDescription(String value) {
    _visitDescription = value;
    notifyListeners();
  }

  String get visitHost => _visitHost!;

  set changeVisitHost(String value) {
    _visitHost = value;
    notifyListeners();
  }

  String get visitTempCard => _visitTempCard!;

  set changeVisitTempCard(String value) {
    _visitTempCard = value;
    notifyListeners();
  }

  downloadPdf() async{
    final res = await visitService.downloadPdf();
    print(res.statusCode);
  }

  Future<List<dynamic>> findAllVisitOfDay() async{
    var res = await visitService.findVisitOfDay();
    var body = json.decode(res.body);
    return body;
  }

  Future<List<dynamic>> findAllVisit() async{
    var res = await visitService.findAllVisite();
    var body = json.decode(res.body);
    return body;
  }

  saveVisit() async{
    var res = await visitService.saveViSite(toMapSaveVisit());

    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      if(body["visitId"] == null){
        changeRequestMessage = "impossible";
      }else{
        changeRequestMessage = "success";
      }
    }else {
      changeRequestMessage = "failed";
    }
  }

  saveAttente() async{
    var res = await visitService.saveAttente(toMapSaveVisit());

    var body = json.decode(res.body);

    if(res.statusCode.toString() == "200"){
      if(body["visitId"] == null){
        changeRequestMessage = "impossible";
      }else{
        changeRequestMessage = "success";
      }
    }else {
      changeRequestMessage = "failed";
    }
  }

  endVisit() async{
    var res = await visitService.endVisit(_visitId);

    var body = json.decode(res.body);
    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else {
      changeRequestMessage = "failed";
    }
  }

  startVisit() async{
    var res = await visitService.startVisite(_visitId);

    var body = json.decode(res.body);
    if(res.statusCode.toString() == "200"){
      changeRequestMessage = "success";
    }else {
      changeRequestMessage = "failed";
    }
  }

  Map<String, dynamic> toMapSaveVisit(){
    return {
      "visitId":_visitId,
      "visitorId": _visitorId,
      "guardID": _guardId,
      "visitSite": _siteId,
      "visitStatut": _visitStatus,
      "visitHost": _visitHost,
      "visitCarteTemp": _visitTempCard ?? "",
      "visitDescription": _visitDescription
    };
  }
}