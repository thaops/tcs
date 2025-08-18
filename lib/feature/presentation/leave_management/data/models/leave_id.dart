class LeaveID {
  final int numberOfDaysOffRemaining;
  final String? id;
  final String? employeeId;
  final String? department;
  final String? avatarUrl;
  final String fullName;
  final DateTime? fromDate;
  final DateTime? toDate;
  final dynamic totalDay;
  final String? categoryId;
  final String? category;
  final int? status;
  final String? statusLabel;
  final DateTime? approvalDate;
  final DateTime? lastApprovalDate;
  final String reason;
  final String? note;
  final DateTime? createdDate;
  final bool? isDeleted;
  final List<WorkFlow>? workFlows;

  LeaveID({
    required this.numberOfDaysOffRemaining,
    this.id,
    this.employeeId,
    this.department,
    this.avatarUrl,
    required this.fullName,
    this.fromDate,
    this.toDate,
    this.totalDay,
    this.categoryId,
    this.category,
    this.status,
    this.statusLabel,
    this.approvalDate,
    this.lastApprovalDate,
    required this.reason,
    this.note,
    this.createdDate,
    this.isDeleted,
    this.workFlows,
  });

  factory LeaveID.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return LeaveID(
        numberOfDaysOffRemaining: 0,
        fullName: '',
        reason: '',
      );
    }

    return LeaveID(
      numberOfDaysOffRemaining: json['numberOfDaysOffRemaining'] as int? ?? 0,
      id: json['id'] as String?,
      employeeId: json['employeeId'] as String?,
      department: json['department'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      fullName: json['fullName'] as String? ?? '',
      fromDate: json['fromDate'] != null 
          ? DateTime.tryParse(json['fromDate'] as String) 
          : null,
      toDate: json['toDate'] != null 
          ? DateTime.tryParse(json['toDate'] as String) 
          : null,
      totalDay: json['totalDay'],
      categoryId: json['categoryId'] as String?,
      category: json['category'] as String?,
      status: json['status'] as int?,
      statusLabel: json['statusLabel'] as String?,
      approvalDate: json['approvalDate'] != null 
          ? DateTime.tryParse(json['approvalDate'] as String) 
          : null,
      lastApprovalDate: json['lastApprovalDate'] != null 
          ? DateTime.tryParse(json['lastApprovalDate'] as String) 
          : null,
      reason: json['reason'] as String? ?? '',
      note: json['note'] as String?,
      createdDate: json['createdDate'] != null 
          ? DateTime.tryParse(json['createdDate'] as String) 
          : null,
      isDeleted: json['isDeleted'] as bool?,
      workFlows: json['workFlows'] != null
          ? (json['workFlows'] as List<dynamic>)
              .map((workflow) => WorkFlow.fromJson(workflow as Map<String, dynamic>?))
              .where((workflow) => workflow != null)
              .cast<WorkFlow>()
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfDaysOffRemaining': numberOfDaysOffRemaining,
      'id': id,
      'employeeId': employeeId,
      'department': department,
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'totalDay': totalDay,
      'categoryId': categoryId,
      'category': category,
      'status': status,
      'statusLabel': statusLabel,
      'approvalDate': approvalDate?.toIso8601String(),
      'lastApprovalDate': lastApprovalDate?.toIso8601String(),
      'reason': reason,
      'note': note,
      'createdDate': createdDate?.toIso8601String(),
      'isDeleted': isDeleted,
      'workFlows': workFlows?.map((workflow) => workflow.toJson()).toList(),
    };
  }
}

class WorkFlow {
  final String id;
  final String approverId;
  final String approver;
  final DateTime? approvalDate;
  final int? step;
  final int? status;
  final String? statusLabel;
  final String? note;
  final DateTime? createdDate;
  final bool? isDeleted;

  WorkFlow({
    required this.id,
    required this.approverId,
    required this.approver,
    this.approvalDate,
    this.step,
    this.status,
    this.statusLabel,
    this.note,
    this.createdDate,
    this.isDeleted,
  });

  factory WorkFlow.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WorkFlow(
        id: '',
        approverId: '',
        approver: '',
      );
    }

    return WorkFlow(
      id: json['id'] as String? ?? '',
      approverId: json['approverId'] as String? ?? '',
      approver: json['approver'] as String? ?? '',
      approvalDate: json['approvalDate'] != null 
          ? DateTime.tryParse(json['approvalDate'] as String) 
          : null,
      step: json['step'] as int?,
      status: json['status'] as int?,
      statusLabel: json['statusLabel'] as String?,
      note: json['note'] as String?,
      createdDate: json['createdDate'] != null 
          ? DateTime.tryParse(json['createdDate'] as String) 
          : null,
      isDeleted: json['isDeleted'] as bool?,
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
      'createdDate': createdDate?.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}