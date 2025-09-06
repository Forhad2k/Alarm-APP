import 'package:get/get.dart';
import 'package:intl/intl.dart';


class Alarm {
  final int id; // unique notification id
  DateTime dateTime;
  RxBool isEnabled;

  Alarm({
    required this.id,
    required this.dateTime,
    required bool isEnabled,
  }) : isEnabled = isEnabled.obs;

  String get time => DateFormat.jm().format(dateTime);      // e.g. 7:10 AM
  String get date => DateFormat.yMMMd().format(dateTime);  // e.g. Mar 21, 2023
}