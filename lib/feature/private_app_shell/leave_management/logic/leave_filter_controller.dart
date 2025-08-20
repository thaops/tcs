import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_list_controller.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart' as leave_model;
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_departments_usecase.dart';

DateTime _firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1, 0, 0, 0, 0, 0);
}

DateTime _lastDayOfMonth(DateTime date) {
  // End of day (inclusive)
  final d = DateTime(date.year, date.month + 1, 0);
  return DateTime(d.year, d.month, d.day, 23, 59, 59, 999, 0);
}

class LeaveFilterController extends GetxController {
  // Repository & UseCase
  final LeaveRepositoryInterface leaveRepository;
  late final GetDepartmentsUseCase _getDepartments;
  LeaveFilterController({LeaveRepositoryInterface? repo})
      : leaveRepository = repo ?? LeaveManagementRepository() {
    _getDepartments = GetDepartmentsUseCase(leaveRepository);
  }
  RxBool isLoading = false.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime> endDate = DateTime.now().obs;
  final listController = Get.find<LeaveListController>();
  // Department filter
  final RxString departmentId = ''.obs;
  final RxList<Item> departmentItems = <Item>[].obs;
  // Status filter
  final RxString statusId = ''.obs;
  final RxList<Item> statusItems = <Item>[].obs;

  @override
  onInit() {
    super.onInit();
    // Đặt mốc đầu/cuối tháng tại thời điểm khởi tạo (bao gồm giờ phút giây)
    final now = DateTime.now();
    final months = listController.months;
    if (months.length > 1 && months[1]['firstDay'] != null && months[1]['lastDay'] != null) {
      startDate.value = months[1]['firstDay']!;
      endDate.value = months[1]['lastDay']!;
    } else {
      // Fallback an toàn nếu months chưa được khởi tạo
      startDate.value = _firstDayOfMonth(now);
      endDate.value = _lastDayOfMonth(now);
    }
    // Không gọi các hàm khác để tránh ghi đè khoảng ngày mặc định
  }

  bool isValidDateRange() {
    if (startDate.value.isAfter(endDate.value)) {
      Get.snackbar(
          "Ngày không hợp lệ", "Ngày bắt đầu không được lớn hơn ngày kết thúc.",
          backgroundColor: AppColors.white);
      return false;
    }
    return true;
  }

  void setStartAndEndDates() {
    DateTime currentDate = DateTime.now();

    startDate.value = DateTime(currentDate.year, currentDate.month, 1, 0, 0, 0, 0, 0);

    final lastDateOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    endDate.value = DateTime(
      lastDateOfMonth.year,
      lastDateOfMonth.month,
      lastDateOfMonth.day,
      23,
      59,
      59,
      999,
      0,
    );
  }

  // Helpers for department filter
  void setDepartmentsFromNames(List<String> departmentNames) {
    final hasUnknown = departmentNames.any((e) => (e).trim().isEmpty);
    final unique = departmentNames
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    final items = unique.map((name) => Item(id: name, name: name)).toList();
    final List<Item> result = [Item(id: '', name: 'Tất cả')] + items;
    if (hasUnknown) {
      result.add(Item(id: '__unknown__', name: 'Không xác định'));
    }
    departmentItems.assignAll(result);
    // Đảm bảo selectedId hợp lệ với danh sách mới
    final depIds = departmentItems.map((e) => e.id).toSet();
    if (!depIds.contains(departmentId.value)) {
      departmentId.value = '';
    }
  }

  void clearDepartment() {
    departmentId.value = '';
  }

  void clearStatus() {
    statusId.value = '';
  }

  Future<void> fetchDepartments() async {
    try {
      isLoading.value = true;
      final names = await _getDepartments();
      setDepartmentsFromNames(names);
    } catch (_) {
      // ignore error, keep items as-is
    } finally {
      isLoading.value = false;
    }
  }

  // Xây danh sách phòng ban từ FilterUserController (API phòng ban mới)
  void setDepartmentsFromController(FilterUserController controller, List<leave_model.Employee> employees) {
    // Chỉ lấy các phòng thực sự xuất hiện trong danh sách xin nghỉ (theo tháng/khoảng thời gian hiện tại)
    final presentDeps = employees
        .map((e) => (controller.departmentNameForEmployee(e.employeeId) ?? (e.department ?? '')).trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    // detect unknown: có nhân viên mà không map được tên phòng
    final hasUnknown = employees.any((e) {
      final dep = controller.departmentNameForEmployee(e.employeeId) ?? (e.department ?? '');
      return dep.trim().isEmpty;
    });

    final items = presentDeps.map((n) => Item(id: n, name: n)).toList();
    final List<Item> result = [Item(id: '', name: 'Tất cả'), ...items];
    if (hasUnknown) {
      result.add(Item(id: '__unknown__', name: 'Không xác định'));
    }
    departmentItems.assignAll(result);
    // Đảm bảo selectedId hợp lệ với danh sách mới
    final depIds = departmentItems.map((e) => e.id).toSet();
    if (!depIds.contains(departmentId.value)) {
      departmentId.value = '';
    }
  }

  // Xây danh sách trạng thái từ danh sách xin nghỉ hiện tại
  void setStatusesFromEmployees(List<leave_model.Employee> employees) {
    final names = employees
        .map((e) => (e.statusLabel ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    final hasUnknown = employees.any((e) => (e.statusLabel ?? '').trim().isEmpty);

    final items = names.map((n) => Item(id: n, name: n)).toList();
    final List<Item> result = [Item(id: '', name: 'Tất cả'), ...items];
    if (hasUnknown) {
      result.add(Item(id: '__unknown_status__', name: 'Không xác định'));
    }
    statusItems.assignAll(result);
    // Đảm bảo selectedId hợp lệ với danh sách mới
    final sttIds = statusItems.map((e) => e.id).toSet();
    if (!sttIds.contains(statusId.value)) {
      statusId.value = '';
    }
  }
}
