import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

import '../token.dart';
import '../url.dart';
import 'package:http/http.dart' as http;

Future<dynamic> delMyCate(String category) async {
  try {
    final String URL = url+"category?categoryName=$category";
    final request = Uri.parse(URL);

    final response = await http.delete(
      request,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('삭제 중 : ${response.statusCode}');
    if (response.statusCode == 200) {
      print("카테고리 삭제가 되었습니다");
      //Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return true;
    } else {

    }
  } catch (e) {
    print("error : $e");
    // 예외가 발생한 경우 null 또는 다른 처리를 수행할 수 있음
    return false;
  }
}