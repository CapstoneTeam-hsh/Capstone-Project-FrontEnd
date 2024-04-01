import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../api/todo/todo&&Category.dart';

DateTime _focusedDay = DateTime.now();
Map<String, Color> _categoryColorMap = {};

Color _generateRandomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

class Calendar extends StatefulWidget {
  final List<dynamic> categoryData;
  final List<Category> myTodo;

  const Calendar({Key? key, required this.categoryData, required this.myTodo}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    _initializeCategoryColorMap();
  }

  void _initializeCategoryColorMap() {
    Set<String> uniqueCategories = Set<String>.from(widget.categoryData.map((category) => category.toString()));

    for (var category in uniqueCategories) {
      _categoryColorMap.putIfAbsent(category, () => _generateRandomColor());
      print("$category  ${_categoryColorMap[category]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
              });
            },
            icon: Icon(Icons.arrow_left),
          ),
          Text("${_focusedDay.month}월"),
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
              });
            },
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _CalendarBody(focusedDay: _focusedDay, categoryData: widget.categoryData, myTodo: widget.myTodo,),
          ),
        ],
      ),
    );
  }
}

class _CalendarBody extends StatelessWidget {
  final DateTime focusedDay;
  final List<dynamic> categoryData;
  final List<Category> myTodo;

  const _CalendarBody({Key? key, required this.focusedDay, required this.categoryData, required this.myTodo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              categoryData.length,
                  (index) {
                final category = categoryData[index];
                final color = _categoryColorMap[category];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(category),
                    style: ElevatedButton.styleFrom(primary: color),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          flex: 8,
          child: TableCalendar(
            rowHeight: 80, // 각 날짜 행의 높이 설정
            focusedDay: focusedDay,
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2025, 12, 31),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              print('$selectedDay');
              Navigator.pop(context,selectedDay);
            },
            eventLoader: (day) {
              List<Event> events = getEventsForDay(day);
              return events.isNotEmpty ? ['event'] : [];
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, eventIds) {
                List<Event> events = getEventsForDay(date);
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: events.isNotEmpty ? _buildEventsMarker(events.length) : SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(int eventCount) {
    return SizedBox(
      width: 30,
      height: 20,
      child: Text(
        '$eventCount',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  List<Event> getEventsForDay(DateTime day) {
    List<Event> events = [];

    for (var category in myTodo) {
      for (var todo in category.allTodoList) {
        DateTime startDate = _parseDate(todo.startLine);
        DateTime endDate = _parseDate(todo.deadLine);
        DateTime dayWithoutTime = DateTime(day.year, day.month, day.day);

        if (dayWithoutTime.isAfter(startDate) &&
            dayWithoutTime.isBefore(endDate) ||
            dayWithoutTime == startDate ||
            dayWithoutTime == endDate) {
          Color? categoryColor =
          _categoryColorMap[category.categoryName.toString()];
          if (categoryColor != null) {
            events.add(Event(
              date: day,
              title: todo.title,
              eventId: todo.todoId,
              categoryColor: categoryColor,
            ));
            print('New todo added: ${todo.title}');
          }
        }
      }
    }

    return events;
  }

  DateTime _parseDate(String dateString) {
    List<String> parts = dateString.split('-');
    if (parts.length == 3) {
      String year = parts[0];
      String month = parts[1].padLeft(2, '0');
      String day = parts[2].padLeft(2, '0');
      dateString = '$year-$month-$day';
    }

    return DateTime.parse(dateString);
  }
}
