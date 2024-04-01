import 'package:flutter/material.dart';

import '../api/users/sign-in.dart';
import '../dto/errorDto.dart';
import '../dto/signinDto.dart';
import '../screen/main/mainscreen.dart';

class LoginHandler {
  static Future<void> handleLogin({
    required TextEditingController id,
    required TextEditingController password,
    required Function setState,
    required BuildContext con,
  }) async {
    dynamic id_error = null;
    dynamic pw_error = null;

    Info info = Info();
    Errordto error = Errordto();

    if (id.text.isEmpty || password.text.isEmpty) {
      if (id.text.isEmpty) setState(() => id_error = "ID를 입력하세요");
      else setState(() => id_error = null);
      if (password.text.isEmpty) setState(() => pw_error = "PW를 입력하세요");
      else setState(() => pw_error = null);
    } else {
      dynamic waiting = await signin(
        id: id.text,
        pw: password.text,
      );
      if (waiting.runtimeType == Info) {
        info = waiting;
        print("${info.id} ${info.uid}");
        print("${info.email} ");
        print("${info.name}");
        Navigator.push(
          con,
          MaterialPageRoute(builder: (context) => const mainscreen()),
        );
      } else {
        error = waiting;
        setState(() => id_error = error.details);
        setState(() => pw_error = error.message);
      }
    }
  }
}