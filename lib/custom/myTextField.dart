import 'package:flutter/material.dart';

/// 사용자 정의 textfield
///
/// - label : 필드에 어떤 정보를 입력해야하는지 설명하는 text
/// - obscure : 입력한 정보를 가리고 싶으면 true, 아니면 false
/// - myicon : 좌측 아이콘, default : null
/// - controller : 컨트롤러, default : null
///
/// 반환값 : textfield
Widget myTextFormField({
  required String label,
  bool obscure = false,
  dynamic? myicon = null,
  TextEditingController? controller,// 수정된 부분
  dynamic? error = null,
  Color? error_color = Colors.red,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(myicon),
      labelText: label,
      errorText: error,
      errorStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: error_color,
      ),
    ),
    obscureText: obscure,
  );
}