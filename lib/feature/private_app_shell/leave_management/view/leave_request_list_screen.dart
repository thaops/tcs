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

  

  @override
  void initState() {
    super.initState();
    listController.generateMonths();
    if (filterUserController.employeeIdToDepartment.isEmpty) {
      filterUserController.fetchUserList();
    }
    if (!listController.isDataLoaded) {
      _fetchListOff(listController.months[1]['firstDay']!, listController.months[1]['lastDay']!);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _addScreen() {
    Get.toNamed(AppRouter.leaveCreate, arguments: _fetchListOff)?.then((value) {
      if (value == true) {
        widget.onUpdateCallback(true);
        _fetchListOff(listController.months[1]['firstDay']!, listController.months[1]['lastDay']!, forceFetch: true);
      }
    });
  }

  Future<void> refresh() async {
    await _fetchListOff(listController.months[1]['firstDay']!, listController.months[1]['lastDay']!, forceFetch: true);
    if (!mounted) return;
    setState(() {
      selectedMonth = null;
    });
    _leaveFilterController.clearDepartment();
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
              _fetchListOff(listController.months[1]['firstDay']!, listController.months[1]['lastDay']!, forceFetch: true);
            }
          },
        ),
      ),
    );
  }
}