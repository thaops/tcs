import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';

class DeleteLeaveUseCase {
  final LeaveRepositoryInterface repository;
  DeleteLeaveUseCase(this.repository);

  Future<bool> call(String dayyOffId, BuildContext context) {
    return repository.deleteLeave(dayyOffId, context);
  }
}
