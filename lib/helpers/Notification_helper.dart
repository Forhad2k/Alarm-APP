import 'package:alarm/features/HomeScreen/controller/alarmController.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  tz.initializeTimeZones();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null) {
        final alarmId = int.tryParse(payload);
        if (alarmId != null) {
          final alarmController = Get.find<AlarmController>();
          alarmController.disableAlarmById(alarmId);
        }
      }
    },
  );
}

Future<void> scheduleAlarmNotification(int alarmId, DateTime alarmDateTime) async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduled = tz.TZDateTime.from(alarmDateTime, tz.local);

  if (!scheduled.isAfter(now)) {
    scheduled = now.add(const Duration(seconds: 2)); // For past time, schedule 2s later
  }

  await flutterLocalNotificationsPlugin.cancel(alarmId);

  const androidDetails = AndroidNotificationDetails(
    'alarm_channel',
    'Alarm Notifications',
    channelDescription: 'Channel for alarm notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    alarmId,
    'Alarm',
    'It\'s time for your alarm!',
    scheduled,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    payload: alarmId.toString(), // Pass the alarm ID for auto-disable
  );
}
