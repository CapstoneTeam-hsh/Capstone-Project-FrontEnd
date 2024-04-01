import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../myData.dart';
import '../token.dart';
import '../url.dart';

Future<dynamic> deleteMyTeam({
  required int team_id,
}) async {
  try {
    Errordto error = new Errordto();
    //List<Map<String, dynamic>> my_result = [];
    final String URL = url+"teams/$team_id";
    final request = Uri.parse(URL);
    final response = await http.delete(
      request,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("team 삭제 시작");
    print("delete team : ${response.statusCode}");
    if (response.statusCode == 200) {
      print("team 삭제 성공");
      //Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      //id = responseData['result']['id'];
      //my_result = List<Map<String, dynamic>>.from(responseData['result']); // 데이터 형식을 List<Map<String, dynamic>>으로 변환
      return true;
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      throw Exception("로그인 실패 : ${error.message} ${error.details}"); // 예외를 다시 던짐
    }
  } catch (e) {
    print("error : $e");
    throw e; // 예외를 다시 던짐
  }
}