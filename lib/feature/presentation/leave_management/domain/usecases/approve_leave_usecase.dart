import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';

class ApproveLeaveUseCase {
  final LeaveRepositoryInterface repository;
  ApproveLeaveUseCase(this.repository);

  Future<AddDayOffResponseModel> call(
    Map<String, dynamic> approveData,
    String approveId,
    dynamic status,
    BuildContext context,
  ) {
    return repository.approveLeave(approveData, approveId, status, context);
  }
}
