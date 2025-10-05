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

  // Các trường dữ liệu chính
  String? employeeId; // ID nhân viên
  String? fullName; // Tên đầy đủ nhân viên
  String? categoryId; // ID loại nghỉ phép
  Rx<DateTime> fromDate = Rx<DateTime>(
    DateTime(
      DateTime.now().add(Duration(days: 1)).year,
      DateTime.now().add(Duration(days: 1)).month,
      DateTime.now().add(Duration(days: 1)).day,
      7,
      30,
    ),
  );
  Rx<DateTime> toDate = Rx<DateTime>(
    DateTime(
      DateTime.now().add(Duration(days: 1)).year,
      DateTime.now().add(Duration(days: 1)).month,
      DateTime.now().add(Duration(days: 1)).day,
      17,
      00,
    ),
  );
  String? reason; // Lý do nghỉ phép
  List<String> attachmentIds = []; // Danh sách ID file đính kèm
  List<Map<String, dynamic>> attachmentFiles = []; // Danh sách file thực tế

  // Các trường cũ để tương thích ngược
  String? get usersID => employeeId;
  set usersID(String? value) => employeeId = value;
  String? get leaveID => categoryId;
  set leaveID(String? value) => categoryId = value;
  Rx<DateTime> get startDate => fromDate;
  Rx<DateTime> get dueDate => toDate;

  RxBool isloadingSave = false.obs;

  late TextEditingController controllerNote;

  @override
  void onInit() async {
    super.onInit();
    controllerNote = TextEditingController();
    MyId myId = await MyId.create();
    employeeId = await myId.getMyId();
    // Lấy tên đầy đủ từ profile (đã sửa để sử dụng .value)
    fullName = controllerProfile.profile.value?.user?.fullName ?? '';
    // fetchUsers();
  }

  @override
  void onReady() {
    super.onReady();
    fetchLeave();
  }

  // Lưu tạo mới đơn nghỉ phép
  Future<void> save_create(BuildContext context) async {
    if (!_validateLeaveData(categoryId, employeeId, toDate, fromDate, context))
      return;

    final Map<String, dynamic> addData = {
      'employeeId': employeeId,
      'fullName': fullName,
      'fromDate': fromDate.value.toIso8601String(),
      'toDate': toDate.value.toIso8601String(),
      'categoryId': categoryId,
      'reason': controllerNote.text.isNotEmpty ? controllerNote.text : reason,
      'attachmentIds': attachmentIds,
      'attachmentFiles': attachmentFiles,
    };

    try {
      isloadingSave.value = true;
      final result = await _addLeave(addData, context);

      if (result.data == false) {
        _showSnackBar(context, "Thất bại ${result.message}");
        return;
      }
      Get.back(result: true);
    } catch (e) {
      print(e);
    } finally {
      isloadingSave.value = false;
    }
  }

  bool _validateLeaveData(
    categoryId,
    employeeId,
    _toDate,
    _fromDate,
    BuildContext context,
  ) {
    // Kiểm tra các trường bắt buộc
    if (categoryId == null || categoryId.isEmpty) {
      _showSnackBar(context, 'Vui lòng chọn loại nghỉ phép');
      return false;
    }

    if (employeeId == null || employeeId.isEmpty) {
      _showSnackBar(context, 'Vui lòng chọn nhân viên');
      return false;
    }

    if (controllerNote.text.trim().isEmpty) {
      _showSnackBar(context, 'Vui lòng nhập lý do nghỉ phép');
      return false;
    }

    // Kiểm tra ngày tháng
    if (_toDate.value.isBefore(_fromDate.value)) {
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

  // Phương thức cập nhật fromDate và tự động điều chỉnh toDate
  void updateStartDate(DateTime newStartDate) {
    fromDate.value = newStartDate;

    // Nếu ngày kết thúc trước hoặc bằng ngày bắt đầu, cập nhật ngày kết thúc
    if (toDate.value.isBefore(newStartDate) ||
        isSameDay(toDate.value, newStartDate)) {
      toDate.value = DateTime(
        newStartDate.year,
        newStartDate.month,
        newStartDate.day,
        17,
        0, // Sửa từ 30 thành 0 để đặt thời gian kết thúc là 17:00
      );
    }
  }

  void updateDueDate(DateTime newDueDate) {
    toDate.value = newDueDate;

    // Nếu ngày bắt đầu sau ngày kết thúc, cập nhật ngày bắt đầu
    if (fromDate.value.isAfter(newDueDate)) {
      fromDate.value = DateTime(
        newDueDate.year,
        newDueDate.month,
        newDueDate.day,
        7,
        30, // Giữ nguyên thời gian bắt đầu là 7:30
      );
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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

  // Phương thức cập nhật thông tin nhân viên
  void updateEmployeeInfo(String? id, String? name) {
    employeeId = id;
    fullName = name;
  }
}
