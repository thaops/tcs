class SummaryDayOffModel {
  final String id;
  final String fullName;
  final String employeeCode;
  final String departmentCode;
  final String departmentName;
  final int quota;
  final int leaveDaysLeft;

  SummaryDayOffModel({
    required this.id,
    required this.fullName,
    required this.employeeCode,
    required this.departmentCode,
    required this.departmentName,
    required this.quota,
    required this.leaveDaysLeft,
  });

  factory SummaryDayOffModel.fromJson(Map<String, dynamic> json) {
    return SummaryDayOffModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      departmentCode: json['departmentCode'] ?? '',
      departmentName: json['departmentName'] ?? '',
      quota: json['quota'] ?? 0,
      leaveDaysLeft: json['leaveDaysLeft'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'employeeCode': employeeCode,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'quota': quota,
      'leaveDaysLeft': leaveDaysLeft,
    };
  }
}

class SummaryDayOffApiResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final SummaryDayOffModel? data;

  SummaryDayOffApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data,
  });

  factory SummaryDayOffApiResponse.fromJson(Map<String, dynamic> json) {
    return SummaryDayOffApiResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data:
          json['data'] != null
              ? SummaryDayOffModel.fromJson(json['data'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'totalRecord': totalRecord,
      'data': data?.toJson(),
    };
  }
}
