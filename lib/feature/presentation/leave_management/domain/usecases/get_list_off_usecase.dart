import 'package:tcs_flutter/feature/presentation/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';

class GetListOffUseCase {
  final LeaveRepositoryInterface repository;
  GetListOffUseCase(this.repository);

  Future<List<Employee>?> call(DateTime firstDayOfMonth, DateTime lastDayOfMonth) {
    return repository.getListOff(firstDayOfMonth, lastDayOfMonth);
    }
}
