// signup_handler.dart

import 'package:flutter/material.dart'; // context 사용을 위해 추가
import '../../api/users/sign-up.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../../dto/errorDto.dart';

class SignupHandler {
  static void handleSignup({
    required BuildContext context,
    required String id,
    required String pw,
    required String name,
    required String email,
    required Function setState,
  }) async {
    dynamic waiting = await signup(
      id: id,
      pw: pw,
      name: name,
      email: email,
    );

    Errordto error = Errordto();
    dynamic id_error = null; // id_error 추가
    dynamic pw_error = null; // pw_error 추가
    dynamic name_error = null; // name_error 추가
    dynamic email_error = null; // email_error 추가

    if (waiting.runtimeType == bool) {
      Navigator.pop(context);
    } else {
      error = waiting;
      setState(() => id_error = error.message);
      setState(() => pw_error = error.details);
      setState(() => name_error = error.message);
      setState(() => email_error = error.details);
    }
  }
}