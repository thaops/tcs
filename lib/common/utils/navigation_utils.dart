import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/utils/auth_utils.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';
import 'package:tcs_flutter/router/app_router.dart';

class NavigationUtils {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> navigateByNotificationType({
    required NotificationType type,
    required String id,
  }) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      final context = navigatorKey.currentContext;
      if (context == null) {
        print("❌ Navigator context is null! Retrying ($retryCount/$maxRetries)");
        retryCount++;
        await Future.delayed(Duration(milliseconds: 500));
        continue;
      }

      final routeInfo = _getRouteInfo(type, id);
      print("🚀 Navigating to: ${routeInfo.route} with id: $id");

      try {
        await AuthUtils.checkLoginAndNavigate(
          onLoggedIn: () {
            Future.delayed(Duration(milliseconds: 300), () {
              Get.toNamed(
                routeInfo.route,
                arguments: routeInfo.arguments,
                preventDuplicates: true,
              );
            });
          },
        );
        return;
      } catch (e) {
        print("❌ Navigation error: $e");
        return;
      }
    }
    print("❌ Failed to navigate after $maxRetries retries");
  }

  static ({String route, Map<String, dynamic>? arguments}) _getRouteInfo(
    NotificationType type,
    String id,
  ) {
    switch (type) {
      case NotificationType.leaveRequest:
        return (route: AppRouter.leaveDetail, arguments: {'leaveId': id});
      case NotificationType.task:
        return (route: AppRouter.task_detail, arguments: {'taskId': id});
      case NotificationType.meeting:
        return (route: AppRouter.board_detail, arguments: {'meetingId': id});
    }
  }
}