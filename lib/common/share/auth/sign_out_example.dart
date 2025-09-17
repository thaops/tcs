import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';

/// Example sử dụng SignOutClear service
class SignOutExample {
  final SignOutClear _signOutClear = Get.find<SignOutClear>();

  /// Đăng xuất hoàn toàn - clear tất cả
  Future<void> fullSignOut() async {
    await _signOutClear.signOut();
  }

  /// Clear cache mà không đăng xuất
  Future<void> clearCacheOnly() async {
    await _signOutClear.clearCacheOnly();
  }

  /// Clear chỉ leave management cache
  Future<void> clearLeaveCache() async {
    await _signOutClear.clearLeaveCache();
  }

  /// Clear chỉ user cache
  Future<void> clearUserCache() async {
    await _signOutClear.clearUserCache();
  }
}

/// Cách sử dụng trong UI:
/// 
/// ```dart
/// // Trong một button onPressed:
/// onPressed: () async {
///   final signOutClear = Get.find<SignOutClear>();
///   await signOutClear.signOut();
/// }
/// 
/// // Hoặc clear cache mà không đăng xuất:
/// onPressed: () async {
///   final signOutClear = Get.find<SignOutClear>();
///   await signOutClear.clearCacheOnly();
/// }
/// ```
