// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:npp/common/utils/date_utils.dart';
// import 'package:npp/common/widgets/text_widget.dart';
// import 'package:npp/core/configs/theme/app_colors.dart';
// import 'package:npp/common/widgets/custom_text_field.dart';
// import 'package:npp/feature/presentation/board_detail/model/board_detail_model.dart';
// import 'package:npp/feature/presentation/report/controller/report_coment_controller.dart';

// class CommentSection extends StatelessWidget {
//   final List<CommentModel?> comments;
//   final TextEditingController commentController;
//   final String myID;
//   final String taskId;
//   final bool isUpdate;
//   final ReportComentController controller;

//   const CommentSection({
//     super.key,
//     required this.comments,
//     required this.commentController,
//     required this.myID,
//     required this.taskId,
//     required this.isUpdate,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     print("myIDa: $myID");
//     final ScrollController scrollController = ScrollController();

//     void scrollToBottom() {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (scrollController.hasClients) {
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent,
//             duration: Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//           );
//         }
//       });
//     }

//     return Obx(() => Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: controller.isLoadingComment.value
//                   ? const SizedBox.shrink()
//                   : comments.isEmpty
//                       ? Center(
//                           child: TextWidget(
//                             text: 'Chưa có bình luận nào',
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         )
//                       : ListView.builder(
//                           controller: scrollController,
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           itemCount: comments.length,
//                           itemBuilder: (context, index) {
//                             final comment = comments[index];
//                             if (comment == null) return const SizedBox.shrink();
//                             return Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 8.0.r),
//                               child: Column(
//                                 children: [
//                                   _buildCommentTile(
//                                     context: context,
//                                     comment: comment,
//                                     isMyComment:
//                                         comment.creatorId == controller.myId,
//                                     isReply: false,
//                                     controller: controller,
//                                   ),
//                                   if (comment.replies?.isNotEmpty ?? false)
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 30.0.w),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: comment.replies!.map((reply) {
//                                           return _buildCommentTile(
//                                             context: context,
//                                             comment: reply,
//                                             isMyComment: reply.creatorId ==
//                                                 controller.myId,
//                                             isReply: true,
//                                             controller: controller,
//                                           );
//                                         }).toList(),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//             ),
//             if (isUpdate)
//               SafeArea(
//                 top: false,
//                 child: CustomTextField(
//                   controller: commentController,
//                   hintText: "Nhập bình luận của bạn...",
//                   backgroundColor: AppColors.bacgroundApp,
//                   paddingHorizontal: 0,
//                   paddingVertical: 12,
//                   fontSize: 14,
//                   suffixIcon: Icons.send,
//                   onSuffixTap: () {
//                     if (commentController.text.isNotEmpty) {
//                       controller.addComment(
//                         comment: commentController.text,
//                         tId: taskId,
//                         parentId: null,
//                       );
//                       commentController.clear();
//                       scrollToBottom();
//                     } else {
//                       Get.snackbar(
//                         'Thông báo',
//                         'Vui lòng nhập nội dung bình luận',
//                         snackPosition: SnackPosition.TOP,
//                         backgroundColor: Colors.red,
//                         colorText: Colors.white,
//                       );
//                     }
//                   },
//                   colorIconSuffix: commentController.text.isEmpty
//                       ? AppColors.grey
//                       : AppColors.colorIcon,
//                 ),
//               ),
//           ],
//         ));
//   }

//   Widget _buildCommentTile({
//     required BuildContext context,
//     required CommentModel comment,
//     required bool isMyComment,
//     required bool isReply,
//     required ReportComentController controller,
//   }) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 4.0.h),
//             padding: EdgeInsets.only(
//               left: 16.w,
//               right: 90.w,
//               top: 10.h,
//               bottom: 10.h,
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.colorComment,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextWidget(
//                   text: comment.creator ?? 'Ẩn danh',
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.primary,
//                   maxLines: 3,
//                 ),
//                 TextWidget(
//                   paddingVertical: 4,
//                   text: comment.content ?? '',
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   maxLines: 100,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(bottom: 8.0.h, left: 8.w),
//             child: Row(
//               children: [
//                 TextWidget(
//                   text: comment.createdDate != null
//                       ? DateUtilsCustom.formatTime(comment.createdDate!)
//                       : 'N/A',
//                   fontSize: 12.sp,
//                   fontWeight: FontWeight.w300,
//                   fontStyle: FontStyle.italic,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     controller.showDialogComment(
//                       comment: isMyComment ? comment.content ?? '' : '',
//                       id: comment.id ?? '',
//                       tId: comment.tid ?? '',
//                       parentId: isMyComment ? comment.parentId : comment.id,
//                       isReply: !isMyComment,
//                     );
//                   },
//                   child: TextWidget(
//                     paddingHorizontal: 16.w,
//                     text: isMyComment ? "Chỉnh sửa" : "Trả lời",
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w300,
//                     fontStyle: FontStyle.italic,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 if (isMyComment)
//                   InkWell(
//                     onTap: () {
//                       controller.showDeleteComment(
//                         comment.id!,
//                         comment.parentId,
//                       );
//                     },
//                     child: TextWidget(
//                       paddingHorizontal: 8.w,
//                       text: "Xóa",
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w300,
//                       fontStyle: FontStyle.italic,
//                       color: AppColors.colorRed,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
