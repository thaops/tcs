import 'package:get/get.dart';

enum ControllerStatus { initial, loading, success, error, empty, refreshing }

abstract class BaseController extends GetxController {
  final _status = ControllerStatus.initial.obs;
  final _errorMessage = ''.obs;

  ControllerStatus get status => _status.value;
  String get errorMessage => _errorMessage.value;

  bool get isLoading => status == ControllerStatus.loading;
  bool get isSuccess => status == ControllerStatus.success;
  bool get isError => status == ControllerStatus.error;

  void setStatus(ControllerStatus newStatus, {String? error}) {
    _status.value = newStatus;
    if (error != null) _errorMessage.value = error;
  }

  @override
  void onClose() {
    super.onClose();
  }
}