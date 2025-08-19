class ResponseModel {
  final int statusCode;
  final String message;
  final int totalRecord;
  final Data data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      totalRecord: json['totalRecord'],
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'totalRecord': totalRecord,
      'data': data.toJson(),
    };
  }

  @override
  String toString() {
    return 'ResponseModel(statusCode: $statusCode, message: $message, totalRecord: $totalRecord, data: $data)';
  }
}
class Data {
  final int numberOfDaysOffRemaining;
  final List<WorkFlow> workFlows;
  final String id;
  final String employeeId;
  final String department;
  final String? avatarUrl;
  final String fullName;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalDay;
  final String categoryId;
  final String? category;
  final int status;
  final String statusLabel;
  final DateTime? approvalDate;
  final DateTime? lastApprovalDate;
  final String reason;
  final String? note;
  final DateTime createdDate;
  final bool isDeleted;

  Data({
    required this.numberOfDaysOffRemaining,
    required this.workFlows,
    required this.id,
    required this.employeeId,
    required this.department,
    this.avatarUrl,
    required this.fullName,
    required this.fromDate,
    required this.toDate,
    required this.totalDay,
    required this.categoryId,
    this.category,
    required this.status,
    required this.statusLabel,
    this.approvalDate,
    this.lastApprovalDate,
    required this.reason,
    this.note,
    required this.createdDate,
    required this.isDeleted,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      numberOfDaysOffRemaining: json['numberOfDaysOffRemaining'],
      workFlows: (json['workFlows'] as List)
          .map((item) => WorkFlow.fromJson(item))
          .toList(),
      id: json['id'],
      employeeId: json['employeeId'],
      department: json['department'],
      avatarUrl: json['avatarUrl'],
      fullName: json['fullName'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      totalDay: json['totalDay'],
      categoryId: json['categoryId'],
      category: json['category'],
      status: json['status'],
      statusLabel: json['statusLabel'],
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      lastApprovalDate: json['lastApprovalDate'] != null
          ? DateTime.parse(json['lastApprovalDate'])
          : null,
      reason: json['reason'],
      note: json['note'],
      createdDate: DateTime.parse(json['createdDate']),
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfDaysOffRemaining': numberOfDaysOffRemaining,
      'workFlows': workFlows.map((item) => item.toJson()).toList(),
      'id': id,
      'employeeId': employeeId,
      'department': department,
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'fromDate': fromDate.toIso8601String(),
      'toDate': toDate.toIso8601String(),
      'totalDay': totalDay,
      'categoryId': categoryId,
      'category': category,
      'status': status,
      'statusLabel': statusLabel,
      'approvalDate': approvalDate?.toIso8601String(),
      'lastApprovalDate': lastApprovalDate?.toIso8601String(),
      'reason': reason,
      'note': note,
      'createdDate': createdDate.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  @override
  String toString() {
    return 'Data(numberOfDaysOffRemaining: $numberOfDaysOffRemaining, workFlows: $workFlows, id: $id, employeeId: $employeeId, department: $department, avatarUrl: $avatarUrl, fullName: $fullName, fromDate: $fromDate, toDate: $toDate, totalDay: $totalDay, categoryId: $categoryId, category: $category, status: $status, statusLabel: $statusLabel, approvalDate: $approvalDate, lastApprovalDate: $lastApprovalDate, reason: $reason, note: $note, createdDate: $createdDate, isDeleted: $isDeleted)';
  }
}
class WorkFlow {
  final String id;
  final String approverId;
  final String approver;
  final DateTime? approvalDate;
  final int step;
  final int status;
  final String statusLabel;
  final String? note;
  final DateTime createdDate;
  final bool isDeleted;

  WorkFlow({
    required this.id,
    required this.approverId,
    required this.approver,
    this.approvalDate,
    required this.step,
    required this.status,
    required this.statusLabel,
    this.note,
    required this.createdDate,
    required this.isDeleted,
  });

  factory WorkFlow.fromJson(Map<String, dynamic> json) {
    return WorkFlow(
      id: json['id'],
      approverId: json['approverId'],
      approver: json['approver'],
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      step: json['step'],
      status: json['status'],
      statusLabel: json['statusLabel'],
      note: json['note'],
      createdDate: DateTime.parse(json['createdDate']),
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'approverId': approverId,
      'approver': approver,
      'approvalDate': approvalDate?.toIso8601String(),
      'step': step,
      'status': status,
      'statusLabel': statusLabel,
      'note': note,
      'createdDate': createdDate.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  @override
  String toString() {
    return 'WorkFlow(id: $id, approverId: $approverId, approver: $approver, approvalDate: $approvalDate, step: $step, status: $status, statusLabel: $statusLabel, note: $note, createdDate: $createdDate, isDeleted: $isDeleted)';
  }
}
