import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_comment.dart';

/// Service xử lý API calls cho leave comments
class LeaveCommentService {
  final DioApi _dioApi = DioApi();

  /// Lấy danh sách comments của một leave request
  Future<LeaveCommentResponse?> getLeaveComments(
    String dayOffId,
    BuildContext context,
  ) async {
    try {
      final url = ApiEndpoints.getLeaveCommentsV2(dayOffId);
      final response = await _dioApi.get(url);

      if (response.statusCode == 200) {
        return LeaveCommentResponse.fromJson(response.data);
      } else {
        debugPrint('Error getting comments: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception getting comments: $e');
      return null;
    }
  }

  /// Thêm comment mới cho leave request
  Future<AddCommentResponse?> addLeaveComment(
    String dayOffId,
    String content,
    BuildContext context,
  ) async {
    try {
      final url = ApiEndpoints.addLeaveCommentV2;
      final request = AddCommentRequest(dayOffId: dayOffId, content: content);

      final response = await _dioApi.post(url, data: request.toJson());

      if (response.statusCode == 200) {
        return AddCommentResponse.fromJson(response.data);
      } else {
        debugPrint('Error adding comment: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception adding comment: $e');
      return null;
    }
  }
}
