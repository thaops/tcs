import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_request_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_list_off_usecase.dart';

class LeaveListController extends GetxController {
  final LeaveRepositoryInterface repository;
  late final GetListOffUseCase _getListOff;

  LeaveListController({LeaveRepositoryInterface? repo})
    : repository = repo ?? LeaveManagementRepository() {
    _getListOff = GetListOffUseCase(repository);
  }

  final RxList<LeaveRequest> listOff = <LeaveRequest>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalRecords = 0.obs;

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
      // Reset pagination khi fetch mới
      currentPage.value = 1;
      hasMore.value = true;

      final response = await _getListOff(firstDay, lastDay, currentPage.value);

      // TEMPORARY: Disable filtering to debug UI issue
      // TODO: Re-enable filtering after fixing the issue
      List<LeaveRequest> filteredLeaves = [];
      if (response != null) {
        // Show all leave requests for debugging
        filteredLeaves = response.toList();

        // Original filtering logic (commented out for debugging)
        /*
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
        */
      }

      listOff.value = filteredLeaves;

      // Kiểm tra có còn data để load more không
      if (filteredLeaves.length < 50) {
        // PageSize = 50
        hasMore.value = false;
      }

      isDataLoaded = true;
    } catch (e) {
      // Handle error silently
    } finally {
      isLoading.value = false;
    }
  }

  // Method để load more data
  Future<void> loadMore(DateTime firstDay, DateTime lastDay) async {
    // Kiểm tra điều kiện trước khi load more
    if (!hasMore.value || isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;

      final response = await _getListOff(firstDay, lastDay, currentPage.value);

      if (response != null && response.isNotEmpty) {
        // Append new data vào list hiện tại
        listOff.addAll(response);

        // Kiểm tra có còn data để load more không
        if (response.length < 50) {
          // PageSize = 50 - không còn data để load
          hasMore.value = false;
        }
      } else {
        // Không có data mới - không còn data để load
        hasMore.value = false;
      }
    } catch (e) {
      // Handle error silently
      currentPage.value--; // Rollback page nếu có lỗi
      hasMore.value = false; // Dừng load more khi có lỗi
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Method để reset pagination khi clear filter
  void resetPagination() {
    currentPage.value = 1;
    hasMore.value = true;
    isDataLoaded = false;
  }
}
