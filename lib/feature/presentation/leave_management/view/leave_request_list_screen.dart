import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/logic/leave_filter_controller.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/widget/leave_filter_widget.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/widget/listoff_month_widget.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/widget/listoff_widgets.dart';
import 'package:tcs_flutter/common/widgets/state_widget/empty_lottie_state.dart';
import 'package:tcs_flutter/feature/presentation/user_list/controller/user_controller.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/controller/filter_user_controller.dart';

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
  final LeaveManagementRepository leaveManagementRepository = LeaveManagementRepository();
  final RxList<Employee> listOff = <Employee>[].obs;
  final _leaveFilterController = Get.put(LeaveFilterController());
  final FilterUserController filterUserController = Get.put(FilterUserController());
  final RxBool isLoading = false.obs;
  String errorMessage = '';
  List<Map<String, DateTime>> months = [];
  DateTime? selectedMonth;
  bool _isDataLoaded = false;

  Future<void> _fetchListOff(DateTime firstDay, DateTime lastDay, {bool forceFetch = false}) async {
    if (!forceFetch && _isDataLoaded) return;

    try {
      isLoading.value = true;
      final response = await leaveManagementRepository.getListOff(firstDay, lastDay);
      listOff.value = response ?? [];
      _leaveFilterController.setDepartmentsFromNames(
        listOff.map((e) => e.department ?? '').toList(),
      );
      // Diagnostics: count records without department
      final missingCount = listOff.where((e) => (e.department ?? '').trim().isEmpty).length;
      // ignore: avoid_print
      print('[LeaveScreen] Employees without department: $missingCount / ${listOff.length}');
      _isDataLoaded = true; // Đánh dấu dữ liệu đã tải
    } catch (e) {
      errorMessage = 'Đã xảy ra lỗi khi tải dữ liệu';
    } finally {
      isLoading.value = false;
    }
  }

  void _generateMonths() {
    DateTime now = DateTime.now();
    DateTime startMonth = (now.month == 12)
        ? DateTime(now.year + 1, 1, 1)
        : DateTime(now.year, now.month + 1, 1);

    for (int i = 0; i < 12; i++) {
      DateTime firstDay = DateTime(startMonth.year, startMonth.month - i, 1);
      DateTime lastDay = DateTime(startMonth.year, startMonth.month - i + 1, 1);
      months.add({
        'firstDay': firstDay,
        'lastDay': lastDay,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateMonths();
    // Đảm bảo map employeeId -> department đã sẵn sàng
    if (filterUserController.employeeIdToDepartment.isEmpty) {
      filterUserController.fetchUserList();
    }
    if (!_isDataLoaded) {
      _fetchListOff(months[1]['firstDay']!, months[1]['lastDay']!);
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _addScreen() {
    Get.toNamed(AppRouter.leaveCreate, arguments: _fetchListOff)?.then((value) {
      if (value == true) {
        widget.onUpdateCallback(true);
        _fetchListOff(months[1]['firstDay']!, months[1]['lastDay']!, forceFetch: true);
      }
    });
  }

  Future<void> refresh() async {
    await _fetchListOff(months[1]['firstDay']!, months[1]['lastDay']!, forceFetch: true);
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
          isLoading: isLoading.value,
          
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
                // Dùng mapping từ FilterUserController để build danh sách phòng ban
                _leaveFilterController.setDepartmentsFromController(
                  filterUserController,
                  listOff.toList(),
                );
                // Xây danh sách trạng thái từ dữ liệu hiện tại
                _leaveFilterController.setStatusesFromEmployees(
                  listOff.toList(),
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
                            // Ưu tiên gọi API trước
                            await _fetchListOff(
                              _leaveFilterController.startDate.value,
                              _leaveFilterController.endDate.value,
                              forceFetch: true,
                            );
                            // Sau khi có dữ liệu mới, build lại filter local
                            _leaveFilterController.setDepartmentsFromController(
                              filterUserController,
                              listOff.toList(),
                            );
                            _leaveFilterController.setStatusesFromEmployees(
                              listOff.toList(),
                            );
                            // Khôi phục lựa chọn để áp dụng filter ngay trên danh sách
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
                  MonthSelector(
                    months: months,
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
                      if (isLoading.value) {
                        return const Expanded(child: Center(child: SizedBox()));
                      } else if (listOff.isEmpty && _isDataLoaded) {
                        return Expanded(child: EmptyLottieState());
                      } else {
                        final depId = _leaveFilterController.departmentId.value;
                        final afterDept = depId.isEmpty
                            ? listOff.toList()
                            : (depId == '__unknown__'
                                ? listOff.where((e) {
                                    final mapped = filterUserController.departmentNameForEmployee(e.employeeId);
                                    final dep = (mapped ?? e.department ?? '').trim();
                                    return dep.isEmpty;
                                  }).toList()
                                : listOff.where((e) {
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
              _fetchListOff(months[1]['firstDay']!, months[1]['lastDay']!, forceFetch: true);
            }
          },
        ),
      ),
    );
  }
}