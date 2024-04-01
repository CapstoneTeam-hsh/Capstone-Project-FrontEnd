import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:javis/screen/map/naver_Map.dart';
import 'package:javis/screen/todo/CalenderAppbar.dart';
import 'package:javis/screen/todo/solomainTodo.dart';
//import 'package:location/location.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../api/todo/category_list.dart';
import '../../api/todo/gps_list.dart';
import '../../api/todo/todo.dart';
import '../../api/users/sign-up.dart';
import '../../custom/myButton.dart';
import '../../custom/myTextField.dart';
import '../../dto/errorDto.dart';
import 'my_category_list.dart';
import 'package:intl/intl.dart';
DateTime date = DateTime.now();

//await todoRegi(titleController.text,detailController.text,startDate,endDate,myCategoryPick,locationIdResult);
class createTodo extends StatelessWidget {
  final String? myTitle; // 선택적 매개변수로 변경
  final String? myDetail; // 선택적 매개변수로 변경
  final String? myStart; // 선택적 매개변수로 변경
  final String? myEnd; // 선택적 매개변수로 변경
  final String? myCP; // 선택적 매개변수로 변경
  final String? myLocation;
  final double? myLongitude; // 선택적 매개변수로 변경
  final double? myLatitude; // 선택적 매개변수로 변경
  const createTodo({Key? key,this.myTitle,this.myDetail,this.myStart,this.myEnd,this.myCP,this.myLocation,this.myLongitude,this.myLatitude}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('할 일'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CreateTodoForm(
          myTitle :myTitle,
          myDetail: myDetail,
          myStart: myStart,
          myEnd: myEnd,
          myCP: myCP,
          myLocation : myLocation,
          myLatitude: myLatitude,
          myLongitude: myLongitude,
        ),
      ),
    );
  }
}

class CreateTodoForm extends StatefulWidget {
  final String? myTitle; // 선택적 매개변수로 변경
  final String? myDetail; // 선택적 매개변수로 변경
  final String? myStart; // 선택적 매개변수로 변경
  final String? myEnd; // 선택적 매개변수로 변경
  final String? myCP; // 선택적 매개변수로 변경
  final String? myLocation;
  final double? myLongitude; // 선택적 매개변수로 변경
  final double? myLatitude; // 선택적 매개변수로 변경
  const CreateTodoForm({Key? key,this.myTitle,this.myDetail,this.myStart,this.myEnd,this.myCP,this.myLocation,this.myLongitude,this.myLatitude}) : super(key: key);

  @override
  State<CreateTodoForm> createState() => _CreateTodoFormState(
    myTitle :myTitle,
    myDetail: myDetail,
    myStart: myStart,
    myEnd: myEnd,
    myCP: myCP,
    myLocation : myLocation,
    myLatitude: myLatitude,
    myLongitude: myLongitude,
  );
}

Future<Position> getCurrentLocation() async {
  var accuracy = await Geolocator.getLocationAccuracy();
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

class _CreateTodoFormState extends State<CreateTodoForm> {
  TextEditingController titleController = TextEditingController();
  //TextEditingController pwController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController wifiController = TextEditingController();
  TextEditingController GPSnameController = TextEditingController();

  DateTime startDate = date;
  DateTime endDate = date;
  String myCategoryPick = "";
  late double Latitude;
  late double Longitude;

  _CreateTodoFormState({this.myTitle,this.myDetail,this.myStart,this.myEnd,this.myCP,this.myLocation,this.myLongitude,this.myLatitude})
  {
    // myTitle이 null이 아니면 해당 값을 텍스트 필드에 설정
    if (myTitle != null) titleController = TextEditingController(text: myTitle);
    if (myDetail != null) detailController = TextEditingController(text: myDetail);
    if (myStart != null) {
      List<String> dateParts = myStart!.split('-'); // 문자열을 "-"로 분할하여 연도, 월, 일로 나눔
      int year = int.parse(dateParts[0]); // 연도 부분 파싱
      int month = int.parse(dateParts[1]); // 월 부분 파싱
      int day = int.parse(dateParts[2]); // 일 부분 파싱

      startDate = DateTime(year, month, day); // DateTime 객체 생성
    }
    if(myEnd != null){
      List<String> dateParts = myEnd!.split('-'); // 문자열을 "-"로 분할하여 연도, 월, 일로 나눔
      int year = int.parse(dateParts[0]); // 연도 부분 파싱
      int month = int.parse(dateParts[1]); // 월 부분 파싱
      int day = int.parse(dateParts[2]); // 일 부분 파싱

      endDate = DateTime(year, month, day); // DateTime 객체 생성
    }
    if(myCP != null) myCategoryPick = myCP!;
    if(myLocation != null) GPSnameController = TextEditingController(text: myLocation);
    if(myLongitude != null) Longitude = myLongitude!;
    if(myLatitude != null) Latitude = myLatitude!;
    if(myLongitude != null && myLatitude != null) current = true;
  } // 선택적 매개변수로 변경

  final String? myTitle; // 선택적 매개변수로 변경
  final String? myDetail; // 선택적 매개변수로 변경
  final String? myStart; // 선택적 매개변수로 변경
  final String? myEnd; // 선택적 매개변수로 변경
  final String? myCP; // 선택적 매개변수로 변경
  final String? myLocation;
  final double? myLongitude; // 선택적 매개변수로 변경
  final double? myLatitude; // 선택적 매개변수로 변경
  bool current = false;
  Errordto error = Errordto();

  //Map<String, Null> position = {'lat': null, 'lng': null};

  dynamic titleError;
  dynamic pwError;
  dynamic detailError;
  dynamic wifiError;


  @override
  Widget build(BuildContext context) {

    final info = NetworkInfo();
    dynamic Name="";
    var wifi_Name;

    FlutterBlue flutterBlue = FlutterBlue.instance;
    BluetoothDevice? connectedDevice;

    return Container(
      child: Column(
        key: UniqueKey(),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          myTextFormField(
            label: '제목',
            myicon: Icons.title,
            controller: titleController,
            error: titleError,
          ),
          SizedBox(height: 16.0),
          Container(
            //key: UniqueKey(), // InkWell 위젯에 고유한 키 추가
            child: InkWell(
              onTap: () async {
                List<dynamic> my_category = await getMyCate() as List<dynamic>;

                String selectedValue = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyCate(myCategory: my_category),
                  ),
                );
                myCategoryPick = selectedValue;
                print('$myCategoryPick');
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category,
                          color: Colors.black,
                        ),
                        Text(
                          "카테고리",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${myCategoryPick}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "시작일",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime pickedStartDate = await showDatePickerPop(startDate, context);
                        if (pickedStartDate != null) {
                          setState(() {
                            startDate = pickedStartDate;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8.0),
                            Text(
                                "${startDate.year}-${startDate.month}-${startDate.day}"
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(width: 16.0), // 간격 조정
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "종료일",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime pickedEndDate = await showDatePickerPop(endDate, context);
                        print('$pickedEndDate');
                        if (pickedEndDate != null) {
                          setState(() {
                            endDate = pickedEndDate;
                          });
                        }
                        print('$endDate');
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8.0),
                            // 업데이트된 날짜를 표시하기 위해 endDate를 사용합니다.
                            Text(
                              // DateFormat을 사용하여 DateTime을 문자열로 변환합니다.
                              DateFormat('yyyy-MM-dd').format(endDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          myTextFormField(
            label: '내용',
            myicon: Icons.subject,
            controller: detailController,
            error: detailError,
          ),
          myTextFormField(
            label: '장소 이름',
            myicon: Icons.gps_fixed,
            controller: GPSnameController,
            error: detailError,
          ),
          // myTextFormField(
          //   label:  Name,
          //   myicon: Icons.subject,
          //   controller: wifiController,
          //   error: wifiError,
          // ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  //일단 임시로 돌아가는 버튼 만들어놓음
                  Navigator.pop(context);
                  //삭제하는 api사용해야함
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,  // 빨간색 아이콘
                ),
                color: Colors.redAccent,  // 파스텔톤 빨간색 배경
              ),
              IconButton(
                onPressed: () async{
                  wifi_Name = await info.getWifiBSSID();
                  setState(() {
                    wifiController.text = wifi_Name ?? "현재 연결된 와이파이가 없습니다.";
                  });
                },
                icon: Icon(
                  Icons.wifi,
                  color: Colors.blue,  // 빨간색 아이콘
                ),
                color: Colors.redAccent,  // 파스텔톤 빨간색 배경
              ),
              IconButton(
                onPressed: () async{
                  if(!current) {
                    Position my_current_position = await getCurrentLocation();
                    Latitude = my_current_position.latitude;
                    Longitude = my_current_position.longitude;
                    current = true;
                  }
                  print("위도 : $Latitude, 경도 : $Longitude ");
                  NMarker result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        naver_Map(initiallat: Latitude,initiallng : Longitude)),
                  );
                  print("결과 : $result");
                  if(result!=null){
                    Latitude = result.position.latitude;
                    Longitude = result.position.longitude;
                    print("$Latitude && $Longitude");
                    print("check : $result");
                  }
                  print("$Latitude && $Longitude");
                },
                icon: Icon(
                  Icons.map,
                  color: Colors.orangeAccent,  // 빨간색 아이콘
                ),
                color: Colors.redAccent,  // 파스텔톤 빨간색 배경
              ),
              IconButton(
                onPressed: () async{
                  //print(1);
                  int locationIdResult = await locationRegi(GPSnameController.text,Latitude,Longitude);
                  //int parsedLocationId;
                  //print(2);
                  await todoRegi(titleController.text,detailController.text,startDate,endDate,myCategoryPick,locationIdResult);
                  //print(3);
                  Navigator.pop(context,true);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,  // 초록색 아이콘
                ),
                color: Colors.greenAccent,  // 파스텔톤 초록 배경
              ),
            ],
          ),
        ],
      ),
    );
  }

  dynamic _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return '$fieldName 입력하세요.';
    }
    return null;
  }
}