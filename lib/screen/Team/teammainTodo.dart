import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:javis/api/myData.dart';
import 'package:javis/screen/main/mainscreen.dart';
import 'package:javis/screen/todo/createTodo.dart';
import '../../api/team/category_list.dart';
import '../../api/team/delTeamTodo.dart';
import '../../api/team/deleteTeam.dart';
import '../../api/team/getMyTeam.dart';
import '../../api/team/getTeamTodo.dart';
import '../../api/team/inviteTeam.dart';
import '../../api/team/teamHomepage.dart';
import '../../api/team/team_list.dart';
import '../../api/todo/category_list.dart';
import '../../api/todo/delLocation.dart';
import '../../api/todo/getLocation.dart';
import '../../api/todo/getMyTodo.dart';
import '../../api/todo/todo&&Category.dart';
import '../../api/users/getMyData.dart';
import '../../api/users/homepage.dart';
import '../../custom/bottomBar.dart';
import '../Calendar.dart';
import 'package:javis/screen/todo/CalenderAppbar.dart';
import 'package:javis/screen/todo/category_list.dart';

import 'createTeamTodo.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
List<dynamic> teamCategory = [];
List<Category> teamTodo = [];

class teamTodoApp extends StatefulWidget {
  final int team_id;

  const teamTodoApp({Key? key, required this.team_id}) : super(key: key);

  @override
  _CreateTodoAppState createState() => _CreateTodoAppState(team_id: team_id);
}

class _CreateTodoAppState extends State<teamTodoApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime today = DateTime.now();
  int _selectedIndex = 0;
  List<dynamic> team = [];
  final int team_id;
  List<dynamic> team_list = [];

  _CreateTodoAppState({required this.team_id});

  void _onItemTapped(int index) {
    // 바텀 네비게이션 아이템을 탭할 때마다 selectedIndex 변경
    setState(() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => Screen(selectedIndex: index)));
    });
  }

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
    team = await getTeamAllTodo(teamId: team_id);
    team_list = await getTeamList(team_id: team_id);
    // List<Map<String, dynamic>> teamData = await getMyTeam() ?? [];
    // List<dynamic> teamNames = [];

    // teamData에서 "name"만 추출하여 teamNames 리스트에 추가합니다.
    // teamData.forEach((team) {
    //   String? name = team['name']; // "name" 필드 추출
    //   if (name != null) {
    //     teamNames.add(name);
    //   }
    // });

    // 데이터가 변경되었음을 알려 화면을 다시 그리도록 함
    setState(() {
      team = team;
      team_list = team_list;
      // if (teamNames != Null) teamCategory = teamNames;
    });
  }

  void _showInviteDialog(BuildContext context) {
    TextEditingController _inviteCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('초대하고 싶은 유저 입력'),
          content: TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(
              hintText: '유저를 입력하세요',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                String inviteCode = _inviteCodeController.text;
                print('유저 입력: $inviteCode');
                // 여기에 초대코드를 사용하여 팀 가입 또는 정보 가져오는 로직 추가
                await inviteTeam(team_id,inviteCode);
                setState(() {
                  loadData();
                });
                //await joinTeam(inviteCode); // 예시: 초대코드를 사용하여 팀 가입
                Navigator.pop(context, true);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          // AppBar의 높이를 기본 높이로 지정
          child: SafeArea(
            child: AppBar(
              // AppBar의 나머지 설정은 그대로 유지
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () async {
                      // 메뉴 버튼 눌렀을 때 실행되는 코드 추가
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonBar(children: [
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          today = today.subtract(Duration(days: 1));
                        });
                      },
                      icon: Icon(Icons.arrow_back),
                    ),
                    TextButton(
                      onPressed: () async {
                        DateTime? fixdate =
                            await showDatePickerPop(today, context);
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
                      onPressed: () async {
                        setState(() {
                          today = today.add(Duration(days: 1));
                        });
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ]),
                ],
              ),
              // bottom: TabBar(
              //   controller: _tabController,
              //   tabs: CategoryList.tabs.map((tab) {
              //     return Tab(text: tab.label, icon: Icon(tab.icon));
              //   }).toList(),
              // ),
            ),
          ),
        ),

        drawer: SafeArea(
          child: Drawer(
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
                Divider(),
                // 다른 Drawer 항목 추가
                TextButton.icon(
                  onPressed: () async {
                    //초대 기능 넣어야함
                    _showInviteDialog(context);
                    //Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.insert_invitation,
                    color: Colors.black, // 아이콘 색상을 빨간색으로 지정
                    size: 30, // 아이콘 크기를 키웁니다.
                  ),
                  label: Text(
                    '초대',
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상을 빨간색으로 지정
                      fontWeight: FontWeight.bold, // 텍스트를 두껍게 설정
                      fontSize: 20, // 텍스트 크기를 키웁니다.
                    ),
                  ),
                ),
                Divider(),
                TextButton.icon(
                  onPressed: () async {

                    //Navigator.pop(context, true);
                  },
                  icon: Icon(
                    Icons.group,
                    color: Colors.black, // 아이콘 색상을 빨간색으로 지정
                    size: 30, // 아이콘 크기를 키웁니다.
                  ),
                  label: Text(
                    '참여자 목록',
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상을 빨간색으로 지정
                      fontWeight: FontWeight.bold, // 텍스트를 두껍게 설정
                      fontSize: 20, // 텍스트 크기를 키웁니다.
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: team_list.length,
                  itemBuilder: (context, index) {
                    return TextButton.icon(
                      onPressed: () async {
                        //await deleteMyTeam(team_id: team_id);
                        //Navigator.pop(context, true);
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.grey, // 아이콘 색상을 빨간색으로 지정
                      ),
                      label: Text(
                        '${team_list[index]}',
                        style: TextStyle(
                          color: Colors.grey, // 텍스트 색상을 빨간색으로 지정
                        ),
                      ),
                    );
                  },
                ),

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextButton.icon(
                        onPressed: () async {
                          await deleteMyTeam(team_id: team_id);
                          Navigator.pop(context, true);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red, // 아이콘 색상을 빨간색으로 지정
                        ),
                        label: Text(
                          '그룹 탈퇴',
                          style: TextStyle(
                            color: Colors.red, // 텍스트 색상을 빨간색으로 지정
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: ListView.builder(
          itemCount: team.length,
          itemBuilder: (context, index) {
            final category = team[index] as Map<String, dynamic>;
            //final categoryName = category['teamName'];
            //final todoList = category['teamTodoList'] as List<dynamic>;

            // 랜덤한 파스텔톤 색상 생성
            Color categoryColor = getRandomColor();
// 선택된 카테고리 여부를 확인하는 변수

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 현재 카테고리가 선택된 경우에만 보여줍니다.

                      // Text(
                      //   categoryName,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //     color: categoryColor, // 카테고리 색상 적용
                      //   ),
                      // ),
                      //SizedBox(height: 8.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          //final todo = category[index] as Map<String, dynamic>;
                          final title = category['title'] as String;
                          final startLine = category['startLine'] as String;
                          final deadLine = category['deadLine'] as String;

                          // 할 일의 시작 날짜와 마감 날짜를 DateTime으로 변환합니다.
                          DateTime parsedStartLine =
                              DateFormat('yyyy-MM-dd').parse(startLine);
                          DateTime parsedDeadLine =
                              DateFormat('yyyy-MM-dd').parse(deadLine);

                          // 현재 날짜의 시간을 00:00:00으로 설정합니다.
                          DateTime currentDate = today;
                          currentDate = DateTime(currentDate.year,
                              currentDate.month, currentDate.day);

                          // 현재 날짜가 시작 날짜와 마감 날짜 사이에 있는지 확인합니다.
                          bool isBetween =
                              currentDate.isAfter(parsedStartLine) &&
                                  currentDate.isBefore(parsedDeadLine);

                          // 현재 날짜가 시작 날짜와 마감 날짜 중 하나와 일치하거나 그 사이에 있는 경우에만 할 일을 생성합니다.
                          if (currentDate.isAtSameMomentAs(parsedStartLine) ||
                              currentDate.isAtSameMomentAs(parsedDeadLine) ||
                              isBetween) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ListTile(
                                title: Text(
                                  '- $title', // 할 일 목록을 '-'로 구분하여 표시
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: categoryColor, // 할 일 목록 글자색으로 구분
                                  ),
                                ),
                                onTap: () async {
                                  final int id = category['id'];
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
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FloatingActionButton(
            //   onPressed: () async {
            //     // Handle calendar icon button click
            //     DateTime? selectedDate = await showDatePicker(
            //       context: context,
            //       initialDate: today,
            //       firstDate: DateTime(2000),
            //       lastDate: DateTime(2101),
            //     );
            //     if (selectedDate != null) {
            //       setState(() {
            //         today = selectedDate;
            //       });
            //     }
            //   },
            //   backgroundColor: Colors.tealAccent, // Your preferred color
            //   elevation: 5,
            //   child: Icon(Icons.calendar_today),
            // ),
            //SizedBox(width: 16), // Add some spacing between the calendar button and the existing FAB
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => createTeamTodo(teamId:team_id,)),)
                    .then((value) => setState(() {
                  loadData();
                }));
              },
              backgroundColor: Colors.tealAccent,
              elevation: 5,
              child: Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: BottomBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
