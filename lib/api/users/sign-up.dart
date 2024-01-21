import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';

Future<dynamic> signup({
  required String? id,
  required String? pw,
  required String? name,
  required String? email,
}) async {
  Errordto error = new Errordto();
  try {
    final String URL = "http://localhost:8080/users/sign-up";
    final request = Uri.parse(URL);

    Map<String, dynamic> requestBody = {
      "uid": "$id",
      "password": "$pw",
      "name": "$name",
      "email": "$email"
    };
    final response = await http.post(
        request,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      // 서버 응답에서 토큰 값을 추출하여 반환
      return true;
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      return error;
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return false;
  }
}