import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/custom_dialog.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_comment.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approval_list_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_approve_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/service/leave_comment_service.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_request_dialogs.dart';
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
  final RxBool canShowModifyButtons = false.obs;
  final RxBool canShowEditButton = false.obs;
  final RxBool canShowBlockButton = false.obs;

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
  void onReady() {
    super.onReady();
    debugPrint('Controller onReady - checking canShowModifyButtons');
    debugPrint('canShowModifyButtons: ${canShowModifyButtons.value}');
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
        debugPrint('loadLeaveData SUCCESS:');
        debugPrint('  - leave.employeeId: ${leave!.employeeId}');
        debugPrint('  - leave.status: ${leave!.status}');
        debugPrint('  - leave.statusLabel: ${leave!.statusLabel}');
        debugPrint('  - myId: $myId');

        // Update modify buttons visibility
        _updateCanShowModifyButtons();
        _safeUpdateButtonVisibility();

        update(); // Notify UI to rebuild AFTER updating canShowModifyButtons

        // Recompute approve buttons visibility if myId is available
        if (myId != null) {
          await _updateApproveButtonsVisibility();
        }

        // Force check canShowModifyButtons after data loaded
        debugPrint(
          'After loadLeaveData - canShowModifyButtons: ${canShowModifyButtons.value}',
        );
        
        // Update button visibility if myId is also available
        if (myId != null) {
          _safeUpdateButtonVisibility();
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
      debugPrint('loadMyId SUCCESS: myId = $myId');

      // Update modify buttons visibility
      _updateCanShowModifyButtons();
      _safeUpdateButtonVisibility();

      update(); // Notify UI to rebuild AFTER updating canShowModifyButtons

      // If leave is available, recompute approve buttons visibility
      if (leave != null) {
        await _updateApproveButtonsVisibility();
      }

      // Force check canShowModifyButtons after myId loaded
      debugPrint(
        'After loadMyId - canShowModifyButtons: ${canShowModifyButtons.value}',
      );
      
      // Update button visibility if leave is also available
      if (leave != null) {
        _safeUpdateButtonVisibility();
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

    final bool isRejectedOrCancelled =
        (leave!.status == 3) ||
        (leave!.status == 4) ||
        (leave!.statusLabel == 'Từ chối') ||
        (leave!.statusLabel == 'Huỷ đơn');

    if (isRejectedOrCancelled) {
      shouldShowApproveButtons.value = false;
      return;
    }

    final bool isApproved = (leave!.status == 2) || (leave!.statusLabel == 'Đã duyệt');
    if (isApproved) {
      shouldShowApproveButtons.value = false;
      return;
    }

    try {
      final approvals = await controllerApprove.getListApprovalByUser(
        leaveId ?? '',
      );

      // Kiểm tra user có quyền duyệt
      final bool hasApprovalPermission = approvals.any(
        (approval) => approval.receiverId == myId,
      );

      if (!hasApprovalPermission) {
        shouldShowApproveButtons.value = false;
        return;
      }

      // Tìm step hiện tại của user
      final currentUserApproval = approvals.firstWhere(
        (approval) => approval.receiverId == myId,
        orElse: () => ApprovalData(
          id: '',
          receiverId: '',
          receiverName: '',
          step: 0,
          status: 0,
          isCompleted: false,
        ),
      );

      // Kiểm tra step hiện tại đã hoàn thành chưa
      if (currentUserApproval.isCompleted) {
        shouldShowApproveButtons.value = false;
        return;
      }

      // Kiểm tra các step trước đó đã hoàn thành chưa
      final bool arePreviousStepsCompleted = _arePreviousStepsCompleted(
        approvals,
        currentUserApproval.step,
      );

      debugPrint('  - currentUserStep: ${currentUserApproval.step}');
      debugPrint('  - isCurrentStepCompleted: ${currentUserApproval.isCompleted}');
      debugPrint('  - arePreviousStepsCompleted: $arePreviousStepsCompleted');

      // Chỉ hiển thị nút khi step hiện tại chưa hoàn thành và các step trước đã hoàn thành
      shouldShowApproveButtons.value = !currentUserApproval.isCompleted && arePreviousStepsCompleted;
    } catch (e) {
      debugPrint('Error checking approval permissions: $e');
      shouldShowApproveButtons.value = false;
    }
  }


  /// Kiểm tra user có phải là trưởng phòng không
  bool _isManager() {
    if (leave?.workFlows == null || myId == null) return false;

    // Tìm workflow của user hiện tại
    final userWorkflow = leave!.workFlows!.firstWhere(
      (workflow) => workflow.approverId == myId,
      orElse: () => WorkFlow(id: '', approverId: ''),
    );

    // Kiểm tra jobTitle có chứa "trưởng phòng"
    final String? jobTitle = userWorkflow.jobTitle?.toLowerCase();
    return jobTitle != null && jobTitle.contains('trưởng phòng');
  }



  /// Kiểm tra các step trước đó đã hoàn thành chưa
  bool _arePreviousStepsCompleted(List<ApprovalData> approvals, int currentStep) {
    if (currentStep <= 1) return true; // Step 1 không cần kiểm tra step trước

    // Kiểm tra tất cả step trước đó đã hoàn thành chưa
    for (int step = 1; step < currentStep; step++) {
      final stepApproval = approvals.firstWhere(
        (approval) => approval.step == step,
        orElse: () => ApprovalData(
          id: '',
          receiverId: '',
          receiverName: '',
          step: step,
          status: 0,
          isCompleted: false,
        ),
      );

      // Nếu step trước đó chưa hoàn thành
      if (!stepApproval.isCompleted) {
        return false;
      }
    }
    return true;
  }

  /// Update button visibility based on leave status and user role
  void _updateButtonVisibility() {
    debugPrint('_updateButtonVisibility called');
    if (leave == null || myId == null) {
      debugPrint('_updateButtonVisibility: leave=$leave, myId=$myId - SKIPPING');
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
      return;
    }

    final int? status = leave!.status;
    final String? statusLabel = leave!.statusLabel;
    final String? employeeId = leave!.employeeId;
    final bool isOwner = myId == employeeId;
    final bool isManager = _isManager();
    // Kiểm tra đơn đã bị từ chối hoặc huỷ đơn (không cho phép chỉnh sửa)
    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (statusLabel == 'Từ chối') ||
        (statusLabel == 'Huỷ đơn');

    // Kiểm tra đơn đã được duyệt
    final bool isApproved = (status == 2) || (statusLabel == 'Đã duyệt');
    
    // Kiểm tra đơn đang chờ hủy đơn
    final bool isPendingCancel = (status == 99) || (statusLabel == 'Chờ hủy đơn');

    debugPrint('  - isRejectedOrCancelled: $isRejectedOrCancelled');
    debugPrint('  - isApproved: $isApproved');
    debugPrint('  - isPendingCancel: $isPendingCancel');
    debugPrint('  - isOwner: $isOwner');
    debugPrint('  - isManager: $isManager');

    if (isRejectedOrCancelled || isPendingCancel) {
      // Đơn đã từ chối, huỷ đơn hoặc chờ hủy đơn - không hiển thị nút nào
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
      debugPrint('  - Result: No buttons (đơn đã từ chối/huỷ đơn/chờ hủy đơn)');
    } else if (isApproved) {
      // Đơn đã được duyệt - hiển thị nút block cho chủ đơn hoặc trưởng phòng
      canShowEditButton.value = false;
      canShowBlockButton.value = isOwner || isManager;
      debugPrint('  - Result: Block button only (đơn đã duyệt, isOwner: $isOwner, isManager: $isManager)');
    } else {
      // Đơn chưa được duyệt (chờ duyệt) - hiển thị cả nút edit và block cho chủ đơn hoặc trưởng phòng
      canShowEditButton.value = isOwner;
      canShowBlockButton.value = isOwner || isManager;
      debugPrint('  - Result: Both buttons (đơn chờ duyệt, isOwner: $isOwner, isManager: $isManager)');
    }

    debugPrint('  - canShowEditButton: ${canShowEditButton.value}');
    debugPrint('  - canShowBlockButton: ${canShowBlockButton.value}');
  }

  /// Safely update button visibility - only when both myId and leave are available
  void _safeUpdateButtonVisibility() {
    debugPrint('_safeUpdateButtonVisibility called');
    if (leave != null && myId != null) {
      debugPrint('Both leave and myId available - updating button visibility');
      _updateButtonVisibility();
    } else {
      debugPrint('Missing data - leave: ${leave != null}, myId: ${myId != null}');
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
    }
  }

  /// Update canShowModifyButtons reactive variable
  void _updateCanShowModifyButtons() {
    debugPrint('_updateCanShowModifyButtons called');
    if (leave == null || myId == null) {
      debugPrint('_updateCanShowModifyButtons: leave=$leave, myId=$myId');
      debugPrint(
        '  - Setting canShowModifyButtons.value from ${canShowModifyButtons.value} to false',
      );
      canShowModifyButtons.value = false;
      debugPrint(
        '  - canShowModifyButtons.value is now: ${canShowModifyButtons.value}',
      );
      return;
    }

    final int? status = leave!.status;
    final String? statusLabel = leave!.statusLabel;
    final String? employeeId = leave!.employeeId;
    final bool isOwner = myId == employeeId;
    final bool isManager = _isManager();

   

    // Kiểm tra đơn đã bị từ chối hoặc huỷ đơn (không cho phép chỉnh sửa)
    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (statusLabel == 'Từ chối') ||
        (statusLabel == 'Huỷ đơn');
    
    // Kiểm tra đơn đang chờ hủy đơn
    final bool isPendingCancel = (status == 99) || (statusLabel == 'Chờ hủy đơn');

    debugPrint('  - isRejectedOrCancelled: $isRejectedOrCancelled');
    debugPrint('  - isPendingCancel: $isPendingCancel');

    if (isRejectedOrCancelled || isPendingCancel) {
   
      canShowModifyButtons.value = false;
      
      return;
    }

    // Kiểm tra đơn đã được duyệt
    final bool isApproved = (status == 2) || (statusLabel == 'Đã duyệt');
    debugPrint('  - isApproved: $isApproved');

    final bool canModify = (isOwner || isManager) && !isRejectedOrCancelled;
    
    debugPrint('  - isOwner: $isOwner, isManager: $isManager, canModify: $canModify');
    canShowModifyButtons.value = canModify;
   
  }

  /// Check if comment input should be shown
  bool get canShowCommentInput {
    if (leave == null) return false;

    final int? status = leave!.status;
    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (leave!.statusLabel == 'Từ chối') ||
        (leave!.statusLabel == 'Huỷ đơn');
    
    // Kiểm tra đơn đang chờ hủy đơn
    final bool isPendingCancel = (status == 99) || (leave!.statusLabel == 'Chờ hủy đơn');

   
    return !isRejectedOrCancelled && !isPendingCancel;
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

  /// Cancel leave request với dialog nhập lý do
  Future<void> cancelLeave() async {
    if (leaveId == null || Get.context == null) return;

    try {
      // Kiểm tra trạng thái đơn để quyết định hiển thị dialog
      final bool isApproved = (leave?.status == 2) || (leave?.statusLabel == 'Đã duyệt');
      
      // Hiển thị dialog nhập lý do hủy đơn
      final result = await LeaveRequestDialogs.showCancelLeaveDialog(
        Get.context!,
        isApproved: isApproved,
      );
      
      if (result != null && result['confirmed'] == true) {
        final String reason = result['reason'] as String;
        
        // Hiển thị loading
        isLoading.value = true;
        
        // Sử dụng repository có sẵn
        final repository = LeaveManagementRepository();
        final success = await repository.cancelLeave(
          leaveId!,
          Get.context!,
          reason,
        );
        
        isLoading.value = false;
        
        if (success) {
     
          await loadLeaveData();
          
          Get.back(result: true);
        }
      }
    } catch (e) {
      isLoading.value = false;
      
      // Hiển thị message lỗi từ server
      final String errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

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

    if (result == true && leave != null && Get.context != null) {
      final leaveId = leave!.id?.toString();
      final categoryId = leave!.categoryId;

      if (leaveId == null || categoryId == null) {
        Get.snackbar(
          'Lỗi',
          'Thiếu thông tin cần thiết để duyệt đơn',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      try {
        await controllerApprove.approveOrRejectLeave(
          leaveId,
          categoryId,
          2,
          "Đã duyệt thành công",
          Get.context!,
        );

        await loadLeaveData();
      } catch (e) {
      }
    }
  }

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

    if (result == true && leave != null && Get.context != null) {
      // Kiểm tra dữ liệu cần thiết trước khi từ chối
      final leaveId = leave!.id?.toString();
      final categoryId = leave!.categoryId;

      if (leaveId == null || categoryId == null) {
        Get.snackbar(
          'Lỗi',
          'Thiếu thông tin cần thiết để từ chối đơn',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      try {
        await controllerApprove.approveOrRejectLeave(
          leaveId,
          categoryId,
          3,
          "Từ chối thành công",
          Get.context!,
        );

        // Reload data sau khi từ chối để cập nhật UI
        await loadLeaveData();
      } catch (e) {
        debugPrint('Error in showRejectDialog: $e');
        Get.snackbar(
          'Lỗi',
          'Không thể từ chối đơn: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  /// Force rebuild UI - for debugging
  void forceRebuild() {
    debugPrint('Force rebuild called');
    _updateCanShowModifyButtons();
    _safeUpdateButtonVisibility();
    debugPrint(
      'Current state: myId=$myId, leave=${leave?.id}, canShowModifyButtons=${canShowModifyButtons.value}',
    );
    debugPrint(
      'Button visibility: canShowEditButton=${canShowEditButton.value}, canShowBlockButton=${canShowBlockButton.value}',
    );
    update();
  }

  /// Debug button visibility - for troubleshooting
  void debugButtonVisibility() {
    debugPrint('=== DEBUG BUTTON VISIBILITY ===');
    debugPrint('myId: $myId');
    debugPrint('leave: ${leave?.id}');
    debugPrint('leave.employeeId: ${leave?.employeeId}');
    debugPrint('leave.status: ${leave?.status}');
    debugPrint('leave.statusLabel: ${leave?.statusLabel}');
    debugPrint('isOwner: ${myId == leave?.employeeId}');
    debugPrint('canShowEditButton: ${canShowEditButton.value}');
    debugPrint('canShowBlockButton: ${canShowBlockButton.value}');
    debugPrint('canShowModifyButtons: ${canShowModifyButtons.value}');
    debugPrint('=== END DEBUG ===');
  }
}
