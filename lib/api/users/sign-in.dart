import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../token.dart';
import '../url.dart';

Future<dynamic> signin({
  required String id,
  required String pw,
}) async {
  Info info = new Info(id: -1);
  Errordto error = new Errordto();

  Map<String, dynamic> requestBody = {
    "loginId": "$id",
    "password": "$pw",
  };

  try {
    final String URL = url+"users/sign-in";
    final request = Uri.parse(URL);
    final response = await http.post(
      request,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      token = responseData['result']['accessToken'];
      print("로그인중 : $token");
      info = Info.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      return info;
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      return error;
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return info;
  }
}