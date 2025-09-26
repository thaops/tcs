import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approver_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approval_list_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_request_model.dart';
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
    try {
      isLoading = true;

      // Log để debug API call
      print(
        '[LeaveManagementRepository] getListOff - FromDate: ${firstDayOfMonth.toIso8601String()}',
      );
      print(
        '[LeaveManagementRepository] getListOff - ToDate: ${lastDayOfMonth.toIso8601String()}',
      );
      print(
        '[LeaveManagementRepository] getListOff - API Endpoint: ${ApiEndpoints.listoffListView}',
      );

      final response = await dio.post(
        ApiEndpoints.listoffListView,
        data: {
          "FromDate": firstDayOfMonth.toIso8601String(),
          "ToDate": lastDayOfMonth.toIso8601String(),
          "PageIndex": 1,
          "PageSize": 50,
        },
      );
      if (response.data['statusCode'] == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> jsonResponse = response.data;
        final List<dynamic> leaveRequestJson = jsonResponse['data'];

        // Log response từ API
        print(
          '[LeaveManagementRepository] getListOff - API Response statusCode: ${response.data['statusCode']}',
        );
        print(
          '[LeaveManagementRepository] getListOff - Số lượng records từ API: ${leaveRequestJson.length}',
        );

        // Parse new API response format
        List<LeaveRequest> leaveRequests =
            leaveRequestJson
                .map((json) => LeaveRequest.fromJson(json))
                .toList();

        // Convert to Employee for backward compatibility
        List<Employee> employees =
            leaveRequests
                .map((leaveRequest) => leaveRequest.toEmployee())
                .toList();

        print(
          '[LeaveManagementRepository] getListOff - Số lượng employees sau convert: ${employees.length}',
        );
        return employees;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<LeaveID?> getLeaveID(String leaveId, BuildContext context) async {
    try {
      isLoading = true;
      final response = await dio.get(ApiEndpoints.getLeaveIDV2(leaveId));

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        final Map<String, dynamic> jsonResponse = response.data;
        final Map<String, dynamic> leaveJson = jsonResponse['data'];
        return LeaveID.fromJson(leaveJson);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<LeaveType>?> getLeave(BuildContext context) async {
    try {
      final response = await dio.get(ApiEndpoints.getLeaveV2);
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
      return null;
    }
  }

  Future<bool> deleteLeave(String dayyOffId, BuildContext context) async {
    try {
      final response = await dio.delete(
        ApiEndpoints.deleteLeaveIDV2(dayyOffId),
      );

      if (response.data['statusCode'] == HttpStatusCodes.STATUS_CODE_OK) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelLeave(
    String dayyOffId,
    BuildContext context, [
    String reason = '',
  ]) async {
    try {
      debugPrint(
        'Cancel leave URL: ${ApiEndpoints.cancelLeaveIDV2(dayyOffId)}',
      );
      debugPrint('Cancel leave data: {Id: $dayyOffId, Reason: $reason}');

      final response = await dio.post(
        ApiEndpoints.cancelLeaveIDV2(dayyOffId),
        data: {'Id': dayyOffId, 'Reason': reason},
      );

      if (response.data['statusCode'] == HttpStatusCodes.STATUS_CODE_OK) {
        return true;
      } else {
        // Lưu message từ server để sử dụng sau
        final message = response.data['Message'] ?? 'Hủy đơn xin nghỉ thất bại';
        debugPrint('Server response: ${response.data}');
        throw Exception(message);
      }
    } catch (e) {
      // Re-throw để message được truyền lên
      rethrow;
    }
  }

  @override
  Future<AddDayOffResponseModel> addLeave(
    Map<String, dynamic> addData,
    BuildContext context,
  ) async {
    try {
      // Tạo map dữ liệu cho FormData
      final Map<String, dynamic> formDataMap = {
        'EmployeeId': addData['employeeId'] ?? '',
        'FullName': addData['fullName'] ?? '',
        'FromDate': addData['fromDate'] ?? '',
        'ToDate': addData['toDate'] ?? '',
        'CategoryId': addData['categoryId'] ?? '',
        'Reason': addData['reason'] ?? '',
      };

      // Thêm file đính kèm nếu có
      if (addData['attachmentFiles'] != null &&
          addData['attachmentFiles'] is List) {
        final List<Map<String, dynamic>> attachmentFiles =
            addData['attachmentFiles'] as List<Map<String, dynamic>>;

        // Tạo danh sách MultipartFile cho multiple files
        List<MultipartFile> attachmentFilesList = [];

        for (int i = 0; i < attachmentFiles.length; i++) {
          final Map<String, dynamic> file = attachmentFiles[i];
          final String? filePath = file['path'];
          final String fileName = file['name'] ?? 'attachment';

          if (filePath != null && filePath.isNotEmpty) {
            // Thêm file thực tế vào danh sách
            attachmentFilesList.add(
              await MultipartFile.fromFile(filePath, filename: fileName),
            );
          }
        }

        // Gán danh sách files vào FormData
        if (attachmentFilesList.isNotEmpty) {
          formDataMap['AttachmentIds'] = attachmentFilesList;
        }
      }

      // Tạo FormData từ map
      final formData = FormData.fromMap(formDataMap);

      final response = await dio.post(
        ApiEndpoints.createLeaveIDV2(), // Sử dụng endpoint v2
        data: formData,
        // Không cần thiết lập headers, Dio sẽ tự động xử lý
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

  @override
  Future<AddDayOffResponseModel> updateLeave(
    Map<String, dynamic> updateData,
    String leaveId,
    BuildContext context,
  ) async {
    try {
      // Tạo map dữ liệu cho FormData
      final Map<String, dynamic> formDataMap = {
        'EmployeeId': updateData['employeeId'] ?? '',
        'FullName': updateData['fullName'] ?? '',
        'FromDate': updateData['fromDate'] ?? '',
        'ToDate': updateData['toDate'] ?? '',
        'CategoryId': updateData['categoryId'] ?? '',
        'Reason': updateData['reason'] ?? '',
      };

      // Thêm file đính kèm nếu có
      if (updateData['attachmentFiles'] != null &&
          updateData['attachmentFiles'] is List) {
        final List<Map<String, dynamic>> attachmentFiles =
            updateData['attachmentFiles'] as List<Map<String, dynamic>>;

        // Tạo danh sách MultipartFile cho multiple files
        List<MultipartFile> attachmentFilesList = [];

        for (int i = 0; i < attachmentFiles.length; i++) {
          final Map<String, dynamic> file = attachmentFiles[i];
          final String? filePath = file['path'];
          final String fileName = file['name'] ?? 'attachment';

          if (filePath != null && filePath.isNotEmpty) {
            // Gửi file thực tế
            final multipartFile = await MultipartFile.fromFile(
              filePath,
              filename: fileName,
            );
            attachmentFilesList.add(multipartFile);
          }
        }

        // Gán danh sách files vào FormData (giống như addLeave)
        if (attachmentFilesList.isNotEmpty) {
          formDataMap['attachmentIds'] = attachmentFilesList;
          print(
            'Update: Sending ${attachmentFilesList.length} files as attachmentIds',
          );
        }
      }

      // Thêm danh sách file bị xóa
      if (updateData['deletedAttachmentIds'] != null &&
          updateData['deletedAttachmentIds'] is List) {
        final List<String> deletedIds =
            (updateData['deletedAttachmentIds'] as List).cast<String>();
        if (deletedIds.isNotEmpty) {
          formDataMap['deleteAttachmentIds'] = deletedIds;
          print(
            'Update: Deleting ${deletedIds.length} attachments: $deletedIds',
          );
        }
      }

      // Tạo FormData từ map
      final formData = FormData.fromMap(formDataMap);

      final response = await dio.put(
        ApiEndpoints.updateLeaveIDV2(leaveId), // Sử dụng endpoint v2
        data: formData,
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
        ApiEndpoints.approveLeaveV2(approveId),
        data: jsonEncode(approveData),
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
      return <String>[];
    }
  }

  @override
  Future<List<Approver>> getListApprover(int? step, String? keyword) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getListApproverV2(step, keyword),
      );
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
      return <Approver>[];
    }
  }

  // Method mới để gọi API get-list-approval-by
  Future<List<ApprovalData>> getListApprovalByUser(String leaveOffId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.getListApprovalByUserV2(leaveOffId),
      );
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
      return <ApprovalData>[];
    }
  }
}
