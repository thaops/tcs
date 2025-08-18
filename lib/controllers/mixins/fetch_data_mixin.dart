import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/common/widgets/custom_snackbar.dart';
import 'package:tcs_flutter/controllers/base/base_controller.dart';
import 'package:dio/dio.dart';

mixin FetchDataMixin<T> on BaseController {
  final _data = Rxn<T>();
  T? get data => _data.value;

  Future<void> fetchData();

  void setData(T? newData) {
    _data.value = newData;
  }

  Future<void> refreshData() async {
    if (status == ControllerStatus.refreshing) return;
    setStatus(ControllerStatus.refreshing);
    await fetchData();
  }

  Future<void> fetchApiData(
    {required Future<dynamic> Function() apiCall,
    required Function(dynamic) onSuccess,
    Function(dynamic)? onError }
  ) async {
    try {
      setStatus(ControllerStatus.loading);
      final response = await apiCall();
      if (response.data['statusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
        final error = response.data['message'] ?? 'Unknown error';
        setStatus(ControllerStatus.error, error: error);
        CustomSnackbar.show(error);
        return;
      }
      onSuccess(response.data['data']);
    } catch (e) {
      onError?.call(e) ?? setStatus(ControllerStatus.error, error: e.toString());
    }
  }
}

extension FetchHelper on FetchDataMixin {
  Future<void> fetchListModel<T>({
    required Future<Response<dynamic>> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    await fetchApiData(
      apiCall: apiCall,
      onSuccess: (data) {
        final list = (data as List).map((e) => fromJson(e)).toList();
        setData(list);
        setStatus(list.isEmpty ? ControllerStatus.empty : ControllerStatus.success);
      },
    );
  }
}
