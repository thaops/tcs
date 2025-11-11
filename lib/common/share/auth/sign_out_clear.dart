import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/share/auth/controller_cache_clear.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/router/one_signal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutClear extends GetxService {
  /// Clear tất cả dữ liệu và cache khi đăng xuất
  Future<void> signOut() async {
    try {
      // 0. Unregister OneSignal push token trước khi clear data
      try {
        final oneSignalService = OneSignalService();
        await oneSignalService.unregisterPushToken();
      } catch (e) {
        print('Error unregistering push token: $e');
      }

      // 1. Clear access token và authentication data
      final Services services = await Services.create();
      await services.deleteAccessToken();

      // 2. Clear user ID và name cache
      final MyId _myId = await MyId.create();
      await _myId.deleteMyId();
      await _myId.deleteMyName();

      // 3. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 4. Clear GetStorage (local storage) nhưng giữ manual environment
      final GetStorage storage = GetStorage();
      final String? savedBaseUrl = storage.read<String>('base_url');
      final bool? isManualEnv = storage.read<bool>('manual_environment_set');
      await storage.erase();

      // Khôi phục manual environment nếu có
      if (savedBaseUrl != null &&
          savedBaseUrl.isNotEmpty &&
          isManualEnv == true) {
        await storage.write('base_url', savedBaseUrl);
        await storage.write('manual_environment_set', true);
        print("Restored manual environment: $savedBaseUrl");
      }

      // 5. Navigate to login screen trước khi clear controllers
      if (Get.context != null) {
        Get.offAllNamed(AppRouter.login);
      }

      // 6. Delay để đảm bảo navigation hoàn tất trước khi clear
      await Future.delayed(Duration(milliseconds: 300));

      // 7. Clear controllers nhưng KHÔNG reset GetX hoàn toàn
      ControllerCacheClear.clearControllersOnly();

      // 8. Clear OneSignal cached token (nếu cần)
      // await OneSignalService.clearCachedToken();
    } catch (e) {
      // Log error nhưng vẫn navigate về login
      print('Error during sign out: $e');
      Get.snackbar(
        'Lỗi',
        'Có lỗi xảy ra khi đăng xuất, nhưng bạn vẫn có thể tiếp tục',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      // Vẫn navigate về login ngay cả khi có lỗi
      if (Get.context != null) {
        Get.offAllNamed(AppRouter.login);
      }
    }
  }

  /// Clear chỉ cache mà không đăng xuất
  Future<void> clearCacheOnly() async {
    try {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear GetStorage nhưng giữ manual environment
      final GetStorage storage = GetStorage();
      final String? savedBaseUrl = storage.read<String>('base_url');
      final bool? isManualEnv = storage.read<bool>('manual_environment_set');
      await storage.erase();

      // Khôi phục manual environment nếu có
      if (savedBaseUrl != null &&
          savedBaseUrl.isNotEmpty &&
          isManualEnv == true) {
        await storage.write('base_url', savedBaseUrl);
        await storage.write('manual_environment_set', true);
        print("Restored manual environment in clearCacheOnly: $savedBaseUrl");
      }

      // Clear user cache
      final MyId _myId = await MyId.create();
      await _myId.deleteMyId();
      await _myId.deleteMyName();

      // Clear controllers cache (không reset GetX)
      ControllerCacheClear.clearControllersOnly();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Clear chỉ leave management cache
  Future<void> clearLeaveCache() async {
    try {
      ControllerCacheClear.clearLeaveControllers();
    } catch (e) {
      print('Error clearing leave cache: $e');
    }
  }

  /// Clear chỉ user cache
  Future<void> clearUserCache() async {
    try {
      ControllerCacheClear.clearUserControllers();
    } catch (e) {
      print('Error clearing user cache: $e');
    }
  }
}
