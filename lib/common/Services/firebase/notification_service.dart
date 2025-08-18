// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');  // Thay 'app_icon' bằng tên icon của bạn

//    const IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//         requestSoundPermission: false, 
//         requestBadgePermission: false, 
//         requestAlertPermission: false,
//     );


//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   // Lên lịch thông báo mỗi ngày vào 9h55 sáng
//   Future<void> scheduleDailyNotification() async {
//     final tz.TZDateTime scheduledTime = _nextInstanceOfTime(9, 55);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0, 
//       'Thông báo tự động', 
//       'Đây là thông báo tự động vào lúc 9h55 sáng',
//       scheduledTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your_channel_id',
//           'your_channel_name',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

//     if (scheduledTime.isBefore(now)) {
//       scheduledTime = scheduledTime.add(const Duration(days: 1));
//     }

//     return scheduledTime;
//   }
// }
