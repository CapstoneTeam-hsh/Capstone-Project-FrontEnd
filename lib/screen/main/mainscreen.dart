import 'package:flutter/material.dart';
import 'package:javis/screen/main/page_list.dart';
import 'package:javis/custom/bottomBar.dart';

class mainscreen extends StatelessWidget {
  const mainscreen({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Screen(selectedIndex: 0,),
    );
  }
}

class Screen extends StatefulWidget {
  final int selectedIndex; // 인스턴스 변수로 변경

  const Screen({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _selectedIndex=0; // 인스턴스 변수로 변경
  final List<Widget> _widgetOptions = PageList.pages;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 selectedIndex 값에 따라 초기 페이지 설정
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    // 바텀 네비게이션 아이템을 탭할 때마다 selectedIndex 변경
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
