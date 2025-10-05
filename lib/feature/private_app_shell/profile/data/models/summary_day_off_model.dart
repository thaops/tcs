class SummaryDayOffModel {
  final String id;
  final String fullName;
  final String employeeCode;
  final String departmentCode;
  final String departmentName;
  final num? quota;
  final num? leaveDaysLeft;

  SummaryDayOffModel({
    required this.id,
    required this.fullName,
    required this.employeeCode,
    required this.departmentCode,
    required this.departmentName,
    this.quota,
    this.leaveDaysLeft,
  });

  factory SummaryDayOffModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SummaryDayOffModel(
        id: '',
        fullName: '',
        employeeCode: '',
        departmentCode: '',
        departmentName: '',
        quota: 0,
        leaveDaysLeft: 0,
      );
    }

    return SummaryDayOffModel(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      departmentCode: json['departmentCode']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      quota: json['quota'] as num?,
      leaveDaysLeft: json['leaveDaysLeft'] as num?,
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

  factory SummaryDayOffApiResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SummaryDayOffApiResponse(
        statusCode: 0,
        message: '',
        totalRecord: 0,
        data: null,
      );
    }

    return SummaryDayOffApiResponse(
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message']?.toString() ?? '',
      totalRecord: json['totalRecord'] as int? ?? 0,
      data:
          json['data'] != null
              ? SummaryDayOffModel.fromJson(
                json['data'] as Map<String, dynamic>?,
              )
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
