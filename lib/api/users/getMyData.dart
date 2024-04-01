import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../myData.dart';
import '../token.dart';
import '../url.dart';

Future<dynamic> getData() async {
  try {
    Errordto error = new Errordto();

    final String URL = url+"users";
    final request = Uri.parse(URL);
    final response = await http.get(
      request,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(1);
    if (response.statusCode == 200) {
      print(2);
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      print(2);
      //id = responseData['result']['id'];
      name = responseData['result']['name'];
      id = responseData['result']['loginId'];
      email = responseData['result']['email'];
      print("이름 : $name");
      print("id : $name");
      print("email : $name");
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      return error;
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
  }
}