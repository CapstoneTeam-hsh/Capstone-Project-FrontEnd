// category_list.dart 파일

import 'package:flutter/material.dart';

class CategoryList {
  static List<TabData> tabs = [
    TabData(label: 'All', icon: Icons.all_inclusive, color: Colors.blue),
    TabData(label: '공부', icon: Icons.book, color: Colors.green),
    TabData(label: '운동', icon: Icons.fitness_center, color: Colors.orange),
    TabData(label: '알바', icon: Icons.work, color: Colors.purple),
  ];
}

class TabData {
  final String label;
  final IconData icon;
  final Color color;

  TabData({required this.label, required this.icon, required this.color});
}