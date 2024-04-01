import 'dart:ui';

class Todo {
  final int todoId;
  final String title;
  final String contents;
  final bool completed;
  final String startLine;
  final String deadLine;

  Todo({
    required this.todoId,
    required this.title,
    required this.contents,
    required this.completed,
    required this.startLine,
    required this.deadLine,
  });
}
class groupTodo {
  final int teamTodoId;
  final String teamTodotitle;
  final String contents;
  final bool completed;
  final String startLine;
  final String deadLine;

  groupTodo({
    required this.teamTodoId,
    required this.teamTodotitle,
    required this.contents,
    required this.completed,
    required this.startLine,
    required this.deadLine,
  });
}
class groupCategory {
  final int teamId;
  final String teamName;
  final List<groupTodo> allTodoList;

  groupCategory({
    required this.teamId,
    required this.teamName,
    required this.allTodoList,
  });
}
class Category {
  final int categoryId;
  final String categoryName;
  final List<Todo> allTodoList;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.allTodoList,
  });
}

class Event {
  final DateTime date;
  final String title;
  final int eventId;
  final Color categoryColor; // 카테고리 색상 추가

  Event({required this.date, required this.title, required this.eventId, required this.categoryColor});
}
