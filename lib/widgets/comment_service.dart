// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:tcs_flutter/common/Services/api_endpoints.dart';
// import 'package:tcs_flutter/common/repositoty/dio_api.dart';
// import 'package:tcs_flutter/common/utils/custom_dialog.dart';
// import 'package:tcs_flutter/common/widgets/text_widget.dart';
// import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

// class CommentService {
//   final DioApi dioApi = DioApi();
//   final Rx<CommentModel?> commentModel;
//   final String assigneeName;
//   final String myID;

//   CommentService({
//     required this.commentModel,
//     required this.assigneeName,
//     required this.myID,
//   });

//   Future<void> addComment({
//     required String comment,
//     required String tId,
//     String? parentId,
//   }) async {
//     try {
//       final id = await _callAddComment(comment, tId);
//       final newComment = CommentModel(
//         id: id,
//         tid: tId,
//         parentId: parentId,
//         content: comment,
//         creator: assigneeName,
//         creatorId: myID,
//         createdDate: DateTime.now(),
//         updatedDate: DateTime.now(),
//         modifier: assigneeName,
//         modifierId: myID,
//         isEdited: false,
//         replies: [],
//       );

//       // Khởi tạo comments nếu boardDetail.value là null
//       final updatedComments = commentModel.value != null
//           ? [...commentModel.value!.replies!, newComment]
//           : [newComment];

//       commentModel.value = commentModel.value?.copyWith(
//             replies: updatedComments,
//           ) ?? CommentModel(
//             replies: updatedComments,
//           );
//       commentModel.refresh();
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể thêm bình luận: $e');
//     }
//   }

//   Future<String> _callAddComment(String comment, String tId) async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.addComment, data: {
//         "content": comment,
//         "parentId": null,
//         "tid": tId,
//       });
//       if (response.data['data'] == null) {
//         throw Exception('API trả về dữ liệu null');
//       }
//       return response.data['data'] as String;
//     } catch (e) {
//       throw Exception('Không thể thêm bình luận: $e');
//     }
//   }

//   Future<void> addReply({
//     required String parentId,
//     required String reply,
//     required String tId,
//   }) async {
//     try {
//       await _callAddReply(parentId, reply, tId);
//       await _refreshCommentModel(tId); // Làm mới dữ liệu từ API
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể thêm trả lời: $e');
//     }
//   }

//   Future<void> _callAddReply(String parentId, String reply, String tId) async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.replyComment, data: {
//         "content": reply,
//         "parentId": parentId,
//         "tid": tId,
//       });
//       if (response.statusCode != 200) {
//         throw Exception('API trả về mã lỗi: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Không thể thêm trả lời: $e');
//     }
//   }

//   Future<void> updateComment({
//     required String comment,
//     required String id,
//     required String tId,
//     String? parentId,
//   }) async {
//     try {
//       await _callUpdateComment(comment, id, tId);
//       if (commentModel.value == null || commentModel.value!.replies == null) {
//         throw Exception('Dữ liệu bình luận không khả dụng');
//       }

//       CommentModel? oldComment;
//       if (parentId != null) {
//         final parentComment = commentModel.value!.replies!.firstWhere(
//           (c) => c.id == parentId,
//           orElse: () => throw StateError('Không tìm thấy bình luận gốc'),
//         );
//         oldComment = parentComment.replies?.firstWhere(
//           (r) => r.id == id,
//           orElse: () => throw StateError('Không tìm thấy trả lời'),
//         );
//       } else {
//         oldComment = commentModel.value!.replies!.firstWhere(
//           (c) => c.id == id,
//           orElse: () => throw StateError('Không tìm thấy bình luận'),
//         );
//       }

//       final newComment = CommentModel(
//         id: id,
//         tid: tId,
//         parentId: parentId,
//         content: comment,
//         creator: oldComment?.creator ?? assigneeName,
//         creatorId: oldComment?.creatorId ?? myID,
//         createdDate: oldComment?.createdDate ?? DateTime.now(),
//         updatedDate: DateTime.now(),
//         modifier: assigneeName,
//         modifierId: myID,
//         isEdited: true,
//         replies: oldComment?.replies ?? [],
//       );

//       if (parentId != null) {
//         final updatedComments = commentModel.value!.replies!.map((comment) {
//           if (comment.id == parentId) {
//             final updatedReplies = (comment.replies ?? []).map((reply) {
//               return reply.id == id ? newComment : reply;
//             }).toList();
//             return comment.copyWith(replies: updatedReplies);
//           }
//           return comment;
//         }).toList();
//         commentModel.value = commentModel.value!.copyWith(replies: updatedComments);
//       } else {
//         final updatedComments = commentModel.value!.replies!.map((comment) {
//           return comment.id == id ? newComment : comment;
//         }).toList();
//         commentModel.value = commentModel.value!.copyWith(
//           replies: updatedComments,
//         );
//       }
//       commentModel.refresh();
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể cập nhật bình luận: $e');
//     }
//   }

//   Future<void> _callUpdateComment(String comment, String id, String tId) async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.updateComment(id), data: {
//         "content": comment,
//         "id": id,
//         "tid": tId,
//       });
//       if (response.statusCode != 200) {
//         throw Exception('API trả về mã lỗi: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Không thể cập nhật bình luận: $e');
//     }
//   }

//   Future<void> showDeleteComment({
//     required String commentId,
//     required String parentId,
//   }) async {
//     final confirmed = await CustomDialog().showConfirmationDialog(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextWidget(
//             text: "Thông báo",
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//           const SizedBox(height: 10),
//           TextWidget(
//             text: "Bạn chắc chắn muốn xóa bình luận này chứ?",
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//           ),
//         ],
//       ),
//     );

//     if (confirmed ?? false) {
//       await _deleteComment(commentId, parentId: parentId);
//     }
//   }

//   Future<void> _deleteComment(String commentId, {String? parentId}) async {
//     try {
//       await _callDeleteComment(commentId);
//       if (commentModel.value == null || commentModel.value!.replies == null) {
//         throw Exception('Dữ liệu bình luận không khả dụng');
//       }

//       if (parentId != null && parentId.isNotEmpty) {
//         final updatedComments = commentModel.value!.replies!.map((comment) {
//           if (comment.id == parentId) {
//             final updatedReplies =
//                 comment.replies?.where((reply) => reply.id != commentId).toList();
//             return comment.copyWith(replies: updatedReplies ?? []);
//           }
//           return comment;
//         }).toList();
//         commentModel.value = commentModel.value!.copyWith(replies: updatedComments);
//       } else {
//         final updatedComments = commentModel.value!.replies!
//             .where((comment) => comment.id != commentId)
//             .toList();
//         commentModel.value = commentModel.value!.copyWith(
//           replies: updatedComments,
//         );
//       }
//       commentModel.refresh();
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể xóa bình luận: $e');
//     }
//   }

//   Future<void> _callDeleteComment(String commentId) async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.deleteComment, data: {
//         "id": commentId,
//       });
//       if (response.statusCode != 200) {
//         throw Exception('API trả về mã lỗi: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Không thể xóa bình luận: $e');
//     }
//   }

//   Future<void> _refreshCommentModel(String taskId) async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.boardDetail, data: {
//         "id": taskId,
//       });
//       if (response.statusCode == 200) {
//         commentModel.value = CommentModel.fromJson(response.data['data']);
//         commentModel.refresh();
//       } else {
//         throw Exception('API trả về mã lỗi: ${response.statusCode}');
//       }
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Không thể làm mới chi tiết bảng: $e');
//     }
//   }

//   void showDialogComment({
//     required BuildContext context,
//     required String comment,
//     required String id,
//     required String tId,
//     required bool isReply,
//     String? parentId,
//   }) {
//     final TextEditingController _commentController =
//         TextEditingController(text: comment);
//     Get.dialog(
//       CupertinoAlertDialog(
//         title: TextWidget(
//           text: isReply ? 'Trả lời bình luận' : 'Cập nhật bình luận',
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: AppColors.primary,
//           textAlign: TextAlign.center,
//         ),
//         content: Padding(
//           padding: const EdgeInsets.only(top: 16.0),
//           child: CupertinoTextField(
//             controller: _commentController,
//             placeholder: 'Nhập nội dung bình luận...',
//             maxLines: 5,
//             decoration: BoxDecoration(
//               border: Border.all(color: CupertinoColors.systemGrey4),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             padding: const EdgeInsets.all(10.0),
//           ),
//         ),
//         actions: [
//           CupertinoDialogAction(
//             child: TextWidget(
//               text: 'Hủy',
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: AppColors.primary,
//             ),
//             onPressed: () => Get.back(),
//             isDefaultAction: true,
//           ),
//           CupertinoDialogAction(
//             child: TextWidget(
//               text: 'Lưu',
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: AppColors.colorRed,
//             ),
//             onPressed: () async {
//               if (_commentController.text.isNotEmpty &&
//                   _commentController.text != comment) {
//                 if (isReply) {
//                   await addReply(
//                     parentId: parentId!,
//                     reply: _commentController.text,
//                     tId: tId,
//                   );
//                 } else {
//                   await updateComment(
//                     comment: _commentController.text,
//                     id: id,
//                     tId: tId,
//                     parentId: parentId,
//                   );
//                 }
//                 Get.back();
//               }
//             },
//             isDestructiveAction: false,
//           ),
//         ],
//       ),
//       barrierDismissible: true,
//     );
//   }
// }