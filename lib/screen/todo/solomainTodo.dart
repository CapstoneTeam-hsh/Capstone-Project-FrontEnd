import 'package:flutter/material.dart';
import 'package:javis/screen/todo/createTodo.dart';
import 'CalenderAppbar.dart';
import 'category_list.dart';

class CreateTodoApp extends StatefulWidget {
  @override
  _CreateTodoAppState createState() => _CreateTodoAppState();
}

class _CreateTodoAppState extends State<CreateTodoApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: CategoryList.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonBar(
                children: [
                  IconButton(
                    onPressed: () async{
                    setState(() {
                      today = today.subtract(Duration(days: 1));
                    });
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  TextButton(
                    onPressed: () async{
                      DateTime? fixdate = await showDatePickerPop(today,context);
                      setState(() {
                        if(fixdate.runtimeType==DateTime){
                          today = fixdate as DateTime;
                        }
                      });
                    },
                    child: Text(
                      "${today.day}",
                      key: ValueKey(today),
                    ),
                  ),
                  IconButton(
                    onPressed: () async{
                      setState(() {
                        today = today.add(Duration(days: 1));
                      });
                    },
                    icon: Icon(Icons.arrow_forward),
                  ),
                ]
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: CategoryList.tabs.map((tab) {
              return Tab(text: tab.label, icon: Icon(tab.icon));
            }).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: CategoryList.tabs.map((tab) {
            return TabPage(title: tab.label, color: tab.color);
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => createTodo()),
            );
          },
          backgroundColor: Colors.tealAccent,  // 파스텔톤 민트색 배경
          elevation: 5,  // 그림자 효과 정도
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final String title;
  final Color color;

  const TabPage({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 20),
        Text(
          '내용을 입력할 수 있는 공간',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}