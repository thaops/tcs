import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/logic/leave_logic.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/src/Api/models/users_model.dart';

class LeaveUpdateController extends GetxController {
  // Các biến reactive để theo dõi trạng thái thay đổi
  DioApi dioApi = DioApi();
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

  LeaveManagementRepository leaveManagementRepository =
      LeaveManagementRepository();

  @override
  void onInit() {
    super.onInit();
    fetchLeave();
    final LeaveUpdateData? arguments = Get.arguments as LeaveUpdateData?;
    leave.value = arguments?.leave;
    print("leave: ${leave.toString()}");
    category!.value = arguments?.category ?? '';

    final leaveLogicRead = Get.put(LeaveLogic());

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

  void updateDate(DateTime newDate, bool isStartDate) {
    if (isStartDate) {
      startDate.value = newDate;
    } else {
      dueDate.value = newDate;
    }
  }

  Future<void> leaveUpdate(BuildContext context) async {
    if (leaveID == null || usersID == null || controllerNote.text.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (dueDate.value!.isBefore(startDate.value!)) {
      Get.snackbar('Lỗi', 'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.');
      return;
    }

    final String leaveId = leave.value?.id.toString() ?? '';

    Map<String, dynamic> updateData = {
      'reason': controllerNote.text,
      'fromDate': startDate.value!.toIso8601String(),
      'toDate': dueDate.value!.toIso8601String(),
      'categoryId': leaveID,
      'employeeId': usersID,
    };

    try {
      isLoading.value = true;
      final response = await dioApi.put(ApiEndpoints.updateleave(leaveId), data: updateData);
      if (response.data['statusCode'] == 200) {
          Get.back(result: true);
        Get.snackbar('Thành công', 'Cập nhật đơn xin phép thành công');
      
      } else {
        Get.snackbar('Thất bại', 'Đơn xin phép thất bại: ${response.data['message']}');
      }
    } catch (e) {
      print("error: $e");
    } finally {
      isLoading.value = false;
    }
  }


    Future<void> fetchLeave() async {
    try {
      isLoading.value = true;
      final response = await dioApi.get(ApiEndpoints.leavePagination);
      if (response != null) {
        List<dynamic> data = response.data['data'];
        leaves = data
            .map((item) => LeaveType.fromJson(item))
            .toList(); 

      } else {
        print('Access token is missing.');
      }
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
