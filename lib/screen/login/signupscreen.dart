import 'package:flutter/material.dart';
import '../../api/users/sign-up.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../../dto/errorDto.dart';

class signupscreen extends StatelessWidget {
  const signupscreen({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Errordto error = Errordto();
  dynamic idError;
  dynamic pwError;
  dynamic nameError;
  dynamic emailError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        myTextFormField(
          label: 'ID',
          myicon: Icons.person,
          controller: idController,
          error: idError,
        ),
        myTextFormField(
          label: 'PW',
          myicon: Icons.lock,
          controller: pwController,
          error: pwError,
          obscure: true,
        ),
        myTextFormField(
          label: 'Name',
          myicon: Icons.account_circle,
          controller: nameController,
          error: nameError,
        ),
        myTextFormField(
          label: 'Email',
          myicon: Icons.email,
          controller: emailController,
          error: emailError,
        ),
        SizedBox(height: 20),
        myButton(
          text: 'Sign up',
          background_color: Colors.orangeAccent, // 버튼 색상 수정
          onPressed: () async {
            setState(() {
              idError = _validateField(idController.text, 'ID');
              pwError = _validateField(pwController.text, 'PW');
              nameError = _validateField(nameController.text, 'Name');
              emailError = _validateField(emailController.text, 'Email');
            });

            if (idError == null && pwError == null && nameError == null && emailError == null) {
              dynamic waiting = await signup(
                id: idController.text,
                pw: pwController.text,
                name: nameController.text,
                email: emailController.text,
              );

              if (waiting.runtimeType == bool) {
                Navigator.pop(context);
              } else {
                error = waiting;
                setState(() {
                  idError = error.message;
                  pwError = error.details;
                  nameError = error.message;
                  emailError = error.details;
                });
              }
            }
          },
        ),
      ],
    );
  }

  dynamic _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName 입력하세요.';
    }
    return null;
  }
}