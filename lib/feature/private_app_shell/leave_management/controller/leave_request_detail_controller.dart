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

    if (leaveId != null) {
      loadLeaveData();
      loadMyId();
      loadComments();
    }
  }

  @override
  void onReady() {
    super.onReady();
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

        _updateCanShowModifyButtons();
        _safeUpdateButtonVisibility();

        update();

        if (myId != null) {
          await _updateApproveButtonsVisibility();
        }

        if (myId != null) {
          _safeUpdateButtonVisibility();
        }
      }
    } catch (e) {
      // Error loading leave data
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

      _updateCanShowModifyButtons();
      _safeUpdateButtonVisibility();

      update();

      if (leave != null) {
        await _updateApproveButtonsVisibility();
      }

      if (leave != null) {
        _safeUpdateButtonVisibility();
      }
    } catch (e) {
      // Failed to load myId
    }
  }

  Future<void> _updateApproveButtonsVisibility() async {
    debugPrint('=== _updateApproveButtonsVisibility called ===');
    if (leave == null || myId == null) {
      shouldShowApproveButtons.value = false;
      return;
    }

    debugPrint('  - leave.status: ${leave!.status}');
    debugPrint('  - leave.statusLabel: ${leave!.statusLabel}');

    final bool isRejectedOrCancelled =
        (leave!.status == 3) ||
        (leave!.status == 4) ||
        (leave!.statusLabel == 'Từ chối') ||
        (leave!.statusLabel == 'Huỷ đơn');

    debugPrint('  - isRejectedOrCancelled: $isRejectedOrCancelled');

    if (isRejectedOrCancelled) {
      shouldShowApproveButtons.value = false;
      debugPrint('  - Ẩn nút duyệt: đơn đã bị từ chối/huỷ đơn');
      return;
    }

    final bool isApproved =
        (leave!.status == 2) || (leave!.statusLabel == 'Đã duyệt');

    debugPrint('  - isApproved: $isApproved');

    if (isApproved) {
      shouldShowApproveButtons.value = false;
      debugPrint('  - Ẩn nút duyệt: đơn đã được duyệt hoàn toàn');
      return;
    }

    // Kiểm tra đơn đang chờ hủy đơn - nhưng vẫn cho phép hiển thị nút duyệt
    final bool isPendingCancel =
        (leave!.status == 99) || (leave!.statusLabel == 'Chờ hủy đơn');

    debugPrint('  - isPendingCancel: $isPendingCancel');

    // Không ẩn nút duyệt khi đơn chờ hủy - trưởng phòng vẫn có thể duyệt
    // if (isPendingCancel) {
    //   shouldShowApproveButtons.value = false;
    //   return;
    // }

    try {
      final approvals = await controllerApprove.getListApprovalByUser(
        leaveId ?? '',
      );

      final bool hasApprovalPermission = approvals.any(
        (approval) => approval.receiverId == myId,
      );

      debugPrint('  - hasApprovalPermission: $hasApprovalPermission');

      if (!hasApprovalPermission) {
        shouldShowApproveButtons.value = false;
        debugPrint('  - Ẩn nút duyệt: user không có trong danh sách phê duyệt');
        return;
      }

      final userApproval = approvals.firstWhere(
        (approval) => approval.receiverId == myId,
      );

      final bool hasNotApproved =
          !userApproval.isCompleted &&
          (userApproval.status == 0 || userApproval.status == 1);

      debugPrint('  - userApproval: $userApproval');
      debugPrint('  - userApproval.isCompleted: ${userApproval.isCompleted}');
      debugPrint('  - userApproval.status: ${userApproval.status}');
      debugPrint('  - hasNotApproved: $hasNotApproved');

      shouldShowApproveButtons.value = hasApprovalPermission && hasNotApproved;

      debugPrint(
        '  - shouldShowApproveButtons: ${shouldShowApproveButtons.value}',
      );
    } catch (e) {
      shouldShowApproveButtons.value = false;
      debugPrint('  - Error: $e');
    }
    debugPrint(
      '=== _updateApproveButtonsVisibility finished: ${shouldShowApproveButtons.value} ===',
    );
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

  void _updateButtonVisibility() {
    if (leave == null || myId == null) {
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
      return;
    }

    final int? status = leave!.status;
    final String? statusLabel = leave!.statusLabel;
    final String? employeeId = leave!.employeeId;
    final bool isOwner = myId == employeeId;
    final bool isManager = _isManager();

    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (statusLabel == 'Từ chối') ||
        (statusLabel == 'Huỷ đơn');

    final bool isApproved = (status == 2) || (statusLabel == 'Đã duyệt');

    final bool isPendingCancel =
        (status == 99) || (statusLabel == 'Chờ hủy đơn');

    if (isRejectedOrCancelled || isPendingCancel) {
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
    } else if (isApproved) {
      canShowEditButton.value = false;
      canShowBlockButton.value = isOwner || isManager;
    } else {
      canShowEditButton.value = isOwner;
      canShowBlockButton.value = isOwner || isManager;
    }
  }

  void _safeUpdateButtonVisibility() {
    if (leave != null && myId != null) {
      _updateButtonVisibility();
    } else {
      canShowEditButton.value = false;
      canShowBlockButton.value = false;
    }
  }

  void _updateCanShowModifyButtons() {
    if (leave == null || myId == null) {
      canShowModifyButtons.value = false;
      return;
    }

    final int? status = leave!.status;
    final String? statusLabel = leave!.statusLabel;
    final String? employeeId = leave!.employeeId;
    final bool isOwner = myId == employeeId;
    final bool isManager = _isManager();

    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (statusLabel == 'Từ chối') ||
        (statusLabel == 'Huỷ đơn');

    final bool isPendingCancel =
        (status == 99) || (statusLabel == 'Chờ hủy đơn');

    if (isRejectedOrCancelled || isPendingCancel) {
      canShowModifyButtons.value = false;
      return;
    }

    final bool canModify = (isOwner || isManager) && !isRejectedOrCancelled;

    canShowModifyButtons.value = canModify;
  }

  bool get canShowCommentInput {
    if (leave == null) return false;

    final int? status = leave!.status;
    final bool isRejectedOrCancelled =
        (status == 3) ||
        (status == 4) ||
        (leave!.statusLabel == 'Từ chối') ||
        (leave!.statusLabel == 'Huỷ đơn');

    final bool isPendingCancel =
        (status == 99) || (leave!.statusLabel == 'Chờ hủy đơn');

    return !isRejectedOrCancelled && !isPendingCancel;
  }

  void navigateToUpdate() {
    if (leave == null) return;

    debugPrint("Navigating to update screen...");
    Get.toNamed(AppRouter.leaveUpdate, arguments: LeaveUpdateData(leave: leave))
        ?.then((value) {
          debugPrint("Update screen returned with value: $value");
          debugPrint("Value type: ${value.runtimeType}");
          if (value == true) {
            debugPrint("Reloading leave data after successful update");
            loadLeaveData();
          } else {
            debugPrint("Update was not successful or cancelled");
          }
        })
        .catchError((error) {
          debugPrint("Error in navigation: $error");
        });
  }

  Future<void> cancelLeave() async {
    if (leaveId == null || Get.context == null) return;

    try {
      final bool isApproved =
          (leave?.status == 2) || (leave?.statusLabel == 'Đã duyệt');

      final result = await LeaveRequestDialogs.showCancelLeaveDialog(
        Get.context!,
        isApproved: isApproved,
      );

      if (result != null && result['confirmed'] == true) {
        final String reason = result['reason'] as String;

        isLoading.value = true;

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
        // Error handling
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
        Get.snackbar(
          'Lỗi',
          'Không thể từ chối đơn: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

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
      }
    } catch (e) {
      // Error loading comments
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> addComment() async {
    if (leaveId == null || commentController.text.trim().isEmpty) return;

    final commentText = commentController.text.trim();
    commentController.clear();

    final newComment = LeaveComment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: '00000000-0000-0000-0000-000000000000',
      content: commentText,
      createdDate: DateTime.now().toIso8601String(),
      creator: 'Bạn',
      createdById: myId ?? '',
    );

    comments.insert(0, newComment);

    try {
      isLoadingComments.value = true;

      final response = await commentService.addLeaveComment(
        leaveId!,
        commentText,
        Get.context!,
      );

      if (response != null && response.statusCode == 200 && response.data) {
        await loadComments();
      } else {
        comments.removeWhere((comment) => comment.id == newComment.id);
      }
    } catch (e) {
      comments.removeWhere((comment) => comment.id == newComment.id);
    } finally {
      isLoadingComments.value = false;
    }
  }

  Color getStatusColor(String? statusLabel) {
    if (statusLabel == null || statusLabel.isEmpty) {
      return Color(0xFF455A64); // Tạo mới - Xám đậm
    }

    switch (statusLabel.toLowerCase().trim()) {
      case 'đang xử lý':
      case 'đơn cần duyệt':
        return Color(0xFFF9A825); // Chờ duyệt - Vàng cam
      case 'đã duyệt':
        return Color(0xFF43A047); // Đã duyệt - Xanh lá
      case 'chờ xử lý':
      case 'chờ duyệt':
        return Color(0xFFF9A825); // Chờ duyệt - Vàng cam
      case 'chờ huỷ đơn':
        return Color(0xFFF9A825); // Tạo mới - Xám đậm
      case 'từ chối':
        return Color(0xFFED3241); // Từ chối - Đỏ
      case 'hủy đơn':
        return Color(0xFFED3241); // Hủy đơn - Đỏ
      case 'hủy':
        return Color(0xFFED3241); // Hủy - Đỏ
      case 'tạo mới':
        return Color(0xFF455A64); // Tạo mới - Xám đậm
      case '1': // Trạng thái số - Đơn cần duyệt
        return Color(0xFFF9A825); // Chờ duyệt - Vàng cam
      case '2': // Trạng thái số - Đã duyệt
        return Color(0xFF43A047); // Đã duyệt - Xanh lá
      case '3': // Trạng thái số - Từ chối
        return Color(0xFFED3241); // Từ chối - Đỏ
      case '4': // Trạng thái số - Hủy đơn
        return Color(0xFFED3241); // Hủy đơn - Đỏ
      case '99': // Trạng thái số - Chờ hủy đơn
        return Color(0xFF455A64); // Tạo mới - Xám đậm
      default:
        return Color(0xFF455A64); // Tạo mới - Xám đậm
    }
  }

  void forceRebuild() {
    _updateCanShowModifyButtons();
    _safeUpdateButtonVisibility();
    update();
  }

  void debugButtonVisibility() {
    // Debug method removed
  }
}
