import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/src/Api/models/users_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/get_leave_types_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/update_leave_usecase.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';

class LeaveUpdateController extends GetxController {
  // Các biến reactive để theo dõi trạng thái thay đổi
  Rx<LeaveID?> leave = Rx<LeaveID?>(null);
  RxString? category = RxString('');
  String? usersID;
  String? leaveID;
  RxList<UserModel>? users = <UserModel>[].obs;
  List<LeaveType>? leaves;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  RxBool isLoading = false.obs;
  late TextEditingController controllerNote;

  // Các trường cho file đính kèm
  List<String> attachmentIds = [];
  List<Map<String, dynamic>> attachmentFiles = [];

  final LeaveRepositoryInterface leaveManagementRepository;
  late final GetLeaveTypesUseCase _getLeaveTypes;
  late final UpdateLeaveUseCase _updateLeave;
  LeaveUpdateController({LeaveRepositoryInterface? repo})
    : leaveManagementRepository = repo ?? LeaveManagementRepository() {
    _getLeaveTypes = GetLeaveTypesUseCase(leaveManagementRepository);
    _updateLeave = UpdateLeaveUseCase(leaveManagementRepository);
  }

  @override
  void onInit() {
    super.onInit();
    final LeaveUpdateData? arguments = Get.arguments as LeaveUpdateData?;
    leave.value = arguments?.leave;
    debugPrint("leave: ${leave.toString()}");
    category!.value = arguments?.category ?? '';

    if (leave.value != null) {
      usersID = leave.value!.employeeId!;
      leaveID = leave.value!.categoryId!;
      startDate.value = leave.value!.fromDate;
      dueDate.value = leave.value!.toDate;
      controllerNote = TextEditingController(text: leave.value!.reason);
    } else {
      controllerNote = TextEditingController(text: '');
    }
  }

  @override
  void onReady() {
    super.onReady();
    fetchLeave();
  }

  void updateDate(DateTime newDate, bool isStartDate) {
    if (isStartDate) {
      startDate.value = newDate;
    } else {
      dueDate.value = newDate;
    }
  }

  Future<void> leaveUpdate(BuildContext context) async {
    if (leaveID == null || usersID == null) {
      Get.snackbar('Thông báo', 'Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (startDate.value == null || dueDate.value == null) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.',
      );
      return;
    }
    if (dueDate.value!.isBefore(startDate.value!)) {
      Get.snackbar(
        'Thông báo',
        'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.',
      );
      return;
    }

    final String leaveId = leave.value?.id.toString() ?? '';

    Map<String, dynamic> updateData = {
      'reason': controllerNote.text,
      'fromDate': startDate.value!.toIso8601String(),
      'toDate': dueDate.value!.toIso8601String(),
      'categoryId': leaveID,
      'employeeId': usersID,
      'attachmentIds': attachmentIds,
      'attachmentFiles': attachmentFiles,
    };

    try {
      isLoading.value = true;
      final result = await _updateLeave(updateData, leaveId, context);
      if (result.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        Get.back(result: true);
        Get.snackbar('Thành công', 'Cập nhật đơn xin phép thành công');
      } else {
        Get.snackbar('Thất bại', 'Đơn xin phép thất bại: ${result.message}');
      }
    } catch (e) {
      debugPrint("error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLeave() async {
    try {
      isLoading.value = true;
      final ctx = Get.context;
      if (ctx == null) {
        return;
      }
      final response = await _getLeaveTypes(ctx);
      leaves = response ?? [];
    } catch (e) {
      debugPrint('Error fetching leave types: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool get canEdit {
    final l = leave.value;
    if (l == null) return false;
    final bool isApproved = (l.status == 2) || (l.statusLabel == 'Đã duyệt');
    return !isApproved;
  }

  // Phương thức quản lý file đính kèm
  void addAttachment(
    String attachmentId, {
    String? filePath,
    String? fileName,
    int? fileSize,
  }) {
    if (!attachmentIds.contains(attachmentId)) {
      attachmentIds.add(attachmentId);
      attachmentFiles.add({
        'id': attachmentId,
        'path': filePath,
        'name': fileName ?? 'File đính kèm',
        'size': fileSize ?? 0,
      });
    }
  }

  void removeAttachment(String attachmentId) {
    attachmentIds.remove(attachmentId);
    attachmentFiles.removeWhere((file) => file['id'] == attachmentId);
  }

  void clearAttachments() {
    attachmentIds.clear();
    attachmentFiles.clear();
  }
}
