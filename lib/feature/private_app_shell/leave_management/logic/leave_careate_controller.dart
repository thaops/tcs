import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/add_leave_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_leave_types_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/profile_logic.dart';

class LeaveCareateController extends GetxController {
  final controllerProfile = Get.put(ProfileLogic());

  final LeaveRepositoryInterface leaveManagementRepository;
  late final GetLeaveTypesUseCase _getLeaveTypes;
  late final AddLeaveUseCase _addLeave;
  LeaveCareateController({LeaveRepositoryInterface? repo})
    : leaveManagementRepository = repo ?? LeaveManagementRepository() {
    _getLeaveTypes = GetLeaveTypesUseCase(leaveManagementRepository);
    _addLeave = AddLeaveUseCase(leaveManagementRepository);
  }
  final RxList<LeaveType> leaves = <LeaveType>[].obs;
  RxBool isLoading = false.obs;

  String? usersID;
  String? leaveID;
  Rx<DateTime> startDate = Rx<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );
  Rx<DateTime> dueDate = Rx<DateTime>(
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
    ),
  );
  RxBool isloadingSave = false.obs;

  late TextEditingController controllerNote;

  @override
  void onInit() async {
    super.onInit();
    controllerNote = TextEditingController();
    MyId myId = await MyId.create();
    usersID = await myId.getMyId();
    // fetchUsers();
  }

  @override
  void onReady() {
    super.onReady();
    fetchLeave();
  }

  // Lưu tạo mới đơn nghỉ phép
  Future<void> save_create(BuildContext context) async {
    if (!_validateLeaveData(leaveID, usersID, dueDate, startDate, context))
      return;

    final Map<String, dynamic> addData = {
      'reason': controllerNote.text,
      'fromDate': startDate.value.toIso8601String(),
      'toDate': dueDate.value.toIso8601String(),
      'categoryId': leaveID,
      'employeeId': usersID,
    };

    try {
      isloadingSave.value = true;
      final result = await _addLeave(addData, context);

      if (result.data == false) {
        Get.snackbar("Thất bại", result.message);
        return;
      }
      Get.back(result: true);
      Get.snackbar("Thành công", "Tạo đơn nghỉ phép thành công");
    } catch (e) {
      print(e);
    } finally {
      isloadingSave.value = false;
    }
  }

  bool _validateLeaveData(
    leaveID,
    usersID,
    _dueDate,
    _startDate,
    BuildContext context,
  ) {
    if (leaveID == null || usersID == null) {
      _showSnackBar(context, 'Vui lòng điền đầy đủ thông tin');
      return false;
    }
    if (_dueDate.value.isBefore(_startDate.value)) {
      _showSnackBar(context, 'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.');
      return false;
    }

    return true;
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> fetchLeave() async {
    try {
      isLoading.value = true;
      final ctx = Get.context;
      if (ctx == null) {
        return;
      }
      final response = await _getLeaveTypes(ctx);
      leaves.assignAll(response ?? []);
    } catch (e) {
      print('Error fetching leave types: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDate(DateTime newDate, bool isStartDate) {
    if (isStartDate) {
      startDate.value = newDate;
    } else {
      dueDate.value = newDate;
    }
  }

  // Phương thức cập nhật startDate và tự động điều chỉnh dueDate
  void updateStartDate(DateTime newStartDate) {
    startDate.value = newStartDate;

    if (dueDate.value.isBefore(newStartDate) ||
        isSameDay(dueDate.value, newStartDate)) {
      dueDate.value = DateTime(
        newStartDate.year,
        newStartDate.month,
        newStartDate.day,
        23,
        59,
      );
    }
  }

  void updateDueDate(DateTime newDueDate) {
    dueDate.value = newDueDate;

    if (startDate.value.isAfter(newDueDate)) {
      startDate.value = DateTime(
        newDueDate.year,
        newDueDate.month,
        newDueDate.day,
        0,
        0,
      );
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
