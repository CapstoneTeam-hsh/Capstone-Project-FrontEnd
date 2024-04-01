import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'api/background/notification.dart';
import 'screen/login/login.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: '9qrjlzb2zc');
  void _registerPlatformInstance() {
    if (Platform.isAndroid) {
      GeolocatorAndroid.registerWith();
    } else if (Platform.isIOS) {
      GeolocatorApple.registerWith();
    }
  }
  initNotification();
  runApp(const LoginApp());
}




