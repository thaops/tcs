import 'package:tcs_flutter/src/api/models/employee_model.dart';

class LeaveRequest {
  final String id;
  final String? employeeId;
  final String? fullName;
  final String? departmentName;
  final String? unitName;
  final String? jobTitle;
  final DateTime? createdDate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? category;
  final num? totalDay;
  final String? reason;
  final DateTime? approvedDate;
  final String? status;
  final String? statusName;

  LeaveRequest({
    required this.id,
    this.employeeId,
    this.fullName,
    this.departmentName,
    this.unitName,
    this.jobTitle,
    this.createdDate,
    this.fromDate,
    this.toDate,
    this.category,
    this.totalDay,
    this.reason,
    this.approvedDate,
    this.status,
    this.statusName,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    DateTime _safeParse(String? v) {
      if (v == null || v.isEmpty) return DateTime.now();
      try {
        // Handle different date formats
        if (v.contains('T')) {
          // ISO format with time
          return DateTime.parse(v);
        } else if (v.contains('/')) {
          // DD/MM/YYYY format
          final parts = v.split('/');
          if (parts.length == 3) {
            return DateTime(
              int.parse(parts[2]),
              int.parse(parts[1]),
              int.parse(parts[0]),
            );
          }
        } else if (v.contains('-')) {
          // YYYY-MM-DD format
          return DateTime.parse(v);
        }
        return DateTime.parse(v);
      } catch (e) {
        return DateTime.now();
      }
    }

    try {
      return LeaveRequest(
        id: json['id']?.toString() ?? '',
        employeeId: json['employeeId']?.toString() ?? '',
        fullName: json['fullName']?.toString() ?? '',
        departmentName: json['departmentName']?.toString() ?? '',
        unitName: json['unitName']?.toString() ?? '',
        jobTitle: json['jobTitle']?.toString() ?? '',
        createdDate: _safeParse(json['createdDate']?.toString()),
        fromDate: _safeParse(json['fromDate']?.toString()),
        toDate: _safeParse(json['toDate']?.toString()),
        category: json['category']?.toString() ?? '',
        totalDay:
            json['totalDay'] is num
                ? json['totalDay']
                : num.tryParse(json['totalDay']?.toString() ?? '0') ?? 0,
        reason: json['reason']?.toString() ?? '',
        approvedDate:
            json['approvedDate'] != null
                ? _safeParse(json['approvedDate']?.toString())
                : null,
        status: json['status']?.toString() ?? '',
        statusName: json['statusName']?.toString() ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Convert to Employee for backward compatibility
  Employee toEmployee() {
    return Employee(
      id: id,
      employeeCode: employeeId ?? '',
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
      status: int.tryParse(status ?? '') ?? 0,
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
