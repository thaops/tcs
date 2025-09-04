import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/utils/check_awaiting_services.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approver_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approval_list_model.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';
import 'package:tcs_flutter/src/config/constants/url/url.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';

class LeaveManagementRepository extends ChangeNotifier
    implements LeaveRepositoryInterface {
  final DioApi dio = DioApi();
  bool isLoading = false;

  Future<String> getBaseUrl(BuildContext context) async {
    return await BaseUrlProvider.getBaseUrl(context);
  }

  Future<List<Employee>?> getListOff(
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
  ) async {
    final checkAwaitingServices = CheckAwaitingServices(GetStorage());
    final ischeckApple = await checkAwaitingServices.getawaiting();
    try {
      isLoading = true;
      final response = await dio.get(
        ischeckApple
            ? ApiEndpoints.listoffApple(firstDayOfMonth, lastDayOfMonth)
            : ApiEndpoints.listoff(firstDayOfMonth, lastDayOfMonth),
      );
      print("response.getListOffss: ${response.data}");
      if (response.data['statusCode'] == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> employeeJson = jsonResponse['data'];
        List<Employee> employee =
            employeeJson
                .map((employeeJson) => Employee.fromJson(employeeJson))
                .toList();
        return employee;
      } else {
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

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
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

  Future<List<LeaveType>?> getLeave(BuildContext context) async {
    try {
      final response = await dio.get(ApiEndpoints.getLeave);
      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> leaveJson = jsonResponse['data'];
        List<LeaveType> leaves =
            leaveJson
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

      if (response.data['statusCode'] == HttpStatusCodes.STATUS_CODE_OK) {
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

  @override
  Future<AddDayOffResponseModel> addLeave(
    Map<String, dynamic> addData,
    BuildContext context,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.careateleave,
        data: jsonEncode(addData),
      );
      print("response.addLeave: ${response.data}");

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return AddDayOffResponseModel.fromJson(data);
      } else {
        return AddDayOffResponseModel(
          statusCode:
              response.statusCode ??
              HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
          message: 'Request failed with status: ${response.statusCode}',
          totalRecord: 0,
          data: false,
        );
      }
    } catch (e) {
      return AddDayOffResponseModel(
        statusCode: HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
        message: 'An error occurred: $e',
        totalRecord: 0,
        data: false,
      );
    }
  }

  @override
  Future<AddDayOffResponseModel> updateLeave(
    Map<String, dynamic> updateData,
    String leaveId,
    BuildContext context,
  ) async {
    try {
      final response = await dio.put(
        ApiEndpoints.updateleave(leaveId),
        data: jsonEncode(updateData),
      );

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return AddDayOffResponseModel.fromJson(data);
      } else {
        return AddDayOffResponseModel(
          statusCode:
              response.statusCode ??
              HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
          message: 'Request failed with status: ${response.statusCode}',
          totalRecord: 0,
          data: false,
        );
      }
    } catch (e) {
      return AddDayOffResponseModel(
        statusCode: HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
        message: 'An error occurred: $e',
        totalRecord: 0,
        data: false,
      );
    }
  }

  Future<AddDayOffResponseModel> approveLeave(
    Map<String, dynamic> approveData,
    String approveId,
    status,
    BuildContext context,
  ) async {
    try {
      final response = await dio.post(
        ApiEndpoints.approveLeave(approveId),
        data: jsonEncode(approveData),
      );
      print("response.approveLeave: ${response.data}");

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return AddDayOffResponseModel.fromJson(data);
      } else {
        return AddDayOffResponseModel(
          statusCode:
              response.statusCode ??
              HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
          message: 'Request failed with status: ${response.statusCode}',
          totalRecord: 0,
          data: false,
        );
      }
    } catch (e) {
      return AddDayOffResponseModel(
        statusCode: HttpStatusCodes.STATUS_CODE_INTERNAL_SERVER_ERROR,
        message: 'An error occurred: $e',
        totalRecord: 0,
        data: false,
      );
    }
  }

  @override
  Future<List<String>> getDepartmentNames() async {
    try {
      final response = await dio.post(
        ApiEndpoints.departments,
        data: {"string": "string"},
      );
      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final list =
            (response.data is Map && response.data['data'] is List)
                ? (response.data['data'] as List)
                : <dynamic>[];
        final names =
            list
                .map(
                  (e) =>
                      (e is Map && e['name'] != null)
                          ? e['name'].toString().trim()
                          : '',
                )
                .where((s) => s.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
        return names;
      }
      return <String>[];
    } catch (e) {
      print('Error fetching departments: $e');
      return <String>[];
    }
  }

  @override
  Future<List<Approver>> getListApprover(int? step, String? keyword) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getListApprover(step, keyword),
      );
      print("response.getListApprover: ${response.data}");
      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final list =
            (response.data is Map && response.data['data'] is List)
                ? (response.data['data'] as List)
                : <dynamic>[];
        final approvers = list.map((e) => Approver.fromJson(e)).toList();
        return approvers;
      }
      return <Approver>[];
    } catch (e) {
      print('Error fetching approvers: $e');
      return <Approver>[];
    }
  }

  // Method mới để gọi API get-list-approval-by
  Future<List<ApprovalData>> getListApprovalByUser(String leaveOffId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getListApprovalByUser(leaveOffId),
      );
      print("response.getListApprovalByUser: ${response.data}");
      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final list =
            (response.data is Map && response.data['data'] is List)
                ? (response.data['data'] as List)
                : <dynamic>[];
        final approvals = list.map((e) => ApprovalData.fromJson(e)).toList();
        return approvals;
      }
      return <ApprovalData>[];
    } catch (e) {
      print('Error fetching approval list by user: $e');
      return <ApprovalData>[];
    }
  }
}
