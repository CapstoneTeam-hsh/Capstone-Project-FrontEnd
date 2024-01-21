import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:javis/custom/myButton.dart';
import 'package:javis/custom/myTextField.dart';
import 'package:javis/dto/errorDto.dart';
import 'package:javis/screen/mainscreen.dart';
import 'package:javis/screen/signupscreen.dart';
import '../api/users/sign-in.dart';
import '../dto/signinDto.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        // appBar: AppBar(
        //   title: Text('Javis'),
        //   centerTitle: true,
        // ),
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
  TextEditingController password= TextEditingController();
  dynamic id_error = null;
  dynamic pw_error = null;
  Info info = new Info();
  Errordto error = new Errordto();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        margin: EdgeInsets.only(top:150),
        child: Column(
          children: [
            Center(
              child: Text('Javis',
                style: TextStyle(
                  color : Colors.white,
                  letterSpacing: 2,
                  fontSize: 200
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.white,width: 2)
              ),

              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(right: 200,left: 200,top:50),
              child: Column(
                children: [
                  myTextFormField(
                    label : "ID",
                    myicon: Icons.person,
                    controller: id,
                    error : id_error,
                  ),
                  myTextFormField(
                    label : "Password",
                    myicon: Icons.lock,
                    obscure: true,
                    controller: password,
                    error : pw_error,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myButton(
                          text : "Sign up",
                          text_size: 12,
                          onPressed:() async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => signupscreen()),
                            );
                          },
                        ),
                        myButton(
                          text : "Login",
                          text_size: 12,
                          onPressed:() async{
                            if (id.text.isEmpty || password.text.isEmpty) {
                              if (id.text.isEmpty) setState(() => id_error = "ID를 입력하세요");
                              else setState(() => id_error = null);
                              if (password.text.isEmpty) setState(() => pw_error = "PW를 입력하세요");
                              else setState(() => pw_error = null);
                            }else {
                              dynamic waiting = await signin(
                                id: id.text,
                                pw: password.text,
                              );
                              if(waiting.runtimeType==Info){
                                info = waiting;
                                print("${info.id} ${info.uid}");
                                print("${info.email} ");
                                print("${info.name}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const mainscreen()),
                                );
                              }else{
                                error = waiting;
                                setState(() => id_error = error.details);
                                setState(() => pw_error = error.message);
                              }
                            }
                          },
                        ),
                      ]
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}