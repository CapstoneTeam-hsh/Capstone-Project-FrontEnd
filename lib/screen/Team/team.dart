import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:javis/screen/Team/teammainTodo.dart';

import '../../api/myData.dart';
import '../../api/team/createTodo.dart';
import '../../api/team/getMyTeam.dart';
import '../todo/category_list.dart';

class Team extends StatefulWidget {
  const Team({Key? key}) : super(key: key);

  @override
  _TeamState createState() => _TeamState();
}

class _TeamState extends State<Team> {
  List<Map<String, dynamic>>? data;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    // 데이터 가져오는 비동기 작업
    var fetchedData = await getMyTeam(loginId : id);
    setState(() {
      data = fetchedData;
    }); // 데이터가 변경되었음을 알림
  }

  void _showCreateGroupDialog(BuildContext context) {
    TextEditingController _groupNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹 생성'),
          content: TextField(
            controller: _groupNameController,
            decoration: InputDecoration(
              hintText: '그룹 이름을 입력하세요',
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
                groupName = _groupNameController.text;
                print('새로운 그룹 생성: $groupName');
                // 여기에 새로운 그룹을 생성하는 로직 추가
                await teamRegi(groupName);
                fetchData();
                Navigator.pop(context);
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
    return CupertinoApp(
      //title: 'Flutter Code Sample',
      home: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.group, color: Colors.black),
              SizedBox(width: 8),
              Text(
                '그룹 페이지',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (data != null && data!.isNotEmpty)
                for (var group in data!)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Group ${group['id']} 클릭');
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => teamTodoApp(team_id: group['id'])))
                            .then((value) => setState(() {
                              fetchData();
                        }));
                      },
                      child: Text(
                        group['name'],
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                // Text(
                //   '그룹이 없습니다.', // 또는 원하는 메시지를 표시
                //   style: TextStyle(fontSize: 16),
                // ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      _showCreateGroupDialog(context);
                      fetchData();
                    },
                    child: Text('그룹생성', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),

              if (data == null)
                CircularProgressIndicator(), // 데이터를 가져올 때까지 로딩 표시
            ],
          ),
        ),
      ),
    );
  }
}
