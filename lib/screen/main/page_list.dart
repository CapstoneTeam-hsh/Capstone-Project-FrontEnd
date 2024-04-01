import 'package:flutter/material.dart';
import 'package:javis/screen/todo/solomainTodo.dart';
import 'package:javis/screen/Calendar.dart';
import 'package:javis/screen/map/naver_Map.dart';
import 'package:javis/screen/Settings/Setting.dart';

import '../Team/team.dart';

class PageList {
  static final List<Widget> pages = <Widget>[
    CreateTodoApp(),
    //Calendar(),
    //naver_Map(),
    Team(),
    Setting(),
  ];
}