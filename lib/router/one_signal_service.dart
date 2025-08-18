// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:tcs_flutter/common/Services/api_endpoints.dart';
// import 'package:tcs_flutter/common/repositoty/dio_api.dart';
// import 'package:tcs_flutter/common/utils/navigation_utils.dart';
// import 'package:tcs_flutter/common/utils/notification_utils.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:uuid/uuid.dart';

// class OneSignalService {
//   static const String _appId = "a2d574ef-f1f1-4656-9b7f-b36e3afc940f";
//   static final OneSignalService _instance = OneSignalService._internal();
//   factory OneSignalService() => _instance;
//   OneSignalService._internal();

//   static OSNotificationClickEvent? _cachedClickEvent;
//   static bool _notificationHandled = false;
//   static String? _sentToken;
//   static const String _storageKeyLastToken = 'last_push_token';
//   bool _initialized = false;

//   Future<void> init() async {
//     if (_initialized) return;
//     _initialized = true;
//     OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//     OneSignal.initialize(_appId);
//     await OneSignal.User.addTagWithKey("test_user", "true");
//     await OneSignal.User.addTags({"test_user": "true"});

//     bool hasPermission = OneSignal.Notifications.permission;
//     if (!hasPermission) {
//       hasPermission = await OneSignal.Notifications.requestPermission(true);
//     }

//     await OneSignal.User.pushSubscription.optIn();

//     OneSignal.Notifications.lifecycleInit();
//     OneSignal.Notifications.addClickListener((event) async {
//       _handleNotificationClick(event);
//     });
//     await listenForPushToken();
//   }


//   Future<void> handlePendingNavigation() async {
//     if (!_notificationHandled && _cachedClickEvent != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         await Future.delayed(Duration(milliseconds: 500));
//         _handleNotificationClick(_cachedClickEvent!);
//         _cachedClickEvent = null;
//         _notificationHandled = true;
//       });
//     }
//   }

//   Future<void> checkPermissionStatus() async {
//     bool hasPermission = await OneSignal.Notifications.requestPermission(true);
//     if (!hasPermission) {
//       await OneSignal.Notifications.requestPermission(true);
//     }
//   }

//   Future<void> listenForPushToken() async {
//     for (int i = 0; i < 3; i++) {
//       String? token = await getPushToken();
//       if (token != null) {
//         print("Token ngay lập tức: $token");
//         await registerPushTokenToBackend(token);
//         break;
//       }
//       print("Chưa nhận được token, thử lại sau ${i + 1}s...");
//       await Future.delayed(Duration(seconds: 1));
//     }
//     OneSignal.User.pushSubscription.addObserver((state) {
//       if (state.current.id != null && state.current.optedIn) {
//         print("Token: ${state.current.id}");
//         try {
//           final token = state.current.id;
//           registerPushTokenToBackend(token!);
//         } catch (e) {
//           print("Gửi token thất bại: $e");
//         }
//       }
//     });
//   }

//   Future<void> registerPushTokenToBackend(String token) async {
//     if (_sentToken == token) {
//       debugPrint("Token đã được gửi, bỏ qua");
//       return;
//     }

//     final box = GetStorage();
//     final String? lastToken = box.read<String>(_storageKeyLastToken);
//     if (lastToken == token) {
//       debugPrint("Token đã được lưu trước đây, bỏ qua");
//       _sentToken = token;
//       return;
//     }

//     final dio = DioApi();
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     final deviceInfo = await _getDeviceInfo();

//     Uuid uuid = Uuid();
//     String deviceUUID = uuid.v4();
//     print("Device UUID: $deviceUUID");

//     final data = {
//       "deviceUUID": deviceUUID,
//       "pushToken": token,
//       "devicePlatform": deviceInfo['platform'],
//       "deviceOS": deviceInfo['osVersion'],
//       "deviceModel": deviceInfo['deviceName'],
//       "deviceName": deviceInfo['deviceName'],
//       "appBuild": packageInfo.buildNumber,
//       "appVersion": packageInfo.version,
//       "appLanguage": "vi-VN"
//     };

//     try {
//       final response = await dio.post(
//         ApiEndpoints.notification,
//         data: data,
//       );
//       print("Token gửi thành công: $response");
//       _sentToken = token;
//       box.write(_storageKeyLastToken, token);
//     } catch (e) {
//       print("Gửi token thất bại: $e");
//     }
//   }

//   Future<Map<String, dynamic>> _getDeviceInfo() async {
//     final deviceInfoPlugin = DeviceInfoPlugin();
//     final deviceInfo = await deviceInfoPlugin.deviceInfo;
//     Map<String, dynamic> info;

//     if (Platform.isAndroid) {
//       final androidInfo = deviceInfo as AndroidDeviceInfo;
//       info = {
//         'platform': 'Android',
//         'deviceName': androidInfo.model,
//         'osVersion': androidInfo.version.release,
//       };
//     } else if (Platform.isIOS) {
//       final iosInfo = deviceInfo as IosDeviceInfo;
//       info = {
//         'platform': 'iOS',
//         'deviceName': iosInfo.name,
//         'osVersion': iosInfo.systemVersion,
//       };
//     } else {
//       info = {
//         'platform': 'unknown',
//         'deviceName': 'unknown',
//         'osVersion': 'unknown',
//       };
//     }

//     return info;
//   }

//   Future<String?> getPushToken() async {
//     final status = OneSignal.User.pushSubscription;
//     print(
//         "getPushToken: status=$status, optedIn=${status?.optedIn}, id=${status?.id}");

//     if (status != null && status.id != null) {
//       return status.id;
//     }

//     return null;
//   }

//   Future<void> _handleNotificationClick(OSNotificationClickEvent event) async {
//     try {
//       final notification = event.notification;
//       final data = notification.additionalData;

//       final notificationData = data?["Data"] ?? data;
//       final directType = data?["type"];
//       final directId = data?["id"];
//       final wrappedType = notificationData?["type"];
//       final wrappedId = notificationData?["id"];

//       final type =
//           NotificationUtils.getNotificationType(wrappedType ?? directType);
//       final id = wrappedId ?? directId;

//       if (type == null || id == null) {
//         print("❌ Missing type or id in notification data");
//         return;
//       }

//       await Future.delayed(Duration(milliseconds: 300));
//       await NavigationUtils.navigateByNotificationType(type: type, id: id);
//     } catch (e) {
//       print("❌ Lỗi khi xử lý click notification: $e");
//     }
//   }

//   static Future<void> clearCachedToken() async {
//     _sentToken = null;
//     final box = GetStorage();
//     await box.remove(_storageKeyLastToken);
//   }
// }
