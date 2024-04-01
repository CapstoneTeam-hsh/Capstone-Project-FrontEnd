import 'package:flutter/material.dart';
import '../../api/myData.dart';
import '../../api/setting/putUser.dart';
import '../../api/users/sign-up.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../../dto/errorDto.dart';

class putscreen extends StatelessWidget {
  const putscreen({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
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
  TextEditingController idController = TextEditingController(text: id);
  TextEditingController pwController = TextEditingController();
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController emailController = TextEditingController(text: email);

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
              nameError = _validateField(nameController.text, 'Name');
              emailError = _validateField(emailController.text, 'Email');
            });

            if (idError == null  && nameError == null && emailError == null) {
              dynamic waiting = await putUser(
                id: idController.text,
                name: nameController.text,
                email: emailController.text,
              );

              if (waiting.runtimeType == bool) {
                Navigator.pop(context);
              } else {
                error = waiting;
                setState(() {
                  idError = error.message;
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