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

  @override
  void onInit() {
    super.onInit();
    // Ensure months are generated as soon as the controller is injected,
    // so other controllers depending on it won't read an empty list.
    generateMonths();
  }

  void generateMonths() {
    months.clear();
    final DateTime now = DateTime.now();

    // Tạo 12 tháng từ tháng 1 đến tháng 12 của năm hiện tại
    for (int month = 1; month <= 12; month++) {
      final DateTime firstDay = DateTime(now.year, month, 1, 0, 0, 0, 0, 0);
      final DateTime lastDateOfMonth = DateTime(now.year, month + 1, 0);
      final DateTime lastDay = DateTime(
        lastDateOfMonth.year,
        lastDateOfMonth.month,
        lastDateOfMonth.day,
        23,
        59,
        59,
        999,
        0,
      );
      months.add({'firstDay': firstDay, 'lastDay': lastDay});
    }
  }

  Future<void> fetchListOff(
    DateTime firstDay,
    DateTime lastDay, {
    bool forceFetch = false,
  }) async {
    if (!forceFetch && isDataLoaded) return;

    try {
      isLoading.value = true;
      final response = await _getListOff(firstDay, lastDay);

      // Client-side filtering to ensure only employees with leave requests within the selected month are shown
      List<Employee> filteredEmployees = [];
      if (response != null) {
        filteredEmployees =
            response.where((employee) {
              // For new API format, check employee's own fromDate/toDate instead of dayOffs
              if (employee.dayOffs.isNotEmpty) {
                // Old format: Check if any dayOff falls within the selected month range
                return employee.dayOffs.any((dayOff) {
                  final fromDate = dayOff.fromDate;
                  final toDate = dayOff.toDate;

                  // Check if the dayOff period overlaps with the selected month
                  final fromDateInMonth =
                      fromDate.isAfter(firstDay.subtract(Duration(days: 1))) &&
                      fromDate.isBefore(lastDay.add(Duration(days: 1)));
                  final toDateInMonth =
                      toDate.isAfter(firstDay.subtract(Duration(days: 1))) &&
                      toDate.isBefore(lastDay.add(Duration(days: 1)));

                  // Include if the dayOff period overlaps with the selected month
                  return fromDateInMonth || toDateInMonth;
                });
              } else {
                // New format: Check employee's own fromDate/toDate
                final fromDate = employee.fromDate;
                final toDate = employee.toDate;

                // Skip if dates are null
                if (fromDate == null || toDate == null) {
                  return false;
                }

                // Check if the leave request period overlaps with the selected month
                final fromDateInMonth =
                    fromDate.isAfter(firstDay.subtract(Duration(days: 1))) &&
                    fromDate.isBefore(lastDay.add(Duration(days: 1)));
                final toDateInMonth =
                    toDate.isAfter(firstDay.subtract(Duration(days: 1))) &&
                    toDate.isBefore(lastDay.add(Duration(days: 1)));

                // Include if the leave request period overlaps with the selected month
                return fromDateInMonth || toDateInMonth;
              }
            }).toList();
      }

      listOff.value = filteredEmployees;

      // Diagnostics
      final missingCount =
          listOff.where((e) => (e.department ?? '').trim().isEmpty).length;
      if (kDebugMode) {
        // ignore: avoid_print
        print(
          '[LeaveListController] Filtered ${response?.length ?? 0} -> ${filteredEmployees.length} leaves for month ${firstDay.month}/${firstDay.year} (range: ${firstDay.day}/${firstDay.month} - ${lastDay.day}/${lastDay.month})',
        );
        print(
          '[LeaveListController] without department: $missingCount / ${listOff.length}',
        );
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
