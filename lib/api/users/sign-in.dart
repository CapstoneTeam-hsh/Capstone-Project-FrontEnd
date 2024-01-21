import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';

Future<dynamic> signin({
  required String id,
  required String pw,
}) async {
  Info info = new Info(id: -1);
  Errordto error = new Errordto();
  try {
    final String URL = "http://localhost:8080/users/sign-in?uid=" + id +
        "&password=" + pw;
    final request = Uri.parse(URL);
    final response = await http.post(request,);

    if (response.statusCode == 200) {
      // 서버 응답에서 토큰 값을 추출하여 반환
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