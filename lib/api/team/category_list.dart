import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getTeamCate() async {
  try {
    final String URL = url+"users/homepage/team";
    final request = Uri.parse(URL);

    final response = await http.get(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      print(2);
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData['result'];
    } else {

    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return false;
  }
}