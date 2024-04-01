import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getTeamAllTodo({
  required int teamId,
}) async {
  List<dynamic> resultData = [];
  try {
    final String URL = url+"teamTodo/$teamId";
    final request = Uri.parse(URL);

    final response = await http.get(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('get homepage : ${response.statusCode}');
    if (response.statusCode == 200) {
      //print(2);
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      resultData = responseData['result'];
      return resultData;
    } else {
      return resultData;
    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return resultData;
  }
}