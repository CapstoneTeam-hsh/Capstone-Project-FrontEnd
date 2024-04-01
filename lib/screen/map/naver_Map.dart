import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:javis/api/naver_map/naver_map.dart';
//import 'package:flutter_blue_plus/flutter_blue_plus.dart';


class naver_Map extends StatefulWidget {
  late double initiallat;
  late double initiallng;
  // 생성자에 초기 위치를 전달받는 매개변수 추가
  naver_Map({Key? key, required this.initiallat,required this.initiallng}) : super(key: key);
  @override
  naver_map createState() => naver_map(Lat : initiallat,Lng : initiallng);
}

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

class naver_map extends State<naver_Map> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  NLatLng test = new NLatLng(0, 0);
  late NMarker marker;
  late NaverMapController mapController;

  Position? currentPosition;
// 생성자에서 initialPosition을 받아 NMarker와 NLatLng를 초기화
  naver_map({required double Lat, required double Lng}) {
    marker = NMarker(id: '1', position: NLatLng(Lat, Lng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS 설정'),
      ),
      body: NaverMap(
        options: NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(
              widget.initiallat,
              widget.initiallng,
            ),
            zoom: 13,
            bearing: 0,
            tilt: 0,
          )
        ),
        onMapReady: (controller) {
          setState(() {
            mapController = controller;
            mapController.addOverlay(marker);
          });
        },
        onMapTapped: (point, latLng) {
          // 지도를 터치했을 때 실행할 코드
          marker = NMarker(
            id: '1',
            position: latLng,
          );
          setState(() {
            mapController.clearOverlays();
            mapController.addOverlay(marker);
          });
          test = latLng;
          // 새로운 마커를 리스트에 추가하고 지도에 반영
          print('Marker added at: $latLng');
        },
        onSymbolTapped: (symbol){
          marker = NMarker(
            id: '1',
            position: symbol.position,
          );
          setState(() {
            mapController.clearOverlays();
            mapController.addOverlay(marker);
          });
        },

      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.1,right:MediaQuery.of(context).size.width * 0.01),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "delete",
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.red, // 빨간색
              child: Icon(Icons.close),
            ),
            FloatingActionButton(
              heroTag: "check",
              onPressed: () {
                //Position current_postion = {Latitude : marker.position.latitude, Longitude : marker.position.longitude};
                Navigator.pop(context,marker);
              },
              backgroundColor: Colors.green, // 초록색
              child: Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}