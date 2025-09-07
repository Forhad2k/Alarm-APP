# Alarm App

A **Flutter-based Alarm Application** that allows users to:  

- Set multiple alarms with **time and date**.  
- Receive **local notifications** when alarms trigger.  
- Automatically **disable alarms** after they go off.  
- **Store alarms locally** using `GetStorage` to persist across app restarts.  
- Fetch and display the user's **current location**.  
- Display alarms with **formatted time (AM/PM) and date**.  

---

## Features

- Add, edit, and toggle alarms.  
- Friendly UI showing **time, date, and switch** in a single row.  
- Notifications work on **Android and iOS devices**.  
- Supports **12-hour format** with AM/PM.  
- Automatic rescheduling of enabled alarms after app restart.  
- Initial sample alarms included for testing.  

---

## Dependencies

```yaml
dependencies:
  get: ^4.7.2
  smooth_page_indicator: ^1.2.1
  device_preview: ^1.3.1
  google_fonts: ^6.3.1
  location: ^8.0.1
  geolocator: ^14.0.2
  geocoding: ^4.0.0
  timezone: ^0.10.1
  flutter_local_notifications: ^19.4.1
  get_storage: ^2.1.1
