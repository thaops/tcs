// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:npp/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
// import 'package:npp/router/app_router.dart';
// import 'package:npp/src/Api/models/employee_model.dart';

// class LeaveListoffController extends GetxController {
//   LeaveManagementRepository leaveManagementRepository =
//       LeaveManagementRepository();
//   RxList<Employee> listOff = <Employee>[].obs;
//   RxBool isLoading = false.obs;
//   String errorMessage = '';
//   List<Map<String, DateTime>> months = [];
//   DateTime? selectedMonth;

//   @override
//   void onInit() {
//     super.onInit();
//     generateMonths();
//     fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
//   }

//   Future<void> fetchListOff(
//     DateTime firstDay,
//     DateTime lastDay,
//   ) async {
//     try {
//       isLoading.value = true;

//       final response =
//           await leaveManagementRepository.getListOff(firstDay, lastDay);
//       print("response: $response");
//       if (response == null) {
//         listOff.value = response!.cast<Employee>();
//       }
//     } catch (e) {
//       errorMessage = 'Đã xảy ra lỗi khi tải dữ liệu';
//       isLoading.value = false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void generateMonths() {
//     DateTime now = DateTime.now();

//     DateTime startMonth = (now.month == 12)
//         ? DateTime(now.year + 1, 1, 1)
//         : DateTime(now.year, now.month + 1, 1);

//     for (int i = 0; i < 12; i++) {
//       // Tính toán tháng mới (sau tháng hiện tại)
//       DateTime firstDay = DateTime(startMonth.year, startMonth.month - i, 1);
//       DateTime lastDay =
//           DateTime(startMonth.year, startMonth.month - i + 1, 10);

//       months.add({
//         'firstDay': firstDay,
//         'lastDay': lastDay,
//       });
//     }
//   }

//   void addScreen() {
//     Get.toNamed(AppRouter.leaveCreate, arguments: fetchListOff)?.then((value) {
//       if (value == true) {
//         fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
//       } else {
//         print('Adding screen did not return true.');
//       }
//     });
//   }

//   Future<void> refresh() async {
//     await fetchListOff(months[0]['firstDay']!, months[0]['lastDay']!);
//     selectedMonth = null;
//   }
// }
