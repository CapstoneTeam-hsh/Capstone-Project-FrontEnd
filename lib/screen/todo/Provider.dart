import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:javis/api/users/homepage.dart';

class HomepageProvider extends ChangeNotifier {
  Map<String, dynamic> _data = {};

  // 데이터 가져오기
  Future<void> fetchData() async {
    try {
      Map<String, dynamic> data = await getHomepage() as Map<String, dynamic>;
      _data = data;
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // 홈페이지 데이터 반환
  Map<String, dynamic> get homepageData => _data;
}
