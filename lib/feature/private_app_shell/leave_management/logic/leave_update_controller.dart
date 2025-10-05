import 'package:flutter/material.dart';
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
  List<String> deletedAttachmentIds = []; // Danh sách ID file bị xóa

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

      // Load existing attachments từ leave request hiện tại
      _loadExistingAttachments();
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
      _showErrorSnackBar('Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (startDate.value == null || dueDate.value == null) {
      _showErrorSnackBar('Vui lòng chọn đủ ngày bắt đầu và ngày kết thúc.');
      return;
    }
    if (dueDate.value!.isBefore(startDate.value!)) {
      _showErrorSnackBar('Ngày kết thúc không được nhỏ hơn ngày bắt đầu.');
      return;
    }

    final String leaveId = leave.value?.id.toString() ?? '';

    final List<Map<String, dynamic>> newFiles =
        attachmentFiles
            .where(
              (file) =>
                  file['path'] != null && file['path'].toString().isNotEmpty,
            )
            .toList();

    Map<String, dynamic> updateData = {
      'reason': controllerNote.text,
      'fromDate': startDate.value!.toIso8601String(),
      'toDate': dueDate.value!.toIso8601String(),
      'categoryId': leaveID,
      'employeeId': usersID,
      'attachmentFiles': newFiles, // Chỉ gửi file mới
      'deletedAttachmentIds': deletedAttachmentIds, // Gửi danh sách file bị xóa
    };

    try {
      isLoading.value = true;
      final result = await _updateLeave(updateData, leaveId, context);

      // Debug logging để kiểm tra response
      debugPrint("Update result - statusCode: ${result.statusCode}");
      debugPrint("Update result - message: ${result.message}");
      debugPrint("Update result - data: ${result.data}");

      if (result.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        Get.back(result: true);
      } else {
        // Xử lý lỗi từ server
        final errorMessage =
            result.message.isNotEmpty
                ? result.message
                : 'Cập nhật thất bại. Vui lòng thử lại.';
        debugPrint("Server error message: $errorMessage");
        _showErrorSnackBar(errorMessage);
      }
    } catch (e) {
      debugPrint("Error updating leave: $e");
      // Xử lý lỗi network hoặc lỗi khác
      String errorMessage = 'Không thể cập nhật đơn nghỉ phép. ';

      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        errorMessage += 'Vui lòng kiểm tra kết nối mạng và thử lại.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage += 'Dữ liệu không hợp lệ.';
      } else {
        errorMessage += 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.';
      }

      _showErrorSnackBar(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  /// Hiển thị thông báo lỗi
  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'Lỗi cập nhật',
      message,
      backgroundColor: Color(0xFFEF4444), // Màu đỏ
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 4),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.error_outline, color: Colors.white),
    );
  }

  /// Hiển thị thông báo thành công
  void _showSuccessSnackBar(String message) {
    Get.snackbar(
      'Thành công',
      message,
      backgroundColor: Color(0xFF10B981), // Màu xanh lá
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
      icon: Icon(Icons.check_circle_outline, color: Colors.white),
    );
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

  /// Load existing attachments từ leave request hiện tại
  void _loadExistingAttachments() {
    if (leave.value?.attachments != null &&
        leave.value!.attachments!.isNotEmpty) {
      attachmentIds.clear();
      attachmentFiles.clear();
      deletedAttachmentIds.clear(); // Reset danh sách xóa

      for (final attachment in leave.value!.attachments!) {
        attachmentIds.add(attachment.id);
        attachmentFiles.add({
          'id': attachment.id,
          'name': attachment.name,
          'url': attachment.url,
          'type': attachment.type,
          'size': attachment.size,
          'originalId': attachment.id, // Lưu ID gốc để theo dõi
        });
      }

      debugPrint("Loaded ${attachmentIds.length} existing attachments");
    }
  }
}
