import 'package:flutter/material.dart';
import 'package:javis/screen/todo/CalenderAppbar.dart';
import '../../api/users/sign-up.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../../dto/errorDto.dart';

class createTodo extends StatelessWidget {
  const createTodo({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateTodoForm(),
      ),
    );
  }
}

class CreateTodoForm extends StatefulWidget {
  const CreateTodoForm({Key? key}) : super(key: key);
  @override
  State<CreateTodoForm> createState() => _CreateTodoFormState();
}

class _CreateTodoFormState extends State<CreateTodoForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  DateTime date = DateTime.now();

  Errordto error = Errordto();

  dynamic titleError;
  dynamic pwError;
  dynamic detailError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        myTextFormField(
          label: '제목',
          myicon: Icons.title,
          controller: titleController,
          error: titleError,
        ),
        SizedBox(height: 16.0),
        GestureDetector(
          onTap: () async{
            date = await showDatePickerPop(date,context);
            setState(() {
              //date = date;
            });
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8.0),
                Text(
                    "${date.year}-${date.month}-${date.day}"
                ),
              ],
            ),
          ),
        ),
        myTextFormField(
          label: '내용',
          myicon: Icons.subject,
          controller: detailController,
          error: detailError,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                //일단 임시로 돌아가는 버튼 만들어놓음
                Navigator.pop(context);
                //삭제하는 api사용해야함
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,  // 빨간색 아이콘
              ),
              color: Colors.redAccent,  // 파스텔톤 빨간색 배경
            ),
            IconButton(
              onPressed: () {
                // 체크 버튼을 눌렀을 때 수행할 작업
                //일단 임시로 돌아가는 버튼 만들어놓음
                Navigator.pop(context);
                //삭제하는 api사용해야함
              },
              icon: Icon(
                Icons.check,
                color: Colors.green,  // 초록색 아이콘
              ),
              color: Colors.greenAccent,  // 파스텔톤 초록 배경
            ),
          ],
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