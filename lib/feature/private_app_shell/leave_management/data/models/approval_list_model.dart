class ApprovalListResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final List<ApprovalData> data;

  ApprovalListResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory ApprovalListResponse.fromJson(Map<String, dynamic> json) {
    return ApprovalListResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => ApprovalData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'totalRecord': totalRecord,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ApprovalData {
  final String id;
  final String receiverId;
  final String receiverName;
  final int step;
  final int status;
  final bool isCompleted;

  ApprovalData({
    required this.id,
    required this.receiverId,
    required this.receiverName,
    required this.step,
    required this.status,
    required this.isCompleted,
  });

  factory ApprovalData.fromJson(Map<String, dynamic> json) {
    return ApprovalData(
      id: json['id'] ?? '',
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      step: json['step'] ?? 0,
      status: json['status'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'step': step,
      'status': status,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'ApprovalData(id: $id, receiverId: $receiverId, receiverName: $receiverName, step: $step, status: $status, isCompleted: $isCompleted)';
  }
}
