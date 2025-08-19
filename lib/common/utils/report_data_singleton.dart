// import 'package:get/get.dart';
// import 'package:tcs_flutter/common/model/key_value_model.dart';
// import 'package:tcs_flutter/common/repositoty/dio_api.dart';
// import 'package:tcs_flutter/common/Services/api_endpoints.dart';
// import 'package:tcs_flutter/common/constants/http_status_codes.dart';

// // Singleton class để quản lý dữ liệu
// class ReportDataSingleton {
//   // Instance duy nhất của Singleton
//   static final ReportDataSingleton _instance = ReportDataSingleton._internal();

//   // Factory constructor để trả về instance duy nhất
//   factory ReportDataSingleton() {
//     return _instance;
//   }

//   // Private constructor
//   ReportDataSingleton._internal();

//   // Dữ liệu được lưu trữ
//   List<KeyValueModel> reportTypeData = [];
//   List<KeyValueModel> reportStatusData = [];

//   final DioApi dioApi = DioApi();

//   // Hàm kiểm tra xem dữ liệu đã được tải chưa
//   bool get isDataLoaded => reportTypeData.isNotEmpty && reportStatusData.isNotEmpty;

//   // Hàm lấy dữ liệu từ API và lưu vào Singleton
//   Future<void> fetchData() async {
//     try {
//       if (!isDataLoaded) {
//         final typeData = await _fetchReportType(ApiEndpoints.reportType);
//         final statusData = await _fetchReportType(ApiEndpoints.reportStatus);
//         reportTypeData = typeData;
//         reportStatusData = statusData;
//       }
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Lỗi khi tải dữ liệu: $e');
//     }
//   }

//   // Hàm gọi API để lấy dữ liệu
//   Future<List<KeyValueModel>> _fetchReportType(String apiEndpoints) async {
//     try {
//       final response = await dioApi.get(apiEndpoints);
//       if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
//         if (response.data['data'] is List) {
//           final data = response.data['data'] as List<dynamic>;
//           return data.map((e) => KeyValueModel.fromJson(e)).toList();
//         } else {
//           Get.snackbar('Lỗi', 'Dữ liệu API không đúng định dạng');
//           return [];
//         }
//       } else {
//         Get.snackbar('Lỗi', 'Không thể tải dữ liệu: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching report type: $e');
//       Get.snackbar('Lỗi', 'Lỗi khi tải dữ liệu: $e');
//       return [];
//     }
//   }

//   // Hàm làm mới dữ liệu
//   Future<void> refreshData() async {
//     reportTypeData.clear();
//     reportStatusData.clear();
//     await fetchData();
//   }

//   // Hàm xóa dữ liệu
//   void clearData() {
//     reportTypeData.clear();
//     reportStatusData.clear();
//   }
// }