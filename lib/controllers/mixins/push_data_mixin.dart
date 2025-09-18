import 'package:get/get.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/common/widgets/custom_snackbar.dart';
import 'package:tcs_flutter/controllers/base/base_controller.dart';

mixin PushDataMixin<T> on BaseController {
  final _data = Rxn<T>();
  T? get data => _data.value;

  Future<void> pushData();

  void setData(T? newData) {
    _data.value = newData;
  }

  Future<void> postData(
    {required Future<dynamic> Function() apiCall,
    required Function(dynamic) onSuccess,
    Function(dynamic)? onError }
  ) async {
    if(status == ControllerStatus.loading) return;
    try {
      setStatus(ControllerStatus.loading);
      final response = await apiCall();
      if (response.data['statusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
        final error = response.data['message'] ?? '';
        setStatus(ControllerStatus.error, error: error);
        CustomSnackbar.show(error);
        return;
      }
      onSuccess(response.data['data']);
    } catch (e) {
      onError?.call(e) ?? setStatus(ControllerStatus.error, error: e.toString());
      print("Error Call APi: $e");
    }
  }
}