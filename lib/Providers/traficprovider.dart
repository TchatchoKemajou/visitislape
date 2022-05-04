import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:visitislape/Services/traficservice.dart';

class TraficProvider with ChangeNotifier{
  TraficService traficService = TraficService();

  Future<List<dynamic>> findAllTrafic(site) async{
    var res = await traficService.findAllTrafic(site);
    var body = json.decode(res.body);
    return body;
  }

  Future<List<dynamic>> findAllTraficByDay(site) async{
    var res = await traficService.findTraficOfDay(site);
    var body = json.decode(res.body);
    return body;
  }
}