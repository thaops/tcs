import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';

class CancelLeaveUseCase {
  final LeaveRepositoryInterface repository;
  CancelLeaveUseCase(this.repository);

  Future<bool> call(
    String dayyOffId,
    BuildContext context, [
    String reason = '',
  ]) {
    return repository.cancelLeave(dayyOffId, context, reason);
  }
}
