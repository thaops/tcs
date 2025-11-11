import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/utils/navigation_utils.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

class OneSignalService {
  static const String _appId = "7f5c3324-fe79-48c6-af6f-8aab25e401e4";
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  static OSNotificationClickEvent? _cachedClickEvent;
  static bool _notificationHandled = false;
  static String? _sentToken;
  static const String _storageKeyLastToken = 'last_push_token';
  static const String _storageKeyDeviceUUID = 'device_uuid';
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(_appId);
    await OneSignal.User.addTagWithKey("test_user", "true");
    await OneSignal.User.addTags({"test_user": "true"});

    bool hasPermission = OneSignal.Notifications.permission;
    if (!hasPermission) {
      hasPermission = await OneSignal.Notifications.requestPermission(true);
    }

    await OneSignal.User.pushSubscription.optIn();

    OneSignal.Notifications.lifecycleInit();
    OneSignal.Notifications.addClickListener((event) async {
      _handleNotificationClick(event);
    });
    await listenForPushToken();
  }

  Future<void> handlePendingNavigation() async {
    if (!_notificationHandled && _cachedClickEvent != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(Duration(milliseconds: 500));
        _handleNotificationClick(_cachedClickEvent!);
        _cachedClickEvent = null;
        _notificationHandled = true;
      });
    }
  }

  Future<void> checkPermissionStatus() async {
    bool hasPermission = await OneSignal.Notifications.requestPermission(true);
    if (!hasPermission) {
      await OneSignal.Notifications.requestPermission(true);
    }
  }

  Future<void> listenForPushToken() async {
    for (int i = 0; i < 3; i++) {
      String? token = await getPushToken();
      if (token != null) {
        print("Token ngay lập tức: $token");
        await registerPushTokenToBackend(token);
        break;
      }
      print("Chưa nhận được token, thử lại sau ${i + 1}s...");
      await Future.delayed(Duration(seconds: 1));
    }
    OneSignal.User.pushSubscription.addObserver((state) {
      if (state.current.id != null && state.current.optedIn) {
        print("Token: ${state.current.id}");
        try {
          final token = state.current.id;
          registerPushTokenToBackend(token!);
        } catch (e) {
          print("Gửi token thất bại: $e");
        }
      }
    });
  }

  Future<void> registerPushTokenToBackend(String token) async {
    if (_sentToken == token) {
      debugPrint("Token đã được gửi, bỏ qua");
      return;
    }

    final box = GetStorage();
    final String? lastToken = box.read<String>(_storageKeyLastToken);
    if (lastToken == token && _sentToken == token) {
      debugPrint("Token đã được lưu và gửi trước đây, bỏ qua");
      return;
    }

    // Kiểm tra access token trước khi gọi API
    final Services services = await Services.create();
    final accessToken = await services.getAccessToken();

    if (accessToken.isEmpty) {
      // Chưa có access token, lưu token để đăng ký sau khi đăng nhập
      debugPrint("Chưa có access token, lưu token để đăng ký sau");
      box.write(_storageKeyLastToken, token);
      return;
    }

    final dio = DioApi();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await _getDeviceInfo();

    // Sử dụng deviceUUID đã lưu hoặc tạo mới
    String deviceUUID = box.read<String>(_storageKeyDeviceUUID) ?? '';
    if (deviceUUID.isEmpty) {
      Uuid uuid = Uuid();
      deviceUUID = uuid.v4();
      print("Tạo mới Device UUID: $deviceUUID");
    } else {
      print("Sử dụng Device UUID đã lưu: $deviceUUID");
    }

    final data = {
      "deviceUUID": deviceUUID,
      "pushToken": token,
      "devicePlatform": deviceInfo['platform'],
      "deviceOS": deviceInfo['osVersion'],
      "deviceModel": deviceInfo['deviceName'],
      "deviceName": deviceInfo['deviceName'],
      "appBuild": packageInfo.buildNumber,
      "appVersion": packageInfo.version,
      "appLanguage": "vi-VN",
    };

    try {
      final response = await dio.post(ApiEndpoints.notification, data: data);
      print("Token gửi thành công: $response");
      _sentToken = token;
      box.write(_storageKeyLastToken, token);
      box.write(_storageKeyDeviceUUID, deviceUUID);
    } catch (e) {
      print("Gửi token thất bại: $e");
      // Lưu token để thử lại sau
      box.write(_storageKeyLastToken, token);
    }
  }

  /// Đăng ký lại token sau khi đăng nhập thành công
  Future<void> retryRegisterTokenAfterLogin() async {
    final box = GetStorage();
    final String? pendingToken = box.read<String>(_storageKeyLastToken);

    if (pendingToken != null && pendingToken.isNotEmpty) {
      // Kiểm tra xem token đã được gửi chưa
      if (_sentToken != pendingToken) {
        debugPrint("Thử đăng ký lại token sau khi đăng nhập");
        await registerPushTokenToBackend(pendingToken);
      } else {
        debugPrint("Token đã được đăng ký trước đó");
      }
    } else {
      // Nếu không có token đang chờ, thử lấy token hiện tại
      final String? currentToken = await getPushToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        debugPrint("Đăng ký token hiện tại sau khi đăng nhập");
        await registerPushTokenToBackend(currentToken);
      }
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    Map<String, dynamic> info;

    if (Platform.isAndroid) {
      final androidInfo = deviceInfo as AndroidDeviceInfo;
      info = {
        'platform': 'Android',
        'deviceName': androidInfo.model,
        'osVersion': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      final iosInfo = deviceInfo as IosDeviceInfo;
      info = {
        'platform': 'iOS',
        'deviceName': iosInfo.name,
        'osVersion': iosInfo.systemVersion,
      };
    } else {
      info = {
        'platform': 'unknown',
        'deviceName': 'unknown',
        'osVersion': 'unknown',
      };
    }

    return info;
  }

  Future<String?> getPushToken() async {
    final status = OneSignal.User.pushSubscription;
    print(
      "getPushToken: status=$status, optedIn=${status.optedIn}, id=${status.id}",
    );

    if (status.id != null) {
      return status.id;
    }

    return null;
  }

  Future<void> _handleNotificationClick(OSNotificationClickEvent event) async {
    try {
      final notification = event.notification;
      final data = notification.additionalData;

      // Debug: Log toàn bộ data để xem cấu trúc
      print("🔔 Notification click - Full additionalData: $data");
      print("🔔 Notification notificationId: ${notification.notificationId}");
      print("🔔 Notification body: ${notification.body}");

      if (data == null || data.isEmpty) {
        print("❌ Notification additionalData is null or empty");
        return;
      }

      // Thử nhiều cách parse data
      final notificationData = data["Data"] ?? data;
      final directType =
          data["type"] ??
          data["Type"] ??
          data["TYPE"] ??
          data["source"]; // Có thể là "source" thay vì "type"
      // Ưu tiên lấy dayOffId/sourceId trước, sau đó mới đến id
      // KHÔNG dùng notificationId vì đó là ID của notification, không phải ID của entity
      final directId =
          data["dayOffId"] ?? // Ưu tiên dayOffId cho DayOff
          data["sourceId"] ?? // sourceId cho các loại khác
          data["id"] ??
          data["Id"] ??
          data["ID"];

      // Nếu notificationData là Map, thử lấy từ đó
      Map<String, dynamic>? nestedData;
      if (notificationData is Map<String, dynamic>) {
        nestedData = notificationData;
      }

      final wrappedType =
          nestedData?["type"] ??
          nestedData?["Type"] ??
          nestedData?["TYPE"] ??
          nestedData?["source"];
      // Ưu tiên lấy dayOffId/sourceId từ nested data
      final wrappedId =
          nestedData?["dayOffId"] ??
          nestedData?["sourceId"] ??
          nestedData?["id"] ??
          nestedData?["Id"] ??
          nestedData?["ID"];

      final rawType = wrappedType ?? directType;
      // Ưu tiên wrappedId/directId, KHÔNG dùng notification.notificationId
      final id = wrappedId ?? directId;

      print("🔔 Parsed - rawType: $rawType, id: $id");

      if (rawType == null || id == null) {
        print("❌ Missing type or id in notification data");
        print("❌ Available keys in data: ${data.keys.toList()}");
        if (nestedData != null) {
          print("❌ Available keys in nestedData: ${nestedData.keys.toList()}");
        }
        return;
      }

      await Future.delayed(Duration(milliseconds: 300));

      // Chỉ check case "DayOff" vào detail (case-insensitive)
      final rawTypeLower = rawType.toString().toLowerCase();
      if (rawTypeLower == "dayoff" || rawType == "DayOff") {
        await NavigationUtils.navigateByNotificationType(
          type: NotificationType.leaveRequest,
          id: id.toString(),
        );
      } else {
        // Xử lý các case khác
        final type = NotificationUtils.getNotificationType(rawType.toString());
        if (type == null) {
          print("❌ Unknown notification type: $rawType");
          return;
        }
        await NavigationUtils.navigateByNotificationType(
          type: type,
          id: id.toString(),
        );
      }
    } catch (e) {
      print("❌ Lỗi khi xử lý click notification: $e");
      print("❌ Stack trace: ${StackTrace.current}");
    }
  }

  static Future<void> clearCachedToken() async {
    _sentToken = null;
    final box = GetStorage();
    await box.remove(_storageKeyLastToken);
    await box.remove(_storageKeyDeviceUUID);
  }

  Future<void> unregisterPushToken() async {
    try {
      final box = GetStorage();
      final String? deviceUUID = box.read<String>(_storageKeyDeviceUUID);

      if (deviceUUID == null || deviceUUID.isEmpty) {
        print("Không tìm thấy deviceUUID để unregister");
        return;
      }

      final dio = DioApi();
      final data = {"deviceUUID": deviceUUID};

      try {
        final response = await dio.post(
          ApiEndpoints.unregisterNotification,
          data: data,
        );
        print("Unregister token thành công: $response");
        await clearCachedToken();
      } catch (e) {
        print("Unregister token thất bại: $e");
      }
    } catch (e) {
      print("Lỗi khi unregister push token: $e");
    }
  }
}
