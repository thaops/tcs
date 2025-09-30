import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/controller/leave_request_detail_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_request_header_section.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_request_attachment_card.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_request_workflow_card.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_button_browse.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/service/attachment_download_service.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/service/image_gallery_service.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_request_dialogs.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_comments_section.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';

/// Screen hiển thị chi tiết leave request - đã được refactor
class ListoffDetail extends StatelessWidget {
  const ListoffDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveRequestDetailController());
    final downloadService = AttachmentDownloadService();
    final galleryService = ImageGalleryService();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildAppBar(controller),
      body: GestureDetector(
        onTap: () {
          // Ẩn keyboard khi tap ngoài
          FocusScope.of(context).unfocus();
        },
        child: Obx(
          () => LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8FAFC), Colors.white],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header với thông tin chính
                    LeaveRequestHeaderSection(
                      leave: controller.leave,
                      getStatusColor: controller.getStatusColor,
                    ),

                    // Content cards
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      child: Column(
                        children: [
                          SizedBox(height: 8.h),

                          // Attachments Card
                          if (controller.leave?.attachments?.isNotEmpty ==
                              true) ...[
                            LeaveRequestAttachmentCard(
                              attachments: controller.leave?.attachments,
                              onDownloadAttachment:
                                  (attachment) => _handleDownloadAttachment(
                                    context,
                                    attachment,
                                    downloadService,
                                  ),
                              onShowImageGallery:
                                  (attachment) => _handleShowImageGallery(
                                    context,
                                    attachment,
                                    controller.leave?.attachments ?? [],
                                    galleryService,
                                  ),
                            ),
                            SizedBox(height: 20.h),
                          ],

                          // Workflow Card
                          LeaveRequestWorkflowCard(
                            workflows:
                                controller.leave?.workFlows?.cast<WorkFlow>(),
                          ),
                          SizedBox(height: 20.h),

                          // Comments Section
                          LeaveCommentsSection(),
                          SizedBox(height: 20.h),

                          // Action Buttons
                          Obx(
                            () =>
                                controller.shouldShowApproveButtons.value
                                    ? _buildActionButtons(controller)
                                    : const SizedBox.shrink(),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build AppBar
  PreferredSizeWidget _buildAppBar(LeaveRequestDetailController controller) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFF374151),
          size: 20.sp,
        ),
        onPressed: () => Get.back(),
      ),
      title: TextWidget(
        text: "Duyệt nguyện vọng nghỉ",
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2937),
      ),
      centerTitle: true,
      actions: [
        Obx(() {
          final canShowEdit = controller.canShowEditButton.value;
          final canShowBlock = controller.canShowBlockButton.value;
          
          if (!canShowEdit && !canShowBlock) {
            return SizedBox(width: 8.w);
          }
          
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nút Edit - chỉ hiển thị khi đơn chưa duyệt
              if (canShowEdit)
                IconButton(
                  icon: Icon(
                    Icons.edit_note_sharp,
                    color: Color(0xFF3B82F6),
                    size: 22.sp,
                  ),
                  onPressed: () => controller.navigateToUpdate(),
                ),
              
              // Nút Block - chỉ hiển thị khi đơn đã duyệt
              if (canShowBlock)
                IconButton(
                  icon: Icon(
                    Icons.block_outlined,
                    color: Color(0xFFEF4444),
                    size: 22.sp,
                  ),
                  onPressed: () => controller.cancelLeave(),
                ),
              
              SizedBox(width: 8.w),
            ],
          );
        }),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Container(
          height: 1.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFFE5E7EB).withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build action buttons (approve/reject)
  Widget _buildActionButtons(LeaveRequestDetailController controller) {
    return LeaveButtonBrowse(
      approver_on: () => controller.showApproveDialog(),
      approver_off: () => controller.showRejectDialog(),
    );
  }

  /// Handle download attachment
  Future<void> _handleDownloadAttachment(
    BuildContext context,
    dynamic attachment,
    AttachmentDownloadService downloadService,
  ) async {
    // Show loading dialog
    LeaveRequestDialogs.showLoadingDialog(
      context,
      _isImageFile(attachment.type),
    );

    try {
      final result = await downloadService.downloadAttachment(
        attachment,
        context,
      );

      Navigator.of(context).pop(); // Close loading dialog

      if (result['success'] == true) {
        LeaveRequestDialogs.showDownloadSuccessDialog(
          context,
          result['fileName'],
          result['filePath'],
        );
      } else {
        _showSnackBar('Lỗi: ${result['error']}', Colors.red);
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      _showSnackBar('Lỗi khi tải file: ${e.toString()}', Colors.red);
    }
  }

  /// Handle show image gallery
  void _handleShowImageGallery(
    BuildContext context,
    dynamic attachment,
    List<dynamic> attachments,
    ImageGalleryService galleryService,
  ) {
    galleryService.showImageGallery(context, attachments, attachment);
  }

  /// Check if file is image
  bool _isImageFile(String? type) {
    if (type == null) return false;
    final lowerType = type.toLowerCase();
    return lowerType == '.jpg' ||
        lowerType == '.jpeg' ||
        lowerType == '.png' ||
        lowerType == '.gif';
  }

  /// Show snackbar message
  void _showSnackBar(String message, Color color) {
    Get.snackbar(
      '',
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.r),
      borderRadius: 8.r,
      duration: Duration(seconds: 3),
    );
  }
}
