import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approver_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';

class DeleteLeaveUseCase {
  final LeaveRepositoryInterface repository;
  DeleteLeaveUseCase(this.repository);

  Future<bool> call(String dayyOffId, BuildContext context) {
    return repository.deleteLeave(dayyOffId, context);
  }
  Future<List<Approver>> getListApprover(int? step, String? keyword) {
    return repository.getListApprover(step, keyword);
}
}
