import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_list_off_usecase.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';

class LeaveListController extends GetxController {
  final LeaveRepositoryInterface repository;
  late final GetListOffUseCase _getListOff;

  LeaveListController({LeaveRepositoryInterface? repo})
      : repository = repo ?? LeaveManagementRepository() {
    _getListOff = GetListOffUseCase(repository);
  }

  final RxList<Employee> listOff = <Employee>[].obs;
  final RxBool isLoading = false.obs;

  final List<Map<String, DateTime>> months = [];
  bool isDataLoaded = false;

  void generateMonths() {
    months.clear();
    final DateTime now = DateTime.now();
    final DateTime startMonth = (now.month == 12)
        ? DateTime(now.year + 1, 1, 1)
        : DateTime(now.year, now.month + 1, 1);

    for (int i = 0; i < 12; i++) {
      final DateTime firstDay = DateTime(startMonth.year, startMonth.month - i, 1);
      final DateTime lastDay = DateTime(startMonth.year, startMonth.month - i + 1, 1);
      months.add({'firstDay': firstDay, 'lastDay': lastDay});
    }
  }

  Future<void> fetchListOff(DateTime firstDay, DateTime lastDay, {bool forceFetch = false}) async {
    if (!forceFetch && isDataLoaded) return;

    try {
      isLoading.value = true;
      final response = await _getListOff(firstDay, lastDay);
      print("response.getListOff: ${response}");
      listOff.value = response ?? [];
      // Diagnostics
      final missingCount = listOff.where((e) => (e.department ?? '').trim().isEmpty).length;
      if (kDebugMode) {
        // ignore: avoid_print
        print('[LeaveListController] without department: $missingCount / ${listOff.length}');
      }
      isDataLoaded = true;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[LeaveListController] fetchListOff error: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
