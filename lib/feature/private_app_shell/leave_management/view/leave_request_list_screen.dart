import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/state_widget/empty_lottie_state.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_filter_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_list_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_filter_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_month_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_widgets.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';

class LeaveScreen extends StatefulWidget {
  final Function(bool) onUpdateCallback;
  const LeaveScreen({
    Key? key,
    required this.onUpdateCallback,
  }) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> with AutomaticKeepAliveClientMixin {
  final LeaveListController listController = Get.put(LeaveListController());
  final LeaveFilterController _leaveFilterController = Get.put(LeaveFilterController());
  final FilterUserController filterUserController = Get.put(FilterUserController());
  DateTime? selectedMonth;
  // Track last fetched date range to avoid redundant API calls when filtering
  DateTime? _lastFetchedStart;
  DateTime? _lastFetchedEnd;
  

  Future<void> _fetchListOff(DateTime firstDay, DateTime lastDay, {bool forceFetch = false}) async {
    await listController.fetchListOff(firstDay, lastDay, forceFetch: forceFetch);
    _leaveFilterController.setDepartmentsFromNames(
      listController.listOff.map((e) => e.department ?? '').toList(),
    );
    // Update last fetched range
    _lastFetchedStart = firstDay;
    _lastFetchedEnd = lastDay;
  }

  // Default date range: prefer months[1] (current month per business rule),
  // fallback to current month's first/next-month-first if months is not ready.
  DateTimeRange _getDefaultRange() {
    if (listController.months.length > 1 &&
        listController.months[1]['firstDay'] != null &&
        listController.months[1]['lastDay'] != null) {
      return DateTimeRange(
        start: listController.months[1]['firstDay']!,
        end: listController.months[1]['lastDay']!,
      );
    }
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1, 0, 0, 0, 0, 0);
    final lastDateOfMonth = DateTime(now.year, now.month + 1, 0);
    final lastDay = DateTime(
      lastDateOfMonth.year,
      lastDateOfMonth.month,
      lastDateOfMonth.day,
      23,
      59,
      59,
      999,
      0,
    );
    return DateTimeRange(start: firstDay, end: lastDay);
  }

  

  @override
  void initState() {
    super.initState();
    listController.generateMonths();
    if (filterUserController.employeeIdToDepartment.isEmpty) {
      filterUserController.fetchUserList();
    }
    if (!listController.isDataLoaded) {
      final range = _getDefaultRange();
      _fetchListOff(range.start, range.end);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _addScreen() {
    Get.toNamed(AppRouter.leaveCreate, arguments: _fetchListOff)?.then((value) {
      if (value == true) {
        widget.onUpdateCallback(true);
        // Re-fetch using last range (or selected month) to keep current context
        DateTime start = _lastFetchedStart ?? listController.months.first['firstDay']!;
        DateTime end = _lastFetchedEnd ?? listController.months.first['lastDay']!;
        if (selectedMonth != null) {
          Map<String, DateTime>? item;
          for (final m in listController.months) {
            if (m['firstDay'] == selectedMonth) {
              item = m;
              break;
            }
          }
          if (item != null) {
            start = item['firstDay']!;
            end = item['lastDay']!;
          }
        }
        _fetchListOff(start, end, forceFetch: true);
      }
    });
  }

  Future<void> refresh() async {
    // Prefer last fetched range, then selectedMonth, then default
    DateTime? start = _lastFetchedStart;
    DateTime? end = _lastFetchedEnd;
    if (start == null || end == null) {
      if (selectedMonth != null) {
        Map<String, DateTime>? item;
        for (final m in listController.months) {
          if (m['firstDay'] == selectedMonth) {
            item = m;
            break;
          }
        }
        if (item != null) {
          start = item['firstDay'];
          end = item['lastDay'];
        }
      }
    }
    final fallback = _getDefaultRange();
    await _fetchListOff(start ?? fallback.start, end ?? fallback.end, forceFetch: true);
    if (!mounted) return;
    setState(() {}); // keep selectedMonth & filters as-is
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    return RefreshIndicator(
      onRefresh: refresh,
      child: Obx(
        () => LoadingOverlay(
          isLoading: listController.isLoading.value,
          
          child: Scaffold(
          backgroundColor: AppColors.white,
            appBar: AppBarWidget(
              title: "Danh sách nghỉ phép",
              isBack: false,
              isTitleCenter: false,
              iconRightfirst: Icons.add_circle_rounded,
              colorfirst: AppColors.yellow,
              functionfirst: _addScreen,
              iconRightSecond: Icons.filter_alt_rounded,
              colorSecond: AppColors.primary,
              functionSecond: () {
                _leaveFilterController.setDepartmentsFromController(
                  filterUserController,
                  listController.listOff.toList(),
                );
                _leaveFilterController.setStatusesFromEmployees(
                  listController.listOff.toList(),
                );
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: LeaveFilterWidget(
                          onFilter: () async {
                            // Lưu lại lựa chọn hiện tại để giữ filter sau khi refetch
                            final prevDep = _leaveFilterController.departmentId.value;
                            final prevStatus = _leaveFilterController.statusId.value;
                            final newStart = _leaveFilterController.startDate.value;
                            final newEnd = _leaveFilterController.endDate.value;
                            final hasPrev = _lastFetchedStart != null && _lastFetchedEnd != null;
                            final bool dateChanged = !hasPrev ||
                                !newStart.isAtSameMomentAs(_lastFetchedStart!) ||
                                !newEnd.isAtSameMomentAs(_lastFetchedEnd!);

                            if (dateChanged) {
                              // Gọi API khi khoảng ngày thay đổi
                              await _fetchListOff(
                                newStart,
                                newEnd,
                                forceFetch: true,
                              );
                              // Sau khi có dữ liệu mới, build lại filter local
                              _leaveFilterController.setDepartmentsFromController(
                                filterUserController,
                                listController.listOff.toList(),
                              );
                              _leaveFilterController.setStatusesFromEmployees(
                                listController.listOff.toList(),
                              );
                              // Khôi phục lựa chọn để áp dụng filter ngay trên danh sách
                              _leaveFilterController.departmentId.value = prevDep;
                              _leaveFilterController.statusId.value = prevStatus;
                            } else {
                              // Không đổi ngày: không gọi API, chỉ rebuild filter local và đóng
                              _leaveFilterController.setDepartmentsFromController(
                                filterUserController,
                                listController.listOff.toList(),
                              );
                              _leaveFilterController.setStatusesFromEmployees(
                                listController.listOff.toList(),
                              );
                              _leaveFilterController.departmentId.value = prevDep;
                              _leaveFilterController.statusId.value = prevStatus;
                            }
                            Get.back();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  MonthSelector(
                    months: listController.months,
                    selectedMonth: selectedMonth,
                    onMonthSelected: (firstDay, lastDay) {
                      setState(() {
                        selectedMonth = firstDay;
                      });
                      _fetchListOff(firstDay, lastDay, forceFetch: true);
                    },
                  ),
                  Obx(
                    () {
                      if (listController.isLoading.value) {
                        return const Expanded(child: Center(child: SizedBox()));
                      } else if (listController.listOff.isEmpty && listController.isDataLoaded) {
                        return Expanded(child: EmptyLottieState());
                      } else {
                        final depId = _leaveFilterController.departmentId.value;
                        final baseList = listController.listOff.toList();
                        final afterDept = depId.isEmpty
                            ? baseList
                            : (depId == '__unknown__'
                                ? baseList.where((e) {
                                    final mapped = filterUserController.departmentNameForEmployee(e.employeeId);
                                    final dep = (mapped ?? e.department ?? '').trim();
                                    return dep.isEmpty;
                                  }).toList()
                                : baseList.where((e) {
                                    final mapped = filterUserController.departmentNameForEmployee(e.employeeId);
                                    final dep = (mapped ?? e.department ?? '').trim();
                                    return dep == depId;
                                  }).toList());

                        final statusId = _leaveFilterController.statusId.value;
                        final afterStatus = statusId.isEmpty
                            ? afterDept
                            : (statusId == '__unknown_status__'
                                ? afterDept.where((e) => (e.statusLabel ?? '').trim().isEmpty).toList()
                                : afterDept.where((e) => (e.statusLabel ?? '').trim() == statusId).toList());

                        return _leave_list(afterStatus);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _leave_list(List<Employee> employee) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListWidgets(
          listOff: employee,
          onUpdateCallback: (isUpdate) {
            if (isUpdate) {
              // Re-fetch using current context
              DateTime start = _lastFetchedStart ?? listController.months.first['firstDay']!;
              DateTime end = _lastFetchedEnd ?? listController.months.first['lastDay']!;
              if (selectedMonth != null) {
                Map<String, DateTime>? item;
                for (final m in listController.months) {
                  if (m['firstDay'] == selectedMonth) {
                    item = m;
                    break;
                  }
                }
                if (item != null) {
                  start = item['firstDay']!;
                  end = item['lastDay']!;
                }
              }
              _fetchListOff(start, end, forceFetch: true);
            }
          },
        ),
      ),
    );
  }
}