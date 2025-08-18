// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     try {
//       // Initialize settings
//       const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//       const initSettings = InitializationSettings(android: androidSettings);

//       // Initialize plugin
//       await _notifications.initialize(initSettings);
//       print('Notification plugin initialized successfully');

//       // Initialize timezone
//       tz.initializeTimeZones();
//       tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
//       print('Timezone set to Asia/Ho_Chi_Minh');

//       // Create notification channel
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'daily_channel',
//         'Daily Notifications',
//         description: 'Channel for daily scheduled notifications',
//         importance: Importance.max,
//         playSound: true,
//         enableVibration: true,
//         showBadge: true,
//         enableLights: true,
//       );
//       await _notifications
//           .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//       print('Notification channel created: daily_channel');

//       // Check and request permissions
//       final notificationPermissionStatus = await Permission.notification.status;
//       print('Notification permission: $notificationPermissionStatus');
//       if (notificationPermissionStatus.isDenied) {
//         await Permission.notification.request();
//         print('Requested notification permission');
//       }

//       final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
//       print('SCHEDULE_EXACT_ALARM permission: $exactAlarmStatus');
//       if (exactAlarmStatus.isDenied) {
//         await Permission.scheduleExactAlarm.request();
//         print('Requested SCHEDULE_EXACT_ALARM permission');
//       }

//       final batteryOptStatus = await Permission.ignoreBatteryOptimizations.status;
//       print('Ignore battery optimization: $batteryOptStatus');
//       if (batteryOptStatus.isDenied) {
//         await Permission.ignoreBatteryOptimizations.request();
//         print('Requested ignore battery optimization');
//       }
//     } catch (e) {
//       print('Error initializing NotificationService: $e');
//     }
//   }

//   Future<void> scheduleDaily({
//     required int id,
//     required String title,
//     required String body,
//     required int hour,
//     required int minute,
//   }) async {
//     try {
//       final notificationPermission = await Permission.notification.status;
//       final exactAlarmPermission = await Permission.scheduleExactAlarm.status;
//       print('Scheduling notification ID $id at $hour:$minute');
//       print('Notification permission: $notificationPermission');
//       print('Exact alarm permission: $exactAlarmPermission');

//       if (notificationPermission.isGranted) {
//         final time = _nextInstanceOfTime(hour, minute);
//         print('Scheduled time (local): $time');

//         await _notifications.zonedSchedule(
//           id,
//           title,
//           body,
//           time,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'daily_channel',
//               'Daily Notifications',
//               channelDescription: 'Channel for daily scheduled notifications',
//               importance: Importance.max,
//               priority: Priority.high,
//               showWhen: true,
//               ticker: 'Daily Notification',
//               playSound: true,
//               enableVibration: true,
//               enableLights: true,
//               icon: '@mipmap/ic_launcher',
//               visibility: NotificationVisibility.public,
//             ),
//           ),
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//           androidScheduleMode: AndroidScheduleMode.inexact, // Thử chế độ không chính xác
//         );
//         print('Notification ID $id scheduled successfully');
//       } else {
//         print('Cannot schedule notification ID $id: Missing notification permission');
//       }
//     } catch (e) {
//       print('Error scheduling notification ID $id: $e');
//     }
//   }

//   Future<void> showImmediateNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     try {
//       final notificationPermission = await Permission.notification.status;
//       print('Showing immediate notification ID $id');
//       print('Notification permission: $notificationPermission');

//       if (notificationPermission.isGranted) {
//         await _notifications.show(
//           id,
//           title,
//           body,
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'daily_channel',
//               'Daily Notifications',
//               channelDescription: 'Channel for immediate notifications',
//               importance: Importance.max,
//               priority: Priority.high,
//               showWhen: true,
//               ticker: 'Immediate Notification',
//               playSound: true,
//               enableVibration: true,
//               enableLights: true,
//               icon: '@mipmap/ic_launcher',
//               visibility: NotificationVisibility.public,
//             ),
//           ),
//         );
//         print('Immediate notification ID $id shown successfully');
//       } else {
//         print('Cannot show immediate notification ID $id: Missing notification permission');
//       }
//     } catch (e) {
//       print('Error showing immediate notification ID $id: $e');
//     }
//   }

//   tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
//     final now = tz.TZDateTime.now(tz.getLocation('Asia/Ho_Chi_Minh'));
//     var scheduled = tz.TZDateTime(
//       tz.getLocation('Asia/Ho_Chi_Minh'),
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );
//     print('Current time (local): $now');
//     print('Initial scheduled time (local): $scheduled');
//     if (scheduled.isBefore(now)) {
//       scheduled = scheduled.add(const Duration(days: 1));
//       print('Adjusted scheduled time (next day, local): $scheduled');
//     }
//     return scheduled;
//   }

//   Future<void> askNotificationPermission() async {
//     try {
//       final status = await Permission.notification.status;
//       print('Notification permission before request: $status');
//       if (status.isDenied) {
//         await Permission.notification.request();
//         print('Requested notification permission');
//       }
//       print('Notification permission after request: ${await Permission.notification.status}');
//     } catch (e) {
//       print('Error requesting notification permission: $e');
//     }
//   }
// }