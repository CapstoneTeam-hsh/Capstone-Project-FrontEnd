import 'package:flutter/material.dart';
import 'package:javis/screen/Settings/userUpdate.dart';

import '../../api/myData.dart';
import '../../api/setting/putUser.dart';
import '../../api/setting/updatePassword.dart';
import '../../api/todo/category_list.dart';
import '../todo/my_category_list.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  void _showInviteDialog(BuildContext context) {
    TextEditingController _inviteCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 변경'),
          content: TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(
              hintText: '비밀번호 변경하세요',
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
                String password = _inviteCodeController.text;
                print('비밀번호 입력: $password');
                await updatePassword(password: password);
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
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 8),
              Text(
                "$name",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => putscreen(),
                      ),
                    );
                  },
                  child: Text('마이페이지', style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _showInviteDialog(context);
                  },
                  child: Text('비밀번호 변경', style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    List<dynamic> my_category = await getMyCate() as List<dynamic>;

                    String selectedValue = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCate(myCategory: my_category),
                      ),
                    );
                  },
                  child: Text('카테고리 관리', style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('위젯 설정', style: TextStyle(fontSize: 16)),
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
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('알람 설정', style: TextStyle(fontSize: 16)),
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
            ],
          ),
        ),
      ),
    );
  }
}