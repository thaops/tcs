import 'package:get/get.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:tcs_flutter/src/api/models/users_model.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/models/leave_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_flutter/src/config/customdialog/customdialog.dart';

class LeaveLogic extends GetxController {
  final LeaveManagementRepository leaveManagementRepository =
      LeaveManagementRepository();
  final CustomDialog customDialog = CustomDialog();
  bool isLoading = false;
  List<UserModel>? users;
  List<LeaveType>? leaves;
  int SUCCESS_CODE = 200;
  int ERROR_CODE = 400;

  Future<void> deleteLeave(String dayyOffId, BuildContext context) async {
    final bool? confirmDelete = await _showConfirmationDialog(
        context, 'Xác nhận xóa', 'Bạn muốn xóa đơn xin nghỉ này?');
    if (confirmDelete == true) {
      final bool success =
          await leaveManagementRepository.deleteLeave(dayyOffId, context);
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
      final response = await leaveManagementRepository.getLeave(context);
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
      return await leaveManagementRepository.getLeaveID(leaveId, context);
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
