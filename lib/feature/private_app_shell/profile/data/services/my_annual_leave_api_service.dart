import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/my_annual_leave_model.dart';

class MyAnnualLeaveApiService {
  final DioApi _dioApi = DioApi();

  /// Lấy dữ liệu nguyện vọng phép năm của tôi
  Future<MyAnnualLeaveApiResponse> getMyAnnualLeaveData({
    required int year,
  }) async {
    try {
      final response = await _dioApi.get(ApiEndpoints.getMyAnnualLeave(year));

      if (response.statusCode == 200) {
        return MyAnnualLeaveApiResponse.fromJson(response.data);
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get my annual leave data: $e');
    }
  }

  /// Lưu dữ liệu nguyện vọng phép năm
  Future<bool> saveMyAnnualLeaveData({
    required int year,
    required Map<String, int> monthlyData,
  }) async {
    try {
      final response = await _dioApi.post(
        ApiEndpoints.saveAnnualLeave,
        data: {'year': year, 'monthlyData': monthlyData},
      );

      return response.statusCode == 200 && response.data['data'] == true;
    } catch (e) {
      throw Exception('Failed to save my annual leave data: $e');
    }
  }

  /// Cập nhật dữ liệu nguyện vọng phép năm
  Future<bool> updateMyAnnualLeaveData({
    required MyAnnualLeaveModel data,
    required int year,
  }) async {
    try {
      final response = await _dioApi.post(
        ApiEndpoints.updateAnnualLeave,
        data: {
          'id': data.id,
          'fullName': data.fullName,
          'employeeCode': data.employeeCode,
          'departmentCode': data.departmentCode,
          'departmentName': data.departmentName,
          'annualQuota': data.annualQuota,
          'registeredDays': data.registeredDays,
          'unusedDays': data.unusedDays,
          'year': year,
          'jan': data.jan,
          'feb': data.feb,
          'mar': data.mar,
          'apr': data.apr,
          'may': data.may,
          'jun': data.jun,
          'jul': data.jul,
          'aug': data.aug,
          'sep': data.sep,
          'oct': data.oct,
          'nov': data.nov,
          'dec': data.dec,
        },
      );

      print('Update API Response: ${response.data}');

      // Kiểm tra HTTP status code trước
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }

      // Kiểm tra statusCode từ server response
      final statusCode =
          response.data['StatusCode'] ?? response.data['statusCode'];

      if (statusCode == 200) {
        return true;
      } else {
        // Lấy message từ server và throw exception
        final message =
            response.data['Message'] ??
            response.data['message'] ??
            'Cập nhật thất bại';
        throw Exception(message);
      }
    } catch (e) {
      print('API Error: $e');
      // Re-throw exception để message được truyền lên
      rethrow;
    }
  }
}
