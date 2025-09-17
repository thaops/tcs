import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/custom_dialog.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_approve_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/router/app_router.dart';

/// Controller xử lý logic cho Leave Request Detail Screen
class LeaveRequestDetailController extends GetxController {
  // Dependencies
  late final LeaveLogic leaveLogic;
  late final LeaveApproveController controllerApprove;

  // State variables
  String? leaveId;
  String? myId;
  LeaveID? leave;
  final RxBool isLoading = false.obs;
  final RxBool shouldShowApproveButtons = false.obs;

  @override
  void onInit() {
    super.onInit();
    leaveLogic = Get.put(LeaveLogic());
    controllerApprove = Get.put(LeaveApproveController());

    final arguments = Get.arguments;
    leaveId = arguments != null ? arguments['leaveId'] as String? : null;

    debugPrint(
      'LeaveRequestDetailController initialized with leaveId: $leaveId',
    );

    if (leaveId != null) {
      loadLeaveData();
      loadMyId();
    } else {
      debugPrint('No leaveId provided, showing error');
    }
  }

  /// Load leave data from API
  Future<void> loadLeaveData() async {
    if (leaveId == null) return;

    try {
      isLoading.value = true;
      final result = await leaveLogic.getLeave(leaveId!, Get.context!);

      if (result != null) {
        leave = result;
        update(); // Notify UI to rebuild

        // Recompute approve buttons visibility if myId is available
        if (myId != null) {
          await _updateApproveButtonsVisibility();
        }
      } else {
        debugPrint('Failed to load leave data');
      }
    } catch (e) {
      debugPrint('Error loading leave data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load current user ID
  Future<void> loadMyId() async {
    try {
      final create = await MyId.create();
      final id = await create.getMyId();

      myId = id;
      update(); // Notify UI to rebuild

      // If leave is available, recompute approve buttons visibility
      if (leave != null) {
        await _updateApproveButtonsVisibility();
      }
    } catch (e) {
      debugPrint('Failed to load myId: $e');
    }
  }

  /// Update approve buttons visibility based on current state
  Future<void> _updateApproveButtonsVisibility() async {
    if (leave == null || myId == null) {
      shouldShowApproveButtons.value = false;
      return;
    }

    final bool isApproved =
        (leave!.status == 2) ||
        (leave!.status == 3) ||
        (leave!.statusLabel == 'Đã duyệt') ||
        (leave!.statusLabel == 'Từ chối');

    if (isApproved) {
      shouldShowApproveButtons.value = false;
      return;
    }

    try {
      final approvals = await controllerApprove.getListApprovalByUser(
        leaveId ?? '',
      );
      shouldShowApproveButtons.value = approvals.any(
        (approval) => approval.receiverId == myId,
      );
    } catch (e) {
      debugPrint('Error checking approval permissions: $e');
      shouldShowApproveButtons.value = false;
    }
  }

  /// Check if current user can modify the leave request
  bool get canShowModifyButtons {
    if (leave == null || myId == null) return false;

    final int? status = leave!.status;
    final bool isApprovedOrRejected =
        (status == 2) ||
        (status == 3) ||
        (leave!.statusLabel == 'Đã duyệt') ||
        (leave!.statusLabel == 'Từ chối');

    if (isApprovedOrRejected) return false;

    return myId == leave!.employeeId;
  }

  /// Navigate to update screen
  void navigateToUpdate() {
    if (leave == null) return;

    Get.toNamed(
      AppRouter.leaveUpdate,
      arguments: LeaveUpdateData(leave: leave),
    )?.then((value) {
      if (value == true) {
        loadLeaveData(); // Reload data after update
      }
    });
  }

  /// Delete leave request
  void deleteLeave() {
    if (leaveId != null) {
      leaveLogic.deleteLeave(leaveId!, Get.context!);
    }
  }

  /// Show approve dialog and handle approval
  Future<void> showApproveDialog() async {
    final result = await CustomDialog().showConfirmationDialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ý kiến lãnh đạo",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          CustomTextField(
            controller: controllerApprove.textController,
            hintText: "Nội dung",
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );

    if (result == true && leave != null) {
      await controllerApprove.approveOrRejectLeave(
        leave!.id.toString(),
        leave!.categoryId ?? '',
        2,
        "Cảm ơn, Xếp đã duyệt đơn nghỉ phép!",
        Get.context!,
      );
    }
  }

  /// Show reject dialog and handle rejection
  Future<void> showRejectDialog() async {
    final result = await CustomDialog().showConfirmationDialog(
      child: Column(
        children: [
          Text(
            "Từ chối đơn xin nghỉ phép",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );

    if (result == true && leave != null) {
      await controllerApprove.approveOrRejectLeave(
        leave!.id.toString(),
        leave!.categoryId ?? '',
        3,
        "Chân thành cảm ơn, Xếp đã từ chối đơn nghỉ phép",
        Get.context!,
      );
    }
  }

  /// Get status color based on status label
  Color getStatusColor(String? statusLabel) {
    switch (statusLabel) {
      case 'Đang xử lý':
        return Color(0xFFF59E0B); // Amber 500
      case 'Đã duyệt':
        return Color(0xFF10B981); // Emerald 500
      case 'Từ chối':
        return Color(0xFFEF4444); // Red 500
      case 'Chờ xử lý':
        return Color(0xFF6B7280); // Gray 500
      default:
        return Color(0xFF374151); // Gray 700
    }
  }
}
