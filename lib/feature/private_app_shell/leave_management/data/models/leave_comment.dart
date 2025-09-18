/// Model cho comment trong leave request
class LeaveComment {
  final String id;
  final String parentId;
  final String content;
  final String createdDate;
  final String creator;
  final String createdById;

  LeaveComment({
    required this.id,
    required this.parentId,
    required this.content,
    required this.createdDate,
    required this.creator,
    required this.createdById,
  });

  factory LeaveComment.fromJson(Map<String, dynamic> json) {
    return LeaveComment(
      id: json['id'] ?? '',
      parentId: json['parentId'] ?? '',
      content: json['content'] ?? '',
      createdDate: json['createdDate'] ?? '',
      creator: json['creator'] ?? '',
      createdById: json['createdById'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'content': content,
      'createdDate': createdDate,
      'creator': creator,
      'createdById': createdById,
    };
  }
}

/// Model cho response API get comments
class LeaveCommentResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final List<LeaveComment> data;

  LeaveCommentResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory LeaveCommentResponse.fromJson(Map<String, dynamic> json) {
    return LeaveCommentResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => LeaveComment.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// Model cho request add comment
class AddCommentRequest {
  final String dayOffId;
  final String content;

  AddCommentRequest({required this.dayOffId, required this.content});

  Map<String, dynamic> toJson() {
    return {'DayOffId': dayOffId, 'Content': content};
  }
}

/// Model cho response API add comment
class AddCommentResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final bool data;

  AddCommentResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) {
    return AddCommentResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data: json['data'] ?? false,
    );
  }
}
