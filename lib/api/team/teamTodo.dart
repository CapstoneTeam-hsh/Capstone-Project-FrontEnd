import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<dynamic> teamTodoRegi(
    String title,
    String contents,
    DateTime startLine,
    DateTime deadLine,
    int teamId,
    int locationId,
    ) async {
  try {
    final String URL = url+"teamTodo";
    final request = Uri.parse(URL);

    Map<String, dynamic> requestBody = {
      "title": "$title",
      "contents": "$contents",
      "startLine": "${startLine.year}-${startLine.month}-${startLine.day}",
      "deadLine": "${deadLine.year}-${deadLine.month}-${deadLine.day}",
      "teamId":teamId,
      "locationId": locationId,
    };
    // print("$title");
    // print("$contents");
    // print("${startLine.year}-${startLine.month}-${startLine.day}");
    // print("$locationId");
    final response = await http.post(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print("todo등록 성공");
      //Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return true;
    } else {
      print("todo등록 실패");
      return false;
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return 0;
  }
}