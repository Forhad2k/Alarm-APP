import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
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

class AlarmController extends GetxController {
  var alarms = <Alarm>[].obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();

    // sample alarms
    alarms.addAll([
      Alarm(id: 1001, dateTime: DateTime(2025, 9, 6, 7, 10), isEnabled: false),
      Alarm(id: 1002, dateTime: DateTime(2025, 9, 6, 7, 15), isEnabled: false),
      Alarm(id: 1003, dateTime: DateTime(2025, 9, 6, 7, 20), isEnabled: false),
    ]);

    scheduleAlarms();
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones(); // Initialize timezone data

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Find the alarm by id and disable it when the notification is triggered
        final id = response.id; // This is the alarm id
        final alarmIndex = alarms.indexWhere((alarm) => alarm.id == id);
        if (alarmIndex != -1) {
          alarms[alarmIndex].isEnabled.value = false; // Turn off the switch
        }
      },
    );
  }

  void addAlarm(DateTime alarmDateTime) {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    alarms.add(Alarm(id: id, dateTime: alarmDateTime, isEnabled: true));
    _scheduleForIndex(alarms.length - 1);
  }

  void toggleAlarm(int index) {
    final alarm = alarms[index];
    alarm.isEnabled.value = !alarm.isEnabled.value;
    if (alarm.isEnabled.value) {
      _scheduleForIndex(index);
    } else {
      cancelAlarmNotification(alarm.id);
    }
  }

  void scheduleAlarms() {
    for (int i = 0; i < alarms.length; i++) {
      _scheduleForIndex(i);
    }
  }

  Future<void> _scheduleForIndex(int index) async {
    if (index < 0 || index >= alarms.length) return;
    final alarm = alarms[index];
    if (!alarm.isEnabled.value) return;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime.from(alarm.dateTime, tz.local);

    // If the alarm time is <= now, push it 2 seconds forward
    if (!scheduled.isAfter(now)) {
      scheduled = now.add(const Duration(seconds: 2));
    }

    await flutterLocalNotificationsPlugin.cancel(alarm.id); // Avoid duplicates

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    // Correct the scheduling call:
    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarm.id,
      'Alarm',
      'It\'s time for your alarm!',
      scheduled,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Schedule even when the device is idle
    );
  }

  Future<void> cancelAlarmNotification(int alarmId) async {
    await flutterLocalNotificationsPlugin.cancel(alarmId);
  }
}
