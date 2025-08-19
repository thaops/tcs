import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';

class GetLeaveByIdUseCase {
  final LeaveRepositoryInterface repository;
  GetLeaveByIdUseCase(this.repository);

  Future<LeaveID?> call(String leaveId, BuildContext context) {
    return repository.getLeaveID(leaveId, context);
  }
}
