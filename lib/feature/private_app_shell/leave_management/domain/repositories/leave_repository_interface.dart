// Domain repository interface for Leave Management (GetX remains in presentation)
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approver_model.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';

abstract class LeaveRepositoryInterface {
  Future<List<Employee>?> getListOff(
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
  );

  Future<LeaveID?> getLeaveID(String leaveId, BuildContext context);

  Future<List<LeaveType>?> getLeave(BuildContext context);

  Future<bool> deleteLeave(String dayyOffId, BuildContext context);

  Future<bool> cancelLeave(String dayyOffId, BuildContext context);

  Future<AddDayOffResponseModel> approveLeave(
    Map<String, dynamic> approveData,
    String approveId,
    dynamic status,
    BuildContext context,
  );

  Future<AddDayOffResponseModel> addLeave(
    Map<String, dynamic> addData,
    BuildContext context,
  );

  Future<AddDayOffResponseModel> updateLeave(
    Map<String, dynamic> updateData,
    String leaveId,
    BuildContext context,
  );

  // Departments for filter
  Future<List<String>> getDepartmentNames();

  Future<List<Approver>> getListApprover(int? step, String? keyword);
}
