import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_list_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_filter_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/profile_logic.dart';

/// Service để clear cache của các controllers cụ thể
class ControllerCacheClear {
  /// Clear tất cả controllers và reset state
  static void clearAllControllers() {
    try {
      // Clear Leave Management Controllers
      if (Get.isRegistered<LeaveListController>()) {
        final leaveListController = Get.find<LeaveListController>();
        leaveListController.listOff.clear();
        leaveListController.isDataLoaded = false;
        leaveListController.months.clear();
      }

      if (Get.isRegistered<LeaveFilterController>()) {
        final leaveFilterController = Get.find<LeaveFilterController>();
        leaveFilterController.resetFilters();
      }

      // Clear Filter User Controller
      if (Get.isRegistered<FilterUserController>()) {
        final filterUserController = Get.find<FilterUserController>();
        filterUserController.employeeIdToDepartment.clear();
        filterUserController.userList.clear();
      }

      // Clear Profile Controller
      if (Get.isRegistered<ProfileLogic>()) {
        final profileController = Get.find<ProfileLogic>();
        profileController.resetProfile();
      }

      // Clear tất cả GetX dependencies
      Get.reset();
    } catch (e) {
      print('Error clearing controllers: $e');
    }
  }

  /// Clear chỉ leave management controllers
  static void clearLeaveControllers() {
    try {
      if (Get.isRegistered<LeaveListController>()) {
        final controller = Get.find<LeaveListController>();
        controller.listOff.clear();
        controller.isDataLoaded = false;
        controller.months.clear();
      }

      if (Get.isRegistered<LeaveFilterController>()) {
        final controller = Get.find<LeaveFilterController>();
        controller.resetFilters();
      }
    } catch (e) {
      print('Error clearing leave controllers: $e');
    }
  }

  /// Clear chỉ user filter controllers
  static void clearUserControllers() {
    try {
      if (Get.isRegistered<FilterUserController>()) {
        final controller = Get.find<FilterUserController>();
        controller.employeeIdToDepartment.clear();
        controller.userList.clear();
      }

      if (Get.isRegistered<ProfileLogic>()) {
        final controller = Get.find<ProfileLogic>();
        controller.resetProfile();
      }
    } catch (e) {
      print('Error clearing user controllers: $e');
    }
  }
}
