
import 'package:flutter/material.dart';

Future<DateTime> showDatePickerPop(DateTime initialDate,BuildContext context) async {
  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );
  return selectedDate ?? initialDate;
}