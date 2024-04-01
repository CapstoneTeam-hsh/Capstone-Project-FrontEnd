import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:geolocator/geolocator.dart';

import '../../api/background/getlocation.dart';
import 'notification.dart';

Future<void> startBackgroundLocationService() async {
  await bg.BackgroundGeolocation.ready(bg.Config(
    desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
    preventSuspend: true,
    heartbeatInterval: 5,
    stopOnStationary: false,
    distanceFilter: 0,
    isMoving: true,
    disableElasticity: true,
    stopOnTerminate: true,
    startOnBoot: false,
    stationaryRadius: 25,
    logLevel: bg.Config.LOG_LEVEL_VERBOSE,
    locationUpdateInterval: 5000,
    disableLocationAuthorizationAlert: true,
    showsBackgroundLocationIndicator: true,
  ));

  await bg.BackgroundGeolocation.start();

  bg.BackgroundGeolocation.onLocation((bg.Location location) async {
    print("위치 변경 감지");
    try {
      double latitude = location.coords.latitude;
      double longitude = location.coords.longitude;

      // Position position = Position(
      //   latitude: latitude,
      //   longitude: longitude,
      //   accuracy: location.coords.accuracy,
      //   altitude: location.coords.altitude,
      //   heading: location.coords.heading,
      //   speed: location.coords.speed,
      //   speedAccuracy: location.coords.speedAccuracy,
      //   timestamp: DateTime.parse(location.timestamp),
      //   altitudeAccuracy: null,
      //   headingAccuracy: null,
      // );

      // 백그라운드 위치 추적이 시작되었을 때 실행하고자 하는 코드를 여기에 추가
      // 예를 들어, 위치 정보를 서버로 전송하는 등의 작업을 수행할 수 있습니다.
      List<dynamic> todoList = await getLocation(latitude: latitude, longitude: longitude);

// todoList를 사용하여 작업을 계속 진행합니다.
      if (todoList.isNotEmpty) {
        print("${todoList.length}");
        for (int i = 0; i < todoList.length; i++) {
          Map<String, dynamic> todo = todoList[i];
          double latitude = todo['latitude'];
          double longitude = todo['longitude'];
          int id = todo['id'];
          String title = todo['title'];
          print("${title}");
          // latitudeList.add(latitude);
          // longitudeList.add(longitude);
          showNotification(title: '$title', detail: '$title');
        }
      } else {
        print("빈 값입니다~");
      }

// 위도와 경도 값을 담은 리스트 출력
//       print('Latitude List: $latitudeList');
//       print('Longitude List: $longitudeList');

    } catch (e, stackTrace) {
      print('백그라운드 위치 업데이트 오류: $e');
      print('Stack trace: $stackTrace');
    }
  },(bg.LocationError error) {
    // 위치 업데이트 처리 중에 오류가 발생할 때 실행될 콜백 함수
    print("[onLocation] ERROR: $error");
  });
}
