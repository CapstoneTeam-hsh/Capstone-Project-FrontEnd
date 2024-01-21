import 'package:flutter/material.dart';

import '../api/users/sign-up.dart';
import '../custom/myButton.dart';
import '../custom/myTextField.dart';
import '../dto/errorDto.dart';

class signupscreen extends StatelessWidget {
  const signupscreen({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return signupScreen();
  }
}

class signupScreen extends StatefulWidget {
  const signupScreen({Key? key}) : super(key: key);

  @override
  State<signupScreen> createState() => _signupState();
}

class _signupState extends State<signupScreen> {
  TextEditingController id_con = TextEditingController();
  TextEditingController pw_con = TextEditingController();
  TextEditingController name_con = TextEditingController();
  TextEditingController email_con = TextEditingController();
  dynamic id_error = null;
  dynamic pw_error = null;
  dynamic name_error = null;
  dynamic email_error = null;

  Errordto error = new Errordto();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            myTextFormField(
              label : "ID",
              myicon: Icons.person,
              controller: id_con,
              error : id_error,
            ),
            myTextFormField(
              label : "PW",
              myicon: Icons.lock,
              controller: pw_con,
              error : pw_error,
            ),
            myTextFormField(
              label : "Name",
              myicon: Icons.account_circle,
              controller: name_con,
              error : name_error,
            ),
            myTextFormField(
              label : "Email",
              myicon: Icons.email,
              controller: email_con,
              error : email_error,
            ),
            myButton(
              text : "Sign up",
              text_size: 12,
              onPressed:() async {
                if(id_con.text.isEmpty||pw_con.text.isEmpty||name_con.text.isEmpty||email_con.text.isEmpty){
                  if(id_con.text.isEmpty) setState(() => id_error = "ID 입력하세요.");
                  else setState(() => id_error = null);
                  if(pw_con.text.isEmpty) setState(() => pw_error = "PW 입력하세요.");
                  else setState(() => pw_error = null);
                  if(name_con.text.isEmpty) setState(() => name_error = "Name 입력하세요.");
                  else setState(() => name_error = null);
                  if(email_con.text.isEmpty) setState(() => email_error = "Email 입력하세요.");
                  else setState(() => email_error = null);
                }else {
                  dynamic waiting = await signup(
                    id: id_con.text,
                    pw: pw_con.text,
                    name: name_con.text,
                    email: email_con.text,
                  );
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
              },
            ),
          ],
        ),
      ),
    );
  }
}