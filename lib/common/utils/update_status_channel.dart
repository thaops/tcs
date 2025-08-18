
import 'package:flutter/services.dart';

class UpdateManager {
  static const platform = MethodChannel('com.namphuongso.npp/update');

  /// Kiểm tra xem có bản cập nhật mới không
  Future<bool> checkForUpdate() async {
    try {
      final bool result = await platform.invokeMethod('checkForUpdate');
      return result;
    } catch (e) {
      print('Lỗi khi kiểm tra cập nhật: $e');
      return false;
    }
  }

  /// Bắt đầu cập nhật ngay lập tức
  Future<void> startImmediateUpdate() async {
    try {
      await platform.invokeMethod('startImmediateUpdate');
    } catch (e) {
      print('Lỗi khi bắt đầu cập nhật: $e');
    }
  }
}