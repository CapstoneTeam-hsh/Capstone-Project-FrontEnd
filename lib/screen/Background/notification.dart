//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../api/background/notification.dart';

showNotification({
  required String title,
  required String detail,

}) async {

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '$title',
      '$detail',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
  );
}