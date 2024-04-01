import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:javis/api/todo/todo&&Category.dart';

import '../../dto/signinDto.dart';
import '../../dto/errorDto.dart';
import '../myData.dart';
import '../token.dart';
import '../url.dart';

Future<dynamic> delTeamTodo(
    int todoId,
    ) async {
  try {
    Errordto error = new Errordto();

    final String URL = url+"teamTodo/$todoId";
    final request = Uri.parse(URL);
    final response = await http.delete(
      request,
      headers: {
        'Content-Type': 'application/json',
        //'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      Map<String, dynamic> categories = responseData['result'];
      return true;
    } else {
      error = Errordto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      print("로그인 실패 : ${error.message} ${error.details}");
      return ; // 실패 시 빈 리스트 반환
    }
  } catch (e) {
    print("error : $e");
    return ; // 예외 발생 시 빈 리스트 반환
  }
}

List<Category> extractCategories(Map<String, dynamic> responseData) {
  List<Category> categories = [];

  List<dynamic> results = responseData['result'];
  results.forEach((result) {
    int categoryId = result['categoryId'];
    String categoryName = result['categoryName'];

    List<Todo> allTodoList = [];
    List<dynamic> todoList = result['allTodoList'];
    todoList.forEach((todoData) {
      int todoId = todoData['todoId'];
      String title = todoData['title'];
      String contents = todoData['contents'];
      bool completed = todoData['completed'];
      String startLine = todoData['startLine'];
      String deadLine = todoData['deadLine'];

      Todo todo = Todo(
        todoId: todoId,
        title: title,
        contents: contents,
        completed: completed,
        startLine: startLine,
        deadLine: deadLine,
      );
      allTodoList.add(todo);
    });

    Category category = Category(
      categoryId: categoryId,
      categoryName: categoryName,
      allTodoList: allTodoList,
    );
    categories.add(category);
  });

  return categories;
}


