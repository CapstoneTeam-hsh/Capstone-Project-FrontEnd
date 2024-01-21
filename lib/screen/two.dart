import 'package:flutter/material.dart';

class two extends StatelessWidget {
  const two({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.blue,
      ),
    );
  }
}