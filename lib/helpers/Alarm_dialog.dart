import 'package:alarm/features/HomeScreen/controller/alarmController.dart';
import 'package:flutter/material.dart';

void showAddAlarmDialog(BuildContext context, AlarmController alarmController) async {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2023),
    lastDate: DateTime(2100),
  );
  if (selectedDate == null) return;

  selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (selectedTime == null) return;

  final DateTime alarmDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  alarmController.addAlarm(alarmDateTime);
}
