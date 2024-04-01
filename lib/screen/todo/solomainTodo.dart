import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:javis/api/myData.dart';
import 'package:javis/screen/main/mainscreen.dart';
import 'package:javis/screen/todo/createTodo.dart';
import '../../api/team/category_list.dart';
import '../../api/team/delTeamTodo.dart';
import '../../api/team/getMyTeam.dart';
import '../../api/team/getTeamTodo.dart';
import '../../api/todo/category_list.dart';
import '../../api/todo/delLocation.dart';
import '../../api/todo/delTodo.dart';
import '../../api/todo/getLocation.dart';
import '../../api/todo/getMyTodo.dart';
import '../../api/todo/getTodo.dart';
import '../../api/todo/todo&&Category.dart';

import '../../api/users/getMyData.dart';
import '../../api/users/homepage.dart';
import '../Calendar.dart';
import '../Team/createTeamTodo.dart';
import 'CalenderAppbar.dart';
import 'category_list.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
List<dynamic> myCategory = [];
List<Category> myTodo = [];
List<dynamic> teamCategory = [];
List<Category> teamTodo = [];
Set<String> selectedCategories = Set();
Set<String> selectedTeamCategories = Set();

class CreateTodoApp extends StatefulWidget {
  String? mydate;
  @override
  _CreateTodoAppState createState() => _CreateTodoAppState(this.mydate);
}

class _CreateTodoAppState extends State<CreateTodoApp>
    with SingleTickerProviderStateMixin {

  String? mydate;
  _CreateTodoAppState(this.mydate);

  late TabController _tabController;
  DateTime today = DateTime.now();
  int _counter = 0;
  List<dynamic> data = [];
  List<dynamic> team = [];

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // 빨강(R)
      random.nextInt(256), // 녹색(G)
      random.nextInt(256), // 파랑(B)
      1, // 불투명도 (0.0에서 1.0 사이)
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: CategoryList.tabs.length, vsync: this);
    loadData(); // 데이터를 가져오는 함수 호출
  }

  // 데이터를 가져오는 함수
  void loadData() async {
    // 데이터를 가져오는 비동기 작업
    data = await getHomepage();
    team = await getTeamCate();
    List<dynamic> categoryData = await getMyCate() ?? [];
    List<Category> getMyTodoData = await getMyTodo() ?? [];
    List<Map<String, dynamic>> teamData = await getMyTeam(loginId: id) ?? [];
    List<dynamic> teamNames = [];

    // teamData에서 "name"만 추출하여 teamNames 리스트에 추가합니다.
    teamData.forEach((team) {
      String? name = team['name']; // "name" 필드 추출
      if (name != null) {
        teamNames.add(name);
      }
    });

    // 데이터가 변경되었음을 알려 화면을 다시 그리도록 함
    setState(() {
      data = data;
      team = team;
      if (categoryData != Null) myCategory = categoryData;
      if (getMyTodoData != Null) myTodo = getMyTodoData;
      if (teamNames != Null) teamCategory = teamNames;

      myCategory.forEach((category) {
        selectedCategories.add(category);
      });
      teamCategory.forEach((category) {
        selectedTeamCategories.add(category);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //key: _scaffoldKey,
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                 Scaffold.of(context).openDrawer();
                //_scaffoldKey.currentState!.openDrawer();
              },
            );
          }),
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonBar(children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      today = today.subtract(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                TextButton(
                  onPressed: () async {
                    DateTime? fixdate = await showDatePickerPop(today, context);
                    setState(() {
                      if (fixdate.runtimeType == DateTime) {
                        today = fixdate as DateTime;
                      }
                    });
                  },
                  child: Text(
                    "${today.year} / ${today.month} / ${today.day}",
                    key: ValueKey(today),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      today = today.add(Duration(days: 1));
                    });
                  },
                  icon: Icon(Icons.arrow_forward),
                ),
              ]),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.account_circle,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      child: Text(
                        '$name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => Screen(selectedIndex: 2)));
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (myCategory != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: myCategory.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        String selectedCategory = myCategory[index];
                        setState(() {
                          if (selectedCategories.contains(selectedCategory)) {
                            selectedCategories.remove(selectedCategory);
                          } else {
                            selectedCategories.add(selectedCategory);
                          }
                          _counter++;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            selectedCategories.contains(myCategory[index])
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      child: Text(myCategory[index]),
                    );
                  },
                ),
              if (teamCategory != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: teamCategory.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        String selectedCategory = teamCategory[index];
                        setState(() {
                          if (selectedTeamCategories
                              .contains(selectedCategory)) {
                            selectedTeamCategories.remove(selectedCategory);
                          } else {
                            selectedTeamCategories.add(selectedCategory);
                          }
                          _counter++;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            selectedTeamCategories.contains(teamCategory[index])
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      child: Text(teamCategory[index]),
                    );
                  },
                ),
              Divider(),
              ListTile(
                title: Text('캘린더'),
                leading: Icon(Icons.calendar_today),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Calendar(categoryData: myCategory, myTodo: myTodo)),
                  ).then((selectedDate) {
                    if (selectedDate != null &&
                        selectedDate.runtimeType == DateTime) {
                      DateTime utcDateTime = selectedDate;
                      DateTime localDateTime = utcDateTime.toLocal();
                      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(localDateTime);

                      setState(() {
                        today = localDateTime;
                      });
                      // Drawer를 닫기 위해 아래 코드를 추가합니다.
                      //_scaffoldKey.currentState?.closeDrawer();
                    }
                  });
                  setState(() {

                  });
                  _counter++;
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // data에 대한 ListView
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final category = data[index] as Map<String, dynamic>;
                final categoryName = category['categoryName'];
                final todoList = category['todoList'] as List<dynamic>;
                //print("data num : ${todoList}");
                // 랜덤한 파스텔톤 색상 생성
                Color categoryColor = getRandomColor();
                // 선택된 카테고리 여부를 확인하는 변수
                bool isSelectedCategory = selectedCategories.contains(categoryName);

                // 선택된 카테고리가 없는 경우 공백을 반환하여 렌더링하지 않음
                if (!isSelectedCategory) {
                  return SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 현재 카테고리가 선택된 경우에만 보여줍니다.
                            if (selectedCategories.contains(categoryName))
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: categoryColor, // 카테고리 색상 적용
                                ),
                              ),
                            //SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: todoList.length,
                              itemBuilder: (context, todoIndex) {
                                final todo = todoList[todoIndex] as Map<String, dynamic>;
                                final title = todo['title'] as String;
                                final startLine = todo['startLine'] as String;
                                final deadLine = todo['deadLine'] as String;
                                //print("todo num :${todoIndex} , todo len : ${todoList.length}");
                                // 할 일의 시작 날짜와 마감 날짜를 DateTime으로 변환합니다.
                                DateTime parsedStartLine = DateFormat('yyyy-MM-dd').parse(startLine);
                                DateTime parsedDeadLine = DateFormat('yyyy-MM-dd').parse(deadLine);

                                // 현재 날짜의 시간을 00:00:00으로 설정합니다.
                                DateTime currentDate = today;
                                currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

                                // 현재 날짜가 시작 날짜와 마감 날짜 사이에 있는지 확인합니다.
                                bool isBetween = currentDate.isAfter(parsedStartLine) && currentDate.isBefore(parsedDeadLine);

                                if (isSelectedCategory) {
                                  // 현재 날짜가 시작 날짜와 마감 날짜 중 하나와 일치하거나 그 사이에 있는 경우에만 할 일을 생성합니다.
                                  if (currentDate.isAtSameMomentAs(parsedStartLine) ||
                                      currentDate.isAtSameMomentAs(parsedDeadLine) ||
                                      isBetween) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: ListTile(
                                        title: Text(
                                          '- $title', // 할 일 목록을 '-'로 구분하여 표시
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: categoryColor, // 할 일 목록 글자색으로 구분
                                          ),
                                        ),
                                        onTap: () async {
                                          final int id = todo['todoId'];
                                          Map<String,dynamic> mytodo = await getTodo(id);
                                          final int locationId = mytodo['locationId'];
                                          Map<String,dynamic> mylocation = await getLocation(locationId);
                                          //await delTodo(id);
                                          await delLocation(locationId);
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => createTodo(
                                                  myTitle : mytodo['title'],
                                                  myDetail : mytodo['contents'],
                                                  myStart : mytodo['startLine'],
                                                  myEnd : mytodo['deadLine'],
                                                  myCP : categoryName,
                                                  myLocation : mylocation['name'],
                                                  myLongitude : mylocation['longitude'],
                                                  myLatitude : mylocation['latitude'],
                                              )))
                                              .then((value) => setState(() {
                                            loadData();
                                          }));
                                        },
                                      ),
                                    );
                                  }
                                }
                                return SizedBox.shrink(); // 아무 것도 보이지 않도록 빈 컨테이너 반환
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            // team에 대한 ListView
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: team.length,
              itemBuilder: (context, index) {
                final category = team[index] as Map<String, dynamic>;
                final categoryName = category['teamName'];
                final todoList = category['teamTodoList'] as List<dynamic>;

                // 랜덤한 파스텔톤 색상 생성
                Color categoryColor = getRandomColor();
                // 선택된 카테고리 여부를 확인하는 변수
                bool isSelectedCategory = selectedTeamCategories.contains(categoryName);

                // 선택된 카테고리가 없는 경우 공백을 반환하여 렌더링하지 않음
                if (!isSelectedCategory) {
                  return SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 현재 카테고리가 선택된 경우에만 보여줍니다.
                            if (selectedTeamCategories.contains(categoryName))
                              Text(
                                categoryName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: categoryColor, // 카테고리 색상 적용
                                ),
                              ),
                            //SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: todoList.length,
                              itemBuilder: (context, teamIndex) {
                                final todo = todoList[teamIndex] as Map<String, dynamic>;
                                final title = todo['teamTodoTitle'] as String;
                                final startLine = todo['startLine'] as String;
                                final deadLine = todo['deadLine'] as String;

                                // 할 일의 시작 날짜와 마감 날짜를 DateTime으로 변환합니다.
                                DateTime parsedStartLine = DateFormat('yyyy-MM-dd').parse(startLine);
                                DateTime parsedDeadLine = DateFormat('yyyy-MM-dd').parse(deadLine);

                                // 현재 날짜의 시간을 00:00:00으로 설정합니다.
                                DateTime currentDate = today;
                                currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

                                // 현재 날짜가 시작 날짜와 마감 날짜 사이에 있는지 확인합니다.
                                bool isBetween = currentDate.isAfter(parsedStartLine) && currentDate.isBefore(parsedDeadLine);

                                if (isSelectedCategory) {
                                  // 현재 날짜가 시작 날짜와 마감 날짜 중 하나와 일치하거나 그 사이에 있는 경우에만 할 일을 생성합니다.
                                  if (currentDate.isAtSameMomentAs(parsedStartLine) ||
                                      currentDate.isAtSameMomentAs(parsedDeadLine) ||
                                      isBetween) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: ListTile(
                                        title: Text(
                                          '- $title', // 할 일 목록을 '-'로 구분하여 표시
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: categoryColor, // 할 일 목록 글자색으로 구분
                                          ),
                                        ),
                                        onTap: () async {
                                          final int id = todo['teamTodoId'];
                                          Map<String,dynamic> mytodo = await getTeamTodo(id);
                                          final int locationId = mytodo['locationId'];
                                          Map<String,dynamic> mylocation = await getLocation(locationId);
                                          //await delTeamTodo(id);
                                          await delLocation(locationId);
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => createTeamTodo(
                                                myTitle : mytodo['title'],
                                                myDetail : mytodo['contents'],
                                                myStart : mytodo['startLine'],
                                                myEnd : mytodo['deadLine'],
                                                myLocation : mylocation['name'],
                                                myLongitude : mylocation['longitude'],
                                                myLatitude : mylocation['latitude'],
                                                teamId: category['teamId'],
                                              )))
                                              .then((value) => setState(() {
                                            loadData();
                                          }));
                                        },
                                      ),
                                    );
                                  }
                                }
                                return SizedBox.shrink(); // 아무 것도 보이지 않도록 빈 컨테이너 반환
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => createTodo()))
                .then((value) => setState(() {
                      loadData();
                    }));
          },
          backgroundColor: Colors.tealAccent,
          elevation: 5,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
