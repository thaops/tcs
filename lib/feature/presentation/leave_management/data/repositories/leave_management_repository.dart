import 'dart:convert';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';
import 'package:tcs_flutter/src/config/constants/url/url.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LeaveManagementRepository extends ChangeNotifier {
  final DioApi dio = DioApi();
  bool isLoading = false;

  Future<String> getBaseUrl(BuildContext context) async {
    return await BaseUrlProvider.getBaseUrl(context);
  }

  Future<String?> _getAccessToken() async {
    final authService = AuthService();
    return await authService.getAccessToken();
  }

  Future<Options> _createOptions() async {
    final accessToken = await _getAccessToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<Employee>?> getListOff(DateTime firstDayOfMonth,
      DateTime lastDayOfMonth) async {
    try {
      isLoading = true;
      final response = await dio.get(
        ApiEndpoints.listoff(firstDayOfMonth, lastDayOfMonth));
        print("response.getListOff: ${response.data}");
      if (response.data['statusCode'] == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> employeeJson = jsonResponse['data'];
        List<Employee> employee = employeeJson
            .map((employeeJson) => Employee.fromJson(employeeJson))
            .toList();
        return employee;
      } else {
        print('Failed to load list of employees: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<LeaveID?> getLeaveID(String leaveId, BuildContext context) async {
    try {
      isLoading = true;
      final response = await dio.get(ApiEndpoints.getLeaveID(leaveId));
      print("response.getLeaveID: ${response.data}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final Map<String, dynamic> leaveJson = jsonResponse['data'];
        return LeaveID.fromJson(leaveJson);
      } else {
        print('Failed to load task');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Future<AddDayOffResponseModel> addLeave(
  //     Map<String, dynamic> addData, BuildContext context) async {
  //   final String baseUrl = await getBaseUrl(context);
  //   final String url = '$baseUrl/dayoff/add-day-off';

  //   try {
  //     final options = await _createOptions();
  //     final response = await dio.post(
  //       url,
  //       options: options,
  //       data: jsonEncode(addData),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = response.data as Map<String, dynamic>;
  //       return AddDayOffResponseModel.fromJson(data);
  //     } else {
  //       return AddDayOffResponseModel(
  //         statusCode: response.statusCode ?? 500,
  //         message: 'Request failed with status: ${response.statusCode}',
  //         totalRecord: 0,
  //         data: true,
  //       );
  //     }
  //   } catch (e) {
  //     return AddDayOffResponseModel(
  //       statusCode: 500,
  //       message: 'An error occurred: $e',
  //       totalRecord: 0,
  //       data: true,
  //     );
  //   }
  // }

  Future<List<LeaveType>?> getLeave(BuildContext context) async {
    try {
      final options = await _createOptions();
      final response = await dio.get(ApiEndpoints.getLeave);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> leaveJson = jsonResponse['data'];
        List<LeaveType> leaves = leaveJson
            .map((leaveJson) => LeaveType.fromJson(leaveJson))
            .toList();
        return leaves;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> deleteLeave(String dayyOffId, BuildContext context) async {

    try {
      final response = await dio.delete(ApiEndpoints.deleteLeaveID(dayyOffId));

      if (response.data['statusCode'] == 200) {
        print('Task deleted successfully');
        return true;
      } else {
        print('Failed to delete task');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Future<AddDayOffResponseModel> updateLeave(Map<String, dynamic> updateData,
  //     String leaveId, BuildContext context) async {
  //   final String baseUrl = await getBaseUrl(context);
  //   final String url = '$baseUrl/dayoff/update-day-off/$leaveId';

  //   try {
  //     final options = await _createOptions();
  //     final response = await dio.put(
  //       url,
  //       options: options,
  //       data: jsonEncode(updateData),
  //     );

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = response.data as Map<String, dynamic>;
  //       return AddDayOffResponseModel.fromJson(data);
  //     } else {
  //       return AddDayOffResponseModel(
  //         statusCode: response.statusCode ?? 500,
  //         message: 'Request failed with status: ${response.statusCode}',
  //         totalRecord: 0,
  //         data: true,
  //       );
  //     }
  //   } catch (e) {
  //     return AddDayOffResponseModel(
  //       statusCode: 500,
  //       message: 'An error occurred: $e',
  //       totalRecord: 0,
  //       data: true,
  //     );
  //   }
  // }

  Future<AddDayOffResponseModel> approveLeave(Map<String, dynamic> approveData,
      String approveId, status, BuildContext context) async {
    try {
      final response = await dio.post(
        ApiEndpoints.approveLeave(approveId),
        data: jsonEncode(approveData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return AddDayOffResponseModel.fromJson(data);
      } else {
        return AddDayOffResponseModel(
          statusCode: response.statusCode ?? 500,
          message: 'Request failed with status: ${response.statusCode}',
          totalRecord: 0,
          data: true,
        );
      }
    } catch (e) {
      return AddDayOffResponseModel(
        statusCode: 500,
        message: 'An error occurred: $e',
        totalRecord: 0,
        data: true,
      );
    }
  }
}
