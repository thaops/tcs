import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';

class AddLeaveUseCase {
  final LeaveRepositoryInterface repository;
  AddLeaveUseCase(this.repository);

  Future<AddDayOffResponseModel> call(
    Map<String, dynamic> addData,
    BuildContext context,
  ) {
    return repository.addLeave(addData, context);
  }
}
