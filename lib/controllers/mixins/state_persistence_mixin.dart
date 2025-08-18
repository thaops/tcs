import 'package:tcs_flutter/controllers/base/base_controller.dart';

mixin StatePersistenceMixin on BaseController {
  // Declare storageKey without initializing it here
  late final String storageKey;

  Future<void> saveState();

  Future<void> restoreState();

  @override
  void onClose() {
    saveState();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    restoreState();
  }
}