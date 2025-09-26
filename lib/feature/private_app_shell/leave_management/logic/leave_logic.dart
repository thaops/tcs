import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:tcs_flutter/src/api/models/users_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/src/config/customdialog/customdialog.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_leave_types_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_leave_by_id_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/cancel_leave_usecase.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';

class LeaveLogic extends GetxController {
  final LeaveRepositoryInterface leaveManagementRepository;
  late final GetLeaveTypesUseCase _getLeaveTypes;
  late final GetLeaveByIdUseCase _getLeaveById;
  late final CancelLeaveUseCase _cancelLeave;
  LeaveLogic({LeaveRepositoryInterface? repo})
    : leaveManagementRepository = repo ?? LeaveManagementRepository() {
    _getLeaveTypes = GetLeaveTypesUseCase(leaveManagementRepository);
    _getLeaveById = GetLeaveByIdUseCase(leaveManagementRepository);
    _cancelLeave = CancelLeaveUseCase(leaveManagementRepository);
  }
  final CustomDialog customDialog = CustomDialog();
  bool isLoading = false;
  List<UserModel>? users;
  List<LeaveType>? leaves;
  int SUCCESS_CODE = HttpStatusCodes.STATUS_CODE_OK;
  int ERROR_CODE = HttpStatusCodes.STATUS_CODE_BAD_REQUEST;

  Future<void> deleteLeave(String dayyOffId, BuildContext context) async {
    // Hiển thị popup xác nhận trước khi hủy
    final bool? confirmCancel = await _showConfirmationDialog(
      context,
      'Xác nhận hủy',
      'Bạn có chắc chắn muốn hủy đơn xin nghỉ này?',
    );

    if (confirmCancel == true) {
      try {
        final bool success = await _cancelLeave.call(
          dayyOffId,
          context,
          '', // Mặc định để trống
        );
        _showSnackBar(
          context,
          success ? 'Hủy đơn xin nghỉ thành công' : 'Hủy đơn xin nghỉ thất bại',
        );
        if (success) {
          Navigator.of(
            context,
          ).pop(true); // Truyền true để báo hiệu cần refresh
        }
      } catch (e) {
        // Hiển thị message từ server
        final String errorMessage = e.toString().replaceFirst(
          'Exception: ',
          '',
        );
        _showSnackBar(context, errorMessage);
        debugPrint('Cancel leave error: $e');
      }
    }
  }

  Future<List<UserModel>?> fetchUsers(BuildContext context) async {
    final apiService = Get.put(ApiService());
    try {
      final response = await apiService.getUsers(context);
      return response?.isNotEmpty == true ? response : null;
    } catch (e) {
      print('Lỗi khi lấy người dùng: $e');
      return null;
    }
  }

  Future<List<LeaveType>> fetchLeave(BuildContext context) async {
    try {
      final response = await _getLeaveTypes(context);
      return response ?? [];
    } catch (e) {
      print('Error fetching leave data: $e');
      return [];
    }
  }

  Future<LeaveID?> getLeave(String leaveId, BuildContext context) async {
    try {
      isLoading = true;
      print("loadingnew...");
      print(isLoading);
      return await _getLeaveById(leaveId, context);
    } catch (e) {
      print('Error fetching leave: $e');
      return null;
    } finally {
      isLoading = false;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Hiển thị popup xác nhận hủy đơn
  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  /// Test method để kiểm tra cancel leave với message từ server
  Future<void> testCancelLeave(String dayyOffId, BuildContext context) async {
    try {
      final bool success = await _cancelLeave(dayyOffId, context);
      debugPrint('Cancel leave result: $success');
    } catch (e) {
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Cancel leave error message: $errorMessage');
      _showSnackBar(context, errorMessage);
    }
  }
}
