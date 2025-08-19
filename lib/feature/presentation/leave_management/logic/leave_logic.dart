import 'package:get/get.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:tcs_flutter/src/api/models/users_model.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/models/leave_management.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/src/config/customdialog/customdialog.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/usecases/get_leave_types_usecase.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/usecases/get_leave_by_id_usecase.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/usecases/delete_leave_usecase.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';

class LeaveLogic extends GetxController {
  final LeaveRepositoryInterface leaveManagementRepository;
  late final GetLeaveTypesUseCase _getLeaveTypes;
  late final GetLeaveByIdUseCase _getLeaveById;
  late final DeleteLeaveUseCase _deleteLeave;
  LeaveLogic({LeaveRepositoryInterface? repo})
      : leaveManagementRepository = repo ?? LeaveManagementRepository() {
    _getLeaveTypes = GetLeaveTypesUseCase(leaveManagementRepository);
    _getLeaveById = GetLeaveByIdUseCase(leaveManagementRepository);
    _deleteLeave = DeleteLeaveUseCase(leaveManagementRepository);
  }
  final CustomDialog customDialog = CustomDialog();
  bool isLoading = false;
  List<UserModel>? users;
  List<LeaveType>? leaves;
  int SUCCESS_CODE = HttpStatusCodes.STATUS_CODE_OK;
  int ERROR_CODE = HttpStatusCodes.STATUS_CODE_BAD_REQUEST;

  Future<void> deleteLeave(String dayyOffId, BuildContext context) async {
    final bool? confirmDelete = await _showConfirmationDialog(
        context, 'Xác nhận xóa', 'Bạn muốn xóa đơn xin nghỉ này?');
    if (confirmDelete == true) {
      final bool success = await _deleteLeave(dayyOffId, context);
      _showSnackBar(
          context,
          success
              ? 'Xóa đơn xin nghỉ thành công'
              : 'Xóa đơn xin nghỉ thất bại');
      if (success) {
        Navigator.of(context).pop();
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Hủy')),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Xóa')),
          ],
        );
      },
    );
  }

}
