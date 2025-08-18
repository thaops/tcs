import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';


class InAppUpdateUtil {
  Future<void> checkForUpdates() async {
    // Chỉ chạy trên Android
    if (!Platform.isAndroid) {
      print('In-App Updates chỉ hỗ trợ trên Android');
      return;
    }

    try {
      // Kiểm tra cập nhật
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      print('Trạng thái cập nhật: ${updateInfo.updateAvailability}');
      print('Mức độ ưu tiên: ${updateInfo.updatePriority}');

      // Kiểm tra xem có bản cập nhật hay không
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.updatePriority >= 4) {
          // Cập nhật tức thì cho các bản cập nhật quan trọng
          AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
          if (result == AppUpdateResult.userDeniedUpdate) {
            Get.snackbar(
              'Cập nhật bị hủy',
              'Bạn cần cập nhật ứng dụng để tiếp tục sử dụng.',
              snackPosition: SnackPosition.BOTTOM,
            );
          } else if (result == AppUpdateResult.success) {
            print('Cập nhật tức thì thành công');
          }
        } else {
          // Cập nhật linh hoạt cho các bản cập nhật không quan trọng
          await InAppUpdate.startFlexibleUpdate();
          Get.snackbar(
            'Bản cập nhật sẵn sàng',
            'Đã tải xong bản cập nhật. Cài đặt ngay?',
            snackPosition: SnackPosition.BOTTOM,
            mainButton: TextButton(
              onPressed: () async {
                await InAppUpdate.completeFlexibleUpdate();
                print('Cập nhật linh hoạt hoàn tất');
              },
              child: Text('Cài đặt'),
            ),
          );
        }
      } else {
        print('Không có bản cập nhật mới');
      }
    } on PlatformException catch (e) {
      if (e.code == 'REQUIRE_CHECK_FOR_UPDATE') {
        print('Lỗi: Cần gọi checkForUpdate trước khi thực hiện cập nhật');
      } else if (e.message?.contains('ERROR_APP_NOT_OWNED') == true) {
        Get.snackbar(
          'Lỗi cập nhật',
          'Vui lòng cài đặt ứng dụng từ Google Play Store để nhận cập nhật.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print('Lỗi khác khi kiểm tra cập nhật: $e');
        Get.snackbar(
          'Lỗi cập nhật',
          'Đã xảy ra lỗi: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Lỗi không xác định: $e');
      Get.snackbar(
        'Lỗi không xác định',
        'Đã xảy ra lỗi khi kiểm tra cập nhật.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
