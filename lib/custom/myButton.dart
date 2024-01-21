import 'package:flutter/material.dart';

/// 버튼을 생성하는 함수입니다.
///
/// - text: 표시 할 텍스트, 기본값 : "click"
/// - text_size: 텍스트의 크기, 기본값 : 12
/// - onPressed: 클릭 시 수행될 콜백 함수
/// - buttonWidth: 버튼의 너비, 기본값 : null
/// - buttonHeight: 버튼의 높이, 기본값은 null
/// - background_color: 버튼의 배경색, 기본값 : Colors.blue
/// - text_color: 텍스트의 색상, 기본값 : Colors.white
///
/// 반환값: 생성된 버튼 위젯입니다.
Widget myButton({
  String? text = "click", // 버튼 안에 넣을 텍스트
  double? text_size = 12,
  required VoidCallback onPressed,
  double? buttonWidth, // 사용자가 버튼의 너비를 설정할 수 있도록 추가
  double? buttonHeight, // 사용자가 버튼의 높이를 설정할 수 있도록 추가
  dynamic? background_color = Colors.blue,
  dynamic? text_color = Colors.white,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Container(
      width: buttonWidth, // 버튼의 너비 설정
      height: buttonHeight, // 버튼의 높이 설정
      child: Center(
        child: Text(
          text!,
          style: TextStyle(fontSize: text_size!),
        ),
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: background_color, // 버튼 배경색
      onPrimary: text_color, // 텍스트 색상
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 둥근 모서리 설정
      ),
    ),
  );
}