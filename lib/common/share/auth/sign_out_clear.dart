import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/router/one_signal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOutClear extends GetxService {
  Future<void> signOut() async {
    final Services services = await Services.create();
    final MyId _myId = await MyId.create();
    try {
      await services.deleteAccessToken();
      await _myId.deleteMyId();
      await _myId.deleteMyName();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // await OneSignalService.clearCachedToken();
      Get.offAllNamed(AppRouter.login);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out or clear cache: $e');
      throw Exception('Failed to sign out or clear cache: $e');
    }
  }
}
