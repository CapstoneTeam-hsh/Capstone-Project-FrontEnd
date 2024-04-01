import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<int> locationRegi(
    String name,
    double latitude,
    double longitude,
    ) async {
  try {
    final String URL = url + "location";
    final request = Uri.parse(URL);

    Map<String, dynamic> requestBody = {
      "name": "$name",
      "latitude": latitude,
      "longitude": longitude,
    };

    final response = await http.post(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
    print('장소 등록 결과 : ${response.statusCode}');
    if (response.statusCode == 201) {
      print('장소등록 중');
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      int locationId = responseData['result']['id']; // 변환
      print("장소id : $locationId");
      return locationId;
    } else {
      // 실패한 경우에 대한 처리
      return 0; // 혹은 다른 값으로 반환
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return 0;
  }
}
