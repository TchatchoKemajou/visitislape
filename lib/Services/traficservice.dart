import 'package:http/http.dart' as http;
import 'package:visitislape/API/securityapi.dart';

class TraficService{
  SecurityApi securityApi = SecurityApi();
  static const String _baseService = "trafic";

  final String traficDayRequest = _baseService + "/alltraficofday";

  final String allTraficRequest = _baseService + "/alltrafic";


  findTraficOfDay(site) async{
    final fullUrl = securityApi.getUrl() + traficDayRequest + "/$site";
    String token = await securityApi.getToken();

    return http.get(
      Uri.parse(fullUrl),
      headers: securityApi.setHeadersWithToken(token)
    );
  }
  findAllTrafic(site) async{
    final fullUrl = securityApi.getUrl() + allTraficRequest + "/$site";
    String token = await securityApi.getToken();

    return http.get(
        Uri.parse(fullUrl),
        headers: securityApi.setHeadersWithToken(token)
    );
  }
}