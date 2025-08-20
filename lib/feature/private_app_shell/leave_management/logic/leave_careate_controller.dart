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
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  Rx<DateTime> dueDate = Rx<DateTime>(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59));
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

  // Kiểm tra tính hợp lệ của dữ liệu
  bool _validateLeaveData(
      leaveID, usersID, _dueDate, _startDate, BuildContext context) {
    if (leaveID == null || usersID == null) {
      _showSnackBar(context, 'Vui lòng điền đầy đủ thông tin');
      return false;
    }
    if (_dueDate.value.isBefore(_startDate.value)) {
      _showSnackBar(context, 'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.');
      return false;
    }
    // if (_startDate.value.isBefore(DateTime.now().add(Duration(days: 1)))) {
    //   _showSnackBar(context, 'Bạn phải xin nghỉ trước ít nhất 2 ngày.');
    //   return false;
    // }
    return true;
  }

  // Hiển thị thông báo Snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
}
