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

  // Thêm các field mới từ API response
  final String? employeeCode;
  final String? jobTitle;
  final int? quota;
  final int? leaveDaysLeft;
  final List<Attachment>? attachments;

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
    this.employeeCode,
    this.jobTitle,
    this.quota,
    this.leaveDaysLeft,
    this.attachments,
  });

  factory LeaveID.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      print('LeaveID.fromJson: json is null');
      return LeaveID(numberOfDaysOffRemaining: 0, fullName: '', reason: '');
    }

    print('LeaveID.fromJson: parsing json with keys: ${json.keys.toList()}');

    try {
      return LeaveID(
        numberOfDaysOffRemaining: json['numberOfDaysOffRemaining'] as int? ?? 0,
        id: json['id']?.toString() ?? '',
        employeeId: json['employeeId']?.toString() ?? '',
        department: json['department']?.toString() ?? '',
        avatarUrl: json['avatarUrl']?.toString() ?? '',
        fullName:
            json['fullName']?.toString() ??
            json['employeeCode']?.toString() ??
            '',
        fromDate:
            json['fromDate'] != null
                ? DateTime.tryParse(json['fromDate'].toString())
                : null,
        toDate:
            json['toDate'] != null
                ? DateTime.tryParse(json['toDate'].toString())
                : null,
        totalDay: json['totalDay'],
        categoryId: json['categoryId']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        status: json['status'] as int?,
        statusLabel: json['statusLabel']?.toString() ?? '',
        approvalDate:
            json['approvalDate'] != null
                ? DateTime.tryParse(json['approvalDate'].toString())
                : null,
        lastApprovalDate:
            json['lastApprovalDate'] != null
                ? DateTime.tryParse(json['lastApprovalDate'].toString())
                : null,
        reason: json['reason']?.toString() ?? '',
        note: json['note']?.toString() ?? '',
        createdDate:
            json['createdDate'] != null
                ? DateTime.tryParse(json['createdDate'].toString())
                : null,
        isDeleted: json['isDeleted'] as bool?,
        workFlows:
            json['workFlows'] != null
                ? (json['workFlows'] as List<dynamic>)
                    .map(
                      (workflow) =>
                          WorkFlow.fromJson(workflow as Map<String, dynamic>?),
                    )
                    .toList()
                : null,
        employeeCode: json['employeeCode']?.toString() ?? '',
        jobTitle: json['jobTitle']?.toString() ?? '',
        quota: json['quota'] as int?,
        leaveDaysLeft: (json['leaveDaysLeft'] as num?)?.toInt(),
        attachments:
            json['attachments'] != null
                ? (json['attachments'] as List<dynamic>)
                    .map(
                      (attachment) => Attachment.fromJson(
                        attachment as Map<String, dynamic>?,
                      ),
                    )
                    .toList()
                : null,
      );
    } catch (e) {
      print('LeaveID.fromJson error: $e');
      print('LeaveID.fromJson json: $json');
      return LeaveID(numberOfDaysOffRemaining: 0, fullName: '', reason: '');
    }
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
      'employeeCode': employeeCode,
      'jobTitle': jobTitle,
      'quota': quota,
      'leaveDaysLeft': leaveDaysLeft,
      'attachments':
          attachments?.map((attachment) => attachment.toJson()).toList(),
    };
  }
}

class Attachment {
  final String id;
  final String name;
  final String url;
  final String type;
  final int size;

  Attachment({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.size,
  });

  factory Attachment.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Attachment(id: '', name: '', url: '', type: '', size: 0);
    }

    return Attachment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'url': url, 'type': type, 'size': size};
  }
}

class WorkFlow {
  final String id;
  final String approverId;
  final String? approver;
  final DateTime? approvalDate;
  final int? step;
  final int? status;
  final String? statusLabel;
  final String? jobTitle;
  final String? note;
  final DateTime? createdDate;
  final bool? isDeleted;
  final String? receiver;

  WorkFlow({
    required this.id,
    required this.approverId,
    this.approver,
    this.approvalDate,
    this.step,
    this.status,
    this.statusLabel,
    this.note,
    this.createdDate,
    this.isDeleted,
    this.receiver,
    this.jobTitle,
  });

  factory WorkFlow.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return WorkFlow(id: '', approverId: '', approver: '');
    }

    return WorkFlow(
      id: json['id']?.toString() ?? '',
      approverId: json['approverId']?.toString() ?? '',
      approver: json['approver']?.toString(),
      approvalDate:
          json['approvalDate'] != null
              ? DateTime.tryParse(json['approvalDate'].toString())
              : null,
      step: json['step'] as int?,
      status: json['status'] as int?,
      statusLabel:
          json['statusLabel'] == "Không xác định"
              ? ""
              : json['statusLabel']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      createdDate:
          json['createdDate'] != null
              ? DateTime.tryParse(json['createdDate'].toString())
              : null,
      isDeleted: json['isDeleted'] as bool?,
      receiver: json['receiver']?.toString() ?? '',
      jobTitle: json['jobTitle']?.toString() ?? '',
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
      'receiver': receiver,
    };
  }
}
