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
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_widgets.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';

class LeaveScreen extends StatefulWidget {
  final Function(bool) onUpdateCallback;
  const LeaveScreen({Key? key, required this.onUpdateCallback})
    : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with AutomaticKeepAliveClientMixin {
  final LeaveListController listController = Get.put(LeaveListController());
  final LeaveFilterController _leaveFilterController = Get.put(
    LeaveFilterController(),
  );
  final FilterUserController filterUserController = Get.put(
    FilterUserController(),
  );
  DateTime? selectedMonth;
  final Rx<DateTime?> _userSelectedStart = Rx<DateTime?>(null);
  final Rx<DateTime?> _userSelectedEnd = Rx<DateTime?>(null);
  final RxString _filterInfoText = ''.obs;

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateFilterInfo() {
    final range = _getCurrentTimeRange();
    final start = range['start']!;
    final end = range['end']!;
    _filterInfoText.value =
        'Đang lọc từ ${_formatDate(start)} đến ${_formatDate(end)}';
  }

  void _resetFilter() {
    // Reset về filter mặc định
    _userSelectedStart.value = null;
    _userSelectedEnd.value = null;

    // Clear department và status filter
    _leaveFilterController.clearDepartment();
    _leaveFilterController.clearStatus();

    // Update filter info text
    _updateFilterInfo();

    // Gọi API với filter mặc định
    final range = _getCurrentTimeRange();
    _fetchListOff(range['start']!, range['end']!, forceFetch: true);
  }

  Widget _buildFilterInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Obx(
              () => Text(
                _filterInfoText.value,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Obx(
            () =>
                _userSelectedStart.value != null &&
                        _userSelectedEnd.value != null
                    ? GestureDetector(
                      onTap: _resetFilter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.clear, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Bỏ filter',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchListOff(
    DateTime firstDay,
    DateTime lastDay, {
    bool forceFetch = false,
  }) async {
    await listController.fetchListOff(
      firstDay,
      lastDay,
      forceFetch: forceFetch,
    );
    _leaveFilterController.setDepartmentsFromNames(
      listController.listOff.map((e) => e.department ?? '').toList(),
    );
  }

  DateTimeRange _getDefaultRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1, 0, 0, 0, 0, 0);
    final lastDay = DateTime(now.year, 12, 31, 23, 59, 59, 999, 0);
    return DateTimeRange(start: firstDay, end: lastDay);
  }

  Map<String, DateTime> _getCurrentTimeRange() {
    if (_userSelectedStart.value != null && _userSelectedEnd.value != null) {
      return {
        'start': _userSelectedStart.value!,
        'end': _userSelectedEnd.value!,
      };
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1, 0, 0, 0, 0, 0);
    final end = DateTime(now.year, 12, 31, 23, 59, 59, 999, 0);
    return {'start': start, 'end': end};
  }

  @override
  void initState() {
    super.initState();
    listController.generateMonths();
    if (filterUserController.employeeIdToDepartment.isEmpty) {
      filterUserController.fetchUserList();
    }
    final now = DateTime.now();
    selectedMonth = DateTime(now.year, now.month, 1);

    if (!listController.isDataLoaded) {
      final range = _getDefaultRange();
      _fetchListOff(range.start, range.end);
    }

    _updateFilterInfo();
  }

  @override
  bool get wantKeepAlive => true;

  void _addScreen() {
    Get.toNamed(AppRouter.leaveCreate, arguments: _fetchListOff)?.then((value) {
      if (value == true) {
        widget.onUpdateCallback(true);
        final range = _getCurrentTimeRange();
        _fetchListOff(range['start']!, range['end']!, forceFetch: true);
      }
    });
  }

  Future<void> refresh() async {
    final range = _getCurrentTimeRange();
    await _fetchListOff(range['start']!, range['end']!, forceFetch: true);
    if (!mounted) return;
    setState(() {});
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
              colorfirst: AppColors.primary,
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
                final range = _getCurrentTimeRange();
                _leaveFilterController.startDate.value = range['start']!;
                _leaveFilterController.endDate.value = range['end']!;
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
                            final prevDep =
                                _leaveFilterController.departmentId.value;
                            final prevStatus =
                                _leaveFilterController.statusId.value;

                            final userStart =
                                _leaveFilterController.startDate.value;
                            final userEnd =
                                _leaveFilterController.endDate.value;
                            _userSelectedStart.value = userStart;
                            _userSelectedEnd.value = userEnd;
                            _updateFilterInfo();

                            await _fetchListOff(
                              userStart,
                              userEnd,
                              forceFetch: true,
                            );

                            _leaveFilterController.setDepartmentsFromController(
                              filterUserController,
                              listController.listOff.toList(),
                            );
                            _leaveFilterController.setStatusesFromEmployees(
                              listController.listOff.toList(),
                            );

                            _leaveFilterController.departmentId.value = prevDep;
                            _leaveFilterController.statusId.value = prevStatus;

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
                  _buildFilterInfo(),
                  Obx(() {
                    if (listController.isLoading.value) {
                      return const Expanded(child: Center(child: SizedBox()));
                    } else if (listController.listOff.isEmpty &&
                        listController.isDataLoaded) {
                      return Expanded(child: EmptyLottieState());
                    } else {
                      final depId = _leaveFilterController.departmentId.value;
                      final baseList = listController.listOff.toList();
                      final afterDept =
                          depId.isEmpty
                              ? baseList
                              : (depId == '__unknown__'
                                  ? baseList.where((e) {
                                    final mapped = filterUserController
                                        .departmentNameForEmployee(
                                          e.employeeId,
                                        );
                                    final dep =
                                        (mapped ?? e.department ?? '').trim();
                                    return dep.isEmpty;
                                  }).toList()
                                  : baseList.where((e) {
                                    final mapped = filterUserController
                                        .departmentNameForEmployee(
                                          e.employeeId,
                                        );
                                    final dep =
                                        (mapped ?? e.department ?? '').trim();
                                    return dep == depId;
                                  }).toList());

                      final statusId = _leaveFilterController.statusId.value;
                      final afterStatus =
                          statusId.isEmpty
                              ? afterDept
                              : (statusId == '__unknown_status__'
                                  ? afterDept
                                      .where(
                                        (e) =>
                                            (e.statusLabel ?? '')
                                                .trim()
                                                .isEmpty,
                                      )
                                      .toList()
                                  : afterDept
                                      .where(
                                        (e) =>
                                            (e.statusLabel ?? '').trim() ==
                                            statusId,
                                      )
                                      .toList());

                      return _leave_list(afterStatus);
                    }
                  }),
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
              final range = _getCurrentTimeRange();
              _fetchListOff(range['start']!, range['end']!, forceFetch: true);
            }
          },
        ),
      ),
    );
  }
}
