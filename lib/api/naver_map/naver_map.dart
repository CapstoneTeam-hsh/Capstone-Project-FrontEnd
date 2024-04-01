import 'package:http/http.dart' as http;
import 'package:javis/api/naver_map/naver_key.dart';

Future<dynamic> naver_Map() async {
  try {
    final String URL = "https://naveropenapi.apigw.ntruss.com/map-static/v2/raster";
    final request = Uri.parse(URL);
    final response = await http.get(
      request,
      headers: naver_key,
    );
    if(response.statusCode==200){
      return response;
    }else throw new Exception(response.statusCode);
  }catch(e){
    print(e);
  }
}