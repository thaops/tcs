import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/router/app_router.dart';

class AuthUtils {
  static Future<void> checkLoginAndNavigate({
    VoidCallback? onLoggedIn,
  }) async {
    try {
      final service = await Services.create();
      final accessToken = await service.getAccessToken();
      final isLoggedIn = accessToken.isNotEmpty;

      if (isLoggedIn) {
        await Future.delayed(Duration.zero); // Đảm bảo ổn định frame

        final currentRoute = Get.currentRoute;

        if (currentRoute.isEmpty || currentRoute == '/') {
          await Get.toNamed(AppRouter.main);
        }

        onLoggedIn?.call();
      } else {
        if (Get.currentRoute != AppRouter.login) {
          await Get.offAllNamed(AppRouter.login);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

