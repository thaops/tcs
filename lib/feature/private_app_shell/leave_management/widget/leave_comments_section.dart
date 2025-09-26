import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/controller/leave_request_detail_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_comment.dart';

/// Widget hiển thị section comments cho leave request
class LeaveCommentsSection extends StatefulWidget {
  const LeaveCommentsSection({Key? key}) : super(key: key);

  @override
  State<LeaveCommentsSection> createState() => _LeaveCommentsSectionState();
}

class _LeaveCommentsSectionState extends State<LeaveCommentsSection> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<LeaveRequestDetailController>();
    controller.commentController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaveRequestDetailController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          _buildHeader(),

          // Comments list
          Obx(() => Center(child: _buildCommentsList(controller))),

          // Add comment input - chỉ hiển thị khi đơn chưa duyệt/từ chối
          Obx(() {
            // Sử dụng isLoading để trigger Obx updates
            final isLoading = controller.isLoading.value;
            final leave = controller.leave;

            // Nếu đang loading, hiển thị input bình thường
            if (isLoading) {
              return _buildAddCommentInput(controller);
            }

            if (leave != null) {
              final bool isApprovedOrRejectedOrCancelled =
                  (leave.status == 2) ||
                  (leave.status == 3) ||
                  (leave.status == 4) || // Thêm status 4 cho Hủy
                  (leave.statusLabel == 'Đã duyệt') ||
                  (leave.statusLabel == 'Từ chối') ||
                  (leave.statusLabel == 'Hủy');

              if (isApprovedOrRejectedOrCancelled) {
                return const SizedBox.shrink();
              }
            }
            return _buildAddCommentInput(controller);
          }),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.r),
          topRight: Radius.circular(14.r),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.comment_outlined, color: Color(0xFF3B82F6), size: 18.sp),
          SizedBox(width: 8.w),
          TextWidget(
            text: "Ý kiến",
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
          Spacer(),
          Obx(() {
            final controller = Get.find<LeaveRequestDetailController>();
            // Sử dụng isLoading để trigger Obx updates
            final isLoading = controller.isLoading.value;
            final leave = controller.leave;

            // Nếu đang loading, hiển thị số lượng comments bình thường
            if (isLoading) {
              return TextWidget(
                text: "${controller.comments.length} ý kiến",
                fontSize: 12.sp,
                color: Color(0xFF6B7280),
              );
            }

            if (leave != null) {
              final bool isApprovedOrRejectedOrCancelled =
                  (leave.status == 2) ||
                  (leave.status == 3) ||
                  (leave.status == 4) || // Thêm status 4 cho Hủy
                  (leave.statusLabel == 'Đã duyệt') ||
                  (leave.statusLabel == 'Từ chối') ||
                  (leave.statusLabel == 'Hủy');

              if (isApprovedOrRejectedOrCancelled) {
                return TextWidget(
                  text: "Đã đóng bình luận",
                  fontSize: 12.sp,
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.w500,
                );
              }
            }
            return TextWidget(
              text: "${controller.comments.length} ý kiến",
              fontSize: 12.sp,
              color: Color(0xFF6B7280),
            );
          }),
        ],
      ),
    );
  }

  /// Build comments list
  Widget _buildCommentsList(LeaveRequestDetailController controller) {
    if (controller.comments.isEmpty && !controller.isLoadingComments.value) {
      return Container(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.comment_outlined, color: Color(0xFFD1D5DB), size: 40.sp),
            SizedBox(height: 12.h),
            TextWidget(
              text: "Chưa có ý kiến nào",
              fontSize: 14.sp,
              textAlign: TextAlign.center,
              color: Color(0xFF6B7280),
            ),
            SizedBox(height: 4.h),
            TextWidget(
              text: "Hãy là người đầu tiên đưa ra ý kiến",
              fontSize: 12.sp,
              textAlign: TextAlign.center,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      itemCount: controller.comments.length,
      separatorBuilder:
          (context, index) => Divider(height: 1, color: Color(0xFFE5E7EB)),
      itemBuilder: (context, index) {
        final comment = controller.comments[index];
        return _buildCommentItem(comment);
      },
    );
  }

  /// Build individual comment item
  Widget _buildCommentItem(LeaveComment comment) {
    final controller = Get.find<LeaveRequestDetailController>();
    final isOptimistic =
        comment.creator == 'Bạn' && controller.isLoadingComments.value;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header
          Row(
            children: [
              // Avatar
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: isOptimistic ? Color(0xFF9CA3AF) : Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: TextWidget(
                    text:
                        comment.creator.isNotEmpty
                            ? comment.creator[0].toUpperCase()
                            : '?',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Creator name and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextWidget(
                          text: comment.creator,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isOptimistic
                                  ? Color(0xFF9CA3AF)
                                  : Color(0xFF1F2937),
                        ),
                        if (isOptimistic) ...[
                          SizedBox(width: 6.w),
                          SizedBox(
                            width: 12.w,
                            height: 12.w,
                            child: CircularProgressIndicator(
                              color: Color(0xFF9CA3AF),
                              strokeWidth: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Comment content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isOptimistic ? Color(0xFFF3F4F6) : Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isOptimistic ? Color(0xFFD1D5DB) : Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Text(
              comment.content,
              style: TextStyle(
                fontSize: 13.sp,
                color: isOptimistic ? Color(0xFF9CA3AF) : Color(0xFF374151),
                height: 1.4,
              ),
              maxLines: null,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Build add comment input - Chat style
  Widget _buildAddCommentInput(LeaveRequestDetailController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Text input
          Expanded(
            child: Container(
              constraints: BoxConstraints(minHeight: 36.h, maxHeight: 100.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: Color(0xFFD1D5DB), width: 1),
              ),
              child: TextField(
                controller: controller.commentController,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: "Nhập ý kiến...",
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.r,
                    vertical: 8.r,
                  ),
                ),
                style: TextStyle(fontSize: 13.sp, color: Color(0xFF374151)),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Send button
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color:
                  controller.commentController.text.trim().isEmpty
                      ? Color(0xFFD1D5DB)
                      : Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18.r),
                onTap:
                    controller.commentController.text.trim().isEmpty
                        ? null
                        : () => controller.addComment(),
                child: Center(
                  child: Icon(
                    Icons.send_rounded,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
