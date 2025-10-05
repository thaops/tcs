import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/my_annual_leave_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/services/my_annual_leave_api_service.dart';

class MyAnnualLeaveLogic extends GetxController {
  // Trạng thái edit mode
  final isEditMode = false.obs;

  // Dữ liệu annual leave
  final annualLeaveData = Rx<MyAnnualLeaveModel?>(null);

  // Lưu trữ dữ liệu gốc để rollback khi lỗi
  MyAnnualLeaveModel? _originalData;

  // Controllers cho các input field
  final monthlyControllers = <String, TextEditingController>{};

  // Trạng thái loading
  final isLoading = false.obs;

  // Trạng thái có thay đổi dữ liệu
  final hasChanges = false.obs;

  // API Service
  final MyAnnualLeaveApiService _apiService = MyAnnualLeaveApiService();

  // Năm hiện tại
  final currentYear = DateTime.now().year;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadInitialData();
  }

  @override
  void onClose() {
    for (var controller in monthlyControllers.values) {
      controller.dispose();
    }
    super.onClose();
  }

  /// Khởi tạo controllers cho các tháng
  void _initializeControllers() {
    for (int i = 1; i <= 12; i++) {
      monthlyControllers[i.toString()] = TextEditingController();
    }
  }

  /// Load dữ liệu ban đầu
  Future<void> _loadInitialData() async {
    await loadData();
  }

  /// Load dữ liệu từ API
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final response = await _apiService.getMyAnnualLeaveData(
        year: currentYear,
      );

      if (response.statusCode == 200 && response.data != null) {
        annualLeaveData.value = response.data;
        _originalData = response.data; // Lưu dữ liệu gốc
        _updateControllersFromData();
        hasChanges.value = false;
      } else {
        // Tạo dữ liệu mặc định nếu không có dữ liệu
        _createDefaultData();
      }
    } catch (e) {
      print('Error loading annual leave data: $e');
      _createDefaultData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Tạo dữ liệu mặc định
  void _createDefaultData() {
    final defaultData = MyAnnualLeaveModel(
      id: '',
      fullName: '',
      employeeCode: '',
      departmentCode: '',
      departmentName: '',
      annualQuota: 0,
      registeredDays: 0,
      unusedDays: 0,
      jan: 0,
      feb: 0,
      mar: 0,
      apr: 0,
      may: 0,
      jun: 0,
      jul: 0,
      aug: 0,
      sep: 0,
      oct: 0,
      nov: 0,
      dec: 0,
    );
    annualLeaveData.value = defaultData;
    _originalData = defaultData; // Lưu dữ liệu gốc
    _updateControllersFromData();
  }

  /// Cập nhật controllers từ dữ liệu
  void _updateControllersFromData() {
    final data = annualLeaveData.value;
    if (data != null) {
      for (int i = 1; i <= 12; i++) {
        final value = data.getMonthValue(i);
        monthlyControllers[i.toString()]?.text = value.toString();
      }
    }
  }

  /// Toggle edit mode
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) {
      // Nếu thoát edit mode, reset về dữ liệu gốc
      _updateControllersFromData();
      hasChanges.value = false;
    }
  }

  /// Cập nhật giá trị tháng - chỉ lưu vào controller, không cập nhật data chính
  void updateMonthlyValue(String month, String value) {
    // Chỉ đánh dấu có thay đổi, không cập nhật annualLeaveData
    hasChanges.value = true;
  }

  /// Kiểm tra có thể save không
  bool get canSave {
    return isEditMode.value && hasChanges.value && !isLoading.value;
  }

  /// Lưu dữ liệu
  Future<void> saveData() async {
    if (!canSave) return;

    try {
      isLoading.value = true;

      final data = annualLeaveData.value;
      if (data == null) return;

      // Lưu dữ liệu gốc để rollback nếu cần
      _originalData = data;

      // Cập nhật dữ liệu từ controllers vào model trước khi lưu
      MyAnnualLeaveModel updatedData = data;
      for (int i = 1; i <= 12; i++) {
        final controller = monthlyControllers[i.toString()];
        final value = int.tryParse(controller?.text ?? '0') ?? 0;
        updatedData = updatedData.copyWithMonthValue(i, value);
      }

      // Gọi API để cập nhật
      final success = await _apiService.updateMyAnnualLeaveData(
        data: updatedData,
        year: currentYear,
      );

      if (success) {
        // Chỉ reload data khi API thành công
        await loadData();
        isEditMode.value = false;
        hasChanges.value = false;
      } else {
        // Rollback về dữ liệu gốc khi API trả về false
        _rollbackToOriginalData();
      }
    } catch (e) {
      // Rollback về dữ liệu gốc khi có exception
      _rollbackToOriginalData();

      // Hiển thị message lỗi từ server cho user
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Lỗi',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
      print('Error saving data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Rollback về dữ liệu gốc khi có lỗi
  void _rollbackToOriginalData() {
    if (_originalData != null) {
      annualLeaveData.value = _originalData;
      _updateControllersFromData();
    }
  }

  /// Hủy thay đổi
  void cancelChanges() {
    _updateControllersFromData();
    isEditMode.value = false;
    hasChanges.value = false;
  }

  /// Refresh dữ liệu
  Future<void> refreshData() async {
    await loadData();
  }

  /// Lấy tổng số ngày đã đăng ký từ controllers hiện tại
  int get totalRegistered {
    int total = 0;
    for (int i = 1; i <= 12; i++) {
      final controller = monthlyControllers[i.toString()];
      final value = int.tryParse(controller?.text ?? '0') ?? 0;
      total += value;
    }
    return total;
  }

  /// Lấy số ngày chưa sử dụng
  int get unusedDays {
    final data = annualLeaveData.value;
    if (data == null) return 0;

    return data.annualQuota - totalRegistered;
  }
}
