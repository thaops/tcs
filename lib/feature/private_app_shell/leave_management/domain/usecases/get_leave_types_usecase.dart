import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';

class GetLeaveTypesUseCase {
  final LeaveRepositoryInterface repository;
  GetLeaveTypesUseCase(this.repository);

  Future<List<LeaveType>?> call(BuildContext context) {
    return repository.getLeave(context);
  }
}
