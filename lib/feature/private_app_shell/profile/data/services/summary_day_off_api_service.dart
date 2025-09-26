import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/summary_day_off_model.dart';

class SummaryDayOffApiService {
  final DioApi _dioApi = DioApi();

  /// Lấy dữ liệu tổng hợp ngày phép
  Future<SummaryDayOffApiResponse> getMySummaryDayOff({
    required int year,
  }) async {
    try {
      final response = await _dioApi.post(
        ApiEndpoints.getMySummaryDayOff(year),
        data: {},
      );

      if (response.statusCode == 200) {
        return SummaryDayOffApiResponse.fromJson(response.data);
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get summary day off data: $e');
    }
  }
}
