import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:javis/api/todo/todo&&Category.dart';

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../myData.dart';
import '../token.dart';
import '../url.dart';

Future<List<dynamic>> getLocation({
  required double latitude,
  required double longitude,
  }) async {
  try {
    Errordto error = new Errordto();

    final String URL = url+"location?latitude=$latitude&longitude=$longitude";
    final request = Uri.parse(URL);
    final response = await http.get(
      request,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print("좌표 받아오는중 ~");
    if (response.statusCode == 200) {
      print("좌표 받아오기 성공 ~");
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> categories = responseData['result']; // 요소가 없을 경우 빈 리스트 반환
      print("좌표 보내기전~");
      return categories;
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      return []; // 실패 시 빈 리스트 반환
    }
  } catch (e) {
    print("error : $e");
    return []; // 예외 발생 시 빈 리스트 반환
  }
}


