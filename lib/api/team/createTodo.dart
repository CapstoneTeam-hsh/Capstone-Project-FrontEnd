import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<dynamic> teamRegi(
    String name,
    ) async {
  try {
    final String URL = url + "teams/create";
    final request = Uri.parse(URL);

    Map<String, dynamic> requestBody = {
      "name": "$name",
    };

    final response = await http.post(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
    print('그룹 추가 시작 : ${response.statusCode}');
    if (response.statusCode == 201) {
      print('장소등록 중');
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      int locationId = responseData['result']['id']; // 변환
      print("장소등록 성공: $locationId");
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
