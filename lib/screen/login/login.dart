import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import '../../api/users/getMyData.dart';
import '../../api/users/sign-in.dart';
import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../Background/backLocation.dart';
import 'signupscreen.dart';
import '../main/mainscreen.dart';
import 'package:javis/api/token.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();
  dynamic id_error = null;
  dynamic pw_error = null;
  Info info = Info();
  Errordto error = Errordto();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.blue, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Container(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Javis',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1,
                  fontSize: screenHeight * 0.15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              myTextFormField(
                label: "ID",
                myicon: Icons.person,
                controller: id,
                error: id_error,
                error_color: Colors.white,
              ),
              myTextFormField(
                label: "Password",
                myicon: Icons.lock,
                obscure: true,
                controller: password,
                error: pw_error,
                error_color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myButton(
                    text: "Sign up",
                    text_size: 12,
                    background_color: Colors.deepOrange[200], // 버튼 색상 수정
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => signupscreen()),
                      );
                    },
                  ),
                  myButton(
                    text: "Login",
                    text_size: 12,
                    background_color: Colors.deepOrange[200], // 버튼 색상 수정
                    onPressed: () async {
                      if (id.text.isEmpty || password.text.isEmpty) {
                        setState(() {
                          id_error = id.text.isEmpty ? "ID를 입력하세요" : null;
                          pw_error = password.text.isEmpty ? "PW를 입력하세요" : null;
                        });
                      } else {
                        dynamic waiting = await signin(
                          id: id.text,
                          pw: password.text,
                        );
                        if (waiting.runtimeType == Info) {
                          print("로그인 완료 : $token");
                          info = waiting;
                          getData();
                          // print("${info.id} ${info.uid}");
                          // print("${info.email} ");
                          // print("${info.name}");
                          startBackgroundLocationService();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const mainscreen()),
                          );
                        } else {
                          error = waiting;
                          setState(() {
                            id_error = error.details;
                            pw_error = error.message;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}