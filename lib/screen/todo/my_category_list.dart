import 'package:flutter/material.dart';
import 'package:javis/screen/todo/solomainTodo.dart';

import '../../api/todo/category_list.dart';
import '../../api/todo/deleteCategory.dart';
import '../../api/todo/post_category.dart';

class MyCate extends StatefulWidget {
  final List<dynamic> myCategory;

  const MyCate({Key? key, required this.myCategory}) : super(key: key);

  @override
  _MyCateState createState() => _MyCateState();
}

class _MyCateState extends State<MyCate> {
  late List<String> currentCategory;
  late TextEditingController category_edit;

  @override
  void initState() {
    super.initState();
    currentCategory = List.from(widget.myCategory);
    category_edit = TextEditingController(); // controller를 초기화합니다.
  }

  @override
  void dispose() {
    category_edit.dispose(); // 사용이 끝난 컨트롤러를 dispose합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: category_edit, // controller를 TextField에 할당합니다.
                    onChanged: (value) {
                      // setState(() {
                      //   currentCategory.add(value);
                      // });
                    },
                    decoration: InputDecoration(
                      hintText: '텍스트를 입력하세요',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () async {
                    await postMyCate(category_edit.text);
                    setState(() {
                      widget.myCategory.add(category_edit.text);
                    });
                    Navigator.pop(context,category_edit.text);
                  },
                  child: Text('추가'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentCategory.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String selectedCategory = currentCategory[index];
                          Navigator.pop(context, selectedCategory);
                        },
                        child: Text(currentCategory[index]),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await delMyCate(currentCategory[index]);
                        setState(() {
                          currentCategory.removeAt(index);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
