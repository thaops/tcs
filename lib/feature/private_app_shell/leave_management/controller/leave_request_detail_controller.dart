import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/custom_dialog.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_comment.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_approve_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/service/leave_comment_service.dart';
import 'package:tcs_flutter/router/app_router.dart';

/// Controller xử lý logic cho Leave Request Detail Screen
class LeaveRequestDetailController extends GetxController {
  // Dependencies
  late final LeaveLogic leaveLogic;
  late final LeaveApproveController controllerApprove;
  late final LeaveCommentService commentService;

  // State variables
  String? leaveId;
  String? myId;
  LeaveID? leave;
  final RxBool isLoading = false.obs;
  final RxBool shouldShowApproveButtons = false.obs;

  // Comments state
  final RxList<LeaveComment> comments = <LeaveComment>[].obs;
  final RxBool isLoadingComments = false.obs;
  final TextEditingController commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    leaveLogic = Get.put(LeaveLogic());
    controllerApprove = Get.put(LeaveApproveController());
    commentService = LeaveCommentService();

    final arguments = Get.arguments;
    leaveId = arguments != null ? arguments['leaveId'] as String? : null;

    debugPrint(
      'LeaveRequestDetailController initialized with leaveId: $leaveId',
    );

    if (leaveId != null) {
      loadLeaveData();
      loadMyId();
      loadComments();
    } else {
      debugPrint('No leaveId provided, showing error');
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
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

      // Kiểm tra user có quyền duyệt và chưa xử lý
      final bool hasApprovalPermission = approvals.any(
        (approval) => approval.receiverId == myId,
      );

      // Kiểm tra user đã duyệt/từ chối trong workflow chưa
      final bool hasAlreadyProcessed = _hasUserAlreadyProcessedWorkflow();

      // Chỉ hiển thị nút khi có quyền và chưa xử lý
      shouldShowApproveButtons.value =
          hasApprovalPermission && !hasAlreadyProcessed;
    } catch (e) {
      debugPrint('Error checking approval permissions: $e');
      shouldShowApproveButtons.value = false;
    }
  }

  /// Kiểm tra user đã duyệt/từ chối trong workflow chưa
  bool _hasUserAlreadyProcessedWorkflow() {
    if (leave?.workFlows == null || myId == null) return false;

    // Tìm workflow của user hiện tại
    final userWorkflow = leave!.workFlows!.firstWhere(
      (workflow) => workflow.approverId == myId,
      orElse: () => WorkFlow(id: '', approverId: ''),
    );

    // Kiểm tra user đã xử lý (có approvalDate và status đã duyệt/từ chối)
    if (userWorkflow.approvalDate != null) {
      return userWorkflow.statusLabel == 'Đã duyệt' ||
          userWorkflow.statusLabel == 'Từ chối' ||
          userWorkflow.status == 2 ||
          userWorkflow.status == 3;
    }

    return false;
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

  /// Check if comment input should be shown
  bool get canShowCommentInput {
    if (leave == null) return false;

    final int? status = leave!.status;
    final bool isApprovedOrRejected =
        (status == 2) ||
        (status == 3) ||
        (leave!.statusLabel == 'Đã duyệt') ||
        (leave!.statusLabel == 'Từ chối');

    // Ẩn input comment khi đơn đã duyệt hoặc từ chối
    return !isApprovedOrRejected;
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Đồng ý duyệt đơn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (result == true && leave != null) {
      await controllerApprove.approveOrRejectLeave(
        leave!.id.toString(),
        leave!.categoryId ?? '',
        2,
        "Đã duyệt thành công",
        Get.context!,
      );

      // Reload data sau khi duyệt để cập nhật UI
      await loadLeaveData();
    }
  }

  /// Show reject dialog and handle rejection
  Future<void> showRejectDialog() async {
    final result = await CustomDialog().showConfirmationDialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Từ chối duyệt đơn",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    if (result == true && leave != null) {
      await controllerApprove.approveOrRejectLeave(
        leave!.id.toString(),
        leave!.categoryId ?? '',
        3,
        "Từ chối thành công",
        Get.context!,
      );

      // Reload data sau khi từ chối để cập nhật UI
      await loadLeaveData();
    }
  }

  /// Load comments for current leave request
  Future<void> loadComments() async {
    if (leaveId == null) return;

    try {
      isLoadingComments.value = true;
      final response = await commentService.getLeaveComments(
        leaveId!,
        Get.context!,
      );

      if (response != null && response.statusCode == 200) {
        comments.value = response.data;
      } else {
        debugPrint('Failed to load comments');
      }
    } catch (e) {
      debugPrint('Error loading comments: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  /// Add new comment - Optimized for smooth UX
  Future<void> addComment() async {
    if (leaveId == null || commentController.text.trim().isEmpty) return;

    final commentText = commentController.text.trim();

    // Clear input immediately for better UX
    commentController.clear();

    // Add comment to list optimistically
    final newComment = LeaveComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: '00000000-0000-0000-0000-000000000000',
      content: commentText,
      createdDate: DateTime.now().toIso8601String(),
      creator: 'Bạn', // Temporary, will be updated after API call
      createdById: myId ?? '',
    );

    comments.insert(0, newComment);

    try {
      // Show minimal loading state
      isLoadingComments.value = true;

      final response = await commentService.addLeaveComment(
        leaveId!,
        commentText,
        Get.context!,
      );

      if (response != null && response.statusCode == 200 && response.data) {
        // Success - reload comments to get real data
        await loadComments();
      } else {
        // Remove optimistic comment on failure
        comments.removeWhere((comment) => comment.id == newComment.id);
        debugPrint('Failed to add comment: ${response?.message}');
      }
    } catch (e) {
      // Remove optimistic comment on error
      comments.removeWhere((comment) => comment.id == newComment.id);
      debugPrint('Error adding comment: $e');
    } finally {
      isLoadingComments.value = false;
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
