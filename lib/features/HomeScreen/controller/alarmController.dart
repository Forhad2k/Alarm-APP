import 'package:alarm/features/HomeScreen/Model/Alarm.dart';
import 'package:alarm/helpers/Notification_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AlarmController extends GetxController {
  var alarms = <Alarm>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    loadAlarmsFromStorage();

    // Initial sample alarms
    final initialAlarms = [
      Alarm(id: 1001, dateTime: DateTime(2025, 9, 6, 7, 10), isEnabled: false),
      Alarm(id: 1002, dateTime: DateTime(2025, 9, 6, 7, 15), isEnabled: false),
      Alarm(id: 1003, dateTime: DateTime(2025, 9, 6, 7, 20), isEnabled: false),
    ];

    // Add initial alarms only if they don't already exist
    for (var alarm in initialAlarms) {
      final exists = alarms.any((a) => a.id == alarm.id);
      if (!exists) {
        alarms.add(alarm);
        _scheduleAlarm(alarm);
      }
    }

    saveAlarmsToStorage(); // Save updated alarms
    autoScheduleAlarms();  // Reschedule only enabled alarms
  }

  /// Add a new alarm
  void addAlarm(DateTime alarmDateTime) {
    final id = DateTime.now().millisecondsSinceEpoch.remainder(100000);
    final newAlarm = Alarm(id: id, dateTime: alarmDateTime, isEnabled: true);
    alarms.add(newAlarm);
    _scheduleAlarm(newAlarm);
    saveAlarmsToStorage();
  }

  /// Toggle an alarm on/off
  void toggleAlarm(int index) {
    final alarm = alarms[index];
    alarm.isEnabled.value = !alarm.isEnabled.value;
    if (alarm.isEnabled.value) {
      _scheduleAlarm(alarm);
    } else {
      cancelAlarmNotification(alarm.id);
    }
    saveAlarmsToStorage();
  }

  /// Disable an alarm by ID (used when notification is triggered)
  void disableAlarmById(int id) {
    final alarm = alarms.firstWhereOrNull((a) => a.id == id);
    if (alarm != null) {
      alarm.isEnabled.value = false;
      cancelAlarmNotification(id);
      saveAlarmsToStorage();
    }
  }

  /// Save alarms to local storage
  void saveAlarmsToStorage() {
    final alarmList = alarms.map((a) => a.toJson()).toList();
    box.write('alarms', alarmList);
  }

  /// Load alarms from local storage
  void loadAlarmsFromStorage() {
    final alarmList = box.read('alarms') ?? [];
    alarms.clear();
    for (var item in alarmList) {
      alarms.add(Alarm.fromJson(item));
    }
  }

  /// Auto-reschedule enabled alarms after app restart
  void autoScheduleAlarms() {
    for (final alarm in alarms) {
      if (alarm.isEnabled.value && alarm.dateTime.isAfter(DateTime.now())) {
        _scheduleAlarm(alarm);
      }
    }
  }

  /// Schedule a notification for a single alarm
  Future<void> _scheduleAlarm(Alarm alarm) async {
    if (!alarm.isEnabled.value) return;
    await scheduleAlarmNotification(alarm.id, alarm.dateTime);
  }

  /// Cancel a scheduled notification
  Future<void> cancelAlarmNotification(int alarmId) async {
    await flutterLocalNotificationsPlugin.cancel(alarmId);
  }
}
