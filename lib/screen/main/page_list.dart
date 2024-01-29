import 'package:flutter/material.dart';
import 'package:javis/screen/todo/solomainTodo.dart';
import 'package:javis/screen/one.dart';
import 'package:javis/screen/two.dart';
import 'package:javis/screen/three.dart';

class PageList {
  static final List<Widget> pages = <Widget>[
    CreateTodoApp(),
    one(),
    two(),
    three(),
  ];
}