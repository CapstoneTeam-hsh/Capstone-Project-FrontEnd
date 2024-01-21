
import 'package:flutter/material.dart';

Widget mybottom() {
  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.text_snippet),
        label: '나의 판매글',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: '홈',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: '마이페이지',
      ),
    ],
    currentIndex: _selectedIndex, // 지정 인덱스로 이동
    selectedItemColor: Colors.lightGreen,
    onTap: _onItemTapped, // 선언했던 onItemTapped
  )
}