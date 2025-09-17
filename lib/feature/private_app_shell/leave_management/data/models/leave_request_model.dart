import 'package:tcs_flutter/src/api/models/employee_model.dart';

class LeaveRequest {
  final String id;
  final String employeeId;
  final String fullName;
  final String departmentName;
  final String unitName;
  final String jobTitle;
  final DateTime createdDate;
  final DateTime fromDate;
  final DateTime toDate;
  final String category;
  final int totalDay;
  final String reason;
  final DateTime? approvedDate;
  final String status;
  final String statusName;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.departmentName,
    required this.unitName,
    required this.jobTitle,
    required this.createdDate,
    required this.fromDate,
    required this.toDate,
    required this.category,
    required this.totalDay,
    required this.reason,
    this.approvedDate,
    required this.status,
    required this.statusName,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    DateTime _safeParse(String? v) {
      if (v == null || v.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(v);
      } catch (_) {
        return DateTime.now();
      }
    }

    return LeaveRequest(
      id: json['id'] ?? '',
      employeeId: json['employeeId'] ?? '',
      fullName: json['fullName'] ?? '',
      departmentName: json['departmentName'] ?? '',
      unitName: json['unitName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      createdDate: _safeParse(json['createdDate']?.toString()),
      fromDate: _safeParse(json['fromDate']?.toString()),
      toDate: _safeParse(json['toDate']?.toString()),
      category: json['category'] ?? '',
      totalDay: json['totalDay'] ?? 0,
      reason: json['reason'] ?? '',
      approvedDate:
          json['approvedDate'] != null
              ? _safeParse(json['approvedDate']?.toString())
              : null,
      status: json['status'] ?? '',
      statusName: json['statusName'] ?? '',
    );
  }

  // Convert to Employee for backward compatibility
  Employee toEmployee() {
    return Employee(
      id: id,
      employeeCode: employeeId,
      fullName: fullName,
      departmentName: departmentName,
      unionName: unitName,
      dayOffs: [],
      // Legacy fields
      employeeId: employeeId,
      department: departmentName,
      fromDate: fromDate,
      toDate: toDate,
      totalDay: totalDay,
      category: category,
      status: int.tryParse(status) ?? 0,
      statusLabel: statusName,
      approvalDate: approvedDate,
      reason: reason,
      createdDate: createdDate,
    );
  }

  @override
  String toString() {
    return 'LeaveRequest{id: $id, employeeId: $employeeId, fullName: $fullName, '
        'departmentName: $departmentName, unitName: $unitName, jobTitle: $jobTitle, '
        'createdDate: $createdDate, fromDate: $fromDate, toDate: $toDate, '
        'category: $category, totalDay: $totalDay, reason: $reason, '
        'approvedDate: $approvedDate, status: $status, statusName: $statusName}';
  }
}
