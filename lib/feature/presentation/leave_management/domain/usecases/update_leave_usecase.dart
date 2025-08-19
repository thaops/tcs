import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';

class UpdateLeaveUseCase {
  final LeaveRepositoryInterface repository;
  UpdateLeaveUseCase(this.repository);

  Future<AddDayOffResponseModel> call(
    Map<String, dynamic> updateData,
    String leaveId,
    BuildContext context,
  ) {
    return repository.updateLeave(updateData, leaveId, context);
  }
}
