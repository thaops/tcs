class DeparmentModel {
  final int id;
  final String employeeCode;
  final String employeeName;
  final String employeeEmail;
  final String departmentCode;
  final String departmentName;
  final bool acceptUpdate;
  final String accountId;

  DeparmentModel({
    required this.id,
    required this.employeeCode,
    required this.employeeName,
    required this.employeeEmail,
    required this.departmentCode,
    required this.departmentName,
    required this.acceptUpdate,
    required this.accountId,
  });

  factory DeparmentModel.fromJson(Map<String, dynamic> json) {
    return DeparmentModel(
      id: json['id'] ?? 0,
      employeeCode: json['employeeCode'] ?? '',
      employeeName: json['employeeName'] ?? '',
      employeeEmail: json['employeeEmail'] ?? '',
      departmentCode: json['departmentCode'] ?? '',
      departmentName: json['departmentName'] ?? '',
      acceptUpdate: json['acceptUpdate'] ?? false,
      accountId: json['accountId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'employeeEmail': employeeEmail,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'acceptUpdate': acceptUpdate,
      'accountId': accountId,
    };
  }
}
