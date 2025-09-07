import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Alarm {
  final int id;
  final DateTime dateTime;
  RxBool isEnabled;

  Alarm({required this.id, required this.dateTime, bool isEnabled = false})
      : isEnabled = isEnabled.obs;

  // Time in 12-hour format with AM/PM
  String get time => DateFormat('hh:mm a').format(dateTime);

  // Friendly formatted date
  String get date => DateFormat('EEE, dd MMM yyyy').format(dateTime);

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateTime': dateTime.toIso8601String(),
    'isEnabled': isEnabled.value,
  };

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    id: json['id'],
    dateTime: DateTime.parse(json['dateTime']),
    isEnabled: json['isEnabled'],
  );
}
