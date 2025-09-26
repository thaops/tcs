class MyAnnualLeaveModel {
  final String id;
  final String fullName;
  final String employeeCode;
  final String departmentCode;
  final String departmentName;
  final int annualQuota;
  final int registeredDays;
  final int unusedDays;
  final int jan;
  final int feb;
  final int mar;
  final int apr;
  final int may;
  final int jun;
  final int jul;
  final int aug;
  final int sep;
  final int oct;
  final int nov;
  final int dec;

  MyAnnualLeaveModel({
    required this.id,
    required this.fullName,
    required this.employeeCode,
    required this.departmentCode,
    required this.departmentName,
    required this.annualQuota,
    required this.registeredDays,
    required this.unusedDays,
    required this.jan,
    required this.feb,
    required this.mar,
    required this.apr,
    required this.may,
    required this.jun,
    required this.jul,
    required this.aug,
    required this.sep,
    required this.oct,
    required this.nov,
    required this.dec,
  });

  factory MyAnnualLeaveModel.fromJson(Map<String, dynamic> json) {
    return MyAnnualLeaveModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      departmentCode: json['departmentCode'] ?? '',
      departmentName: json['departmentName'] ?? '',
      annualQuota: json['annualQuota'] ?? 0,
      registeredDays: json['registeredDays'] ?? 0,
      unusedDays: json['unusedDays'] ?? 0,
      jan: json['jan'] ?? 0,
      feb: json['feb'] ?? 0,
      mar: json['mar'] ?? 0,
      apr: json['apr'] ?? 0,
      may: json['may'] ?? 0,
      jun: json['jun'] ?? 0,
      jul: json['jul'] ?? 0,
      aug: json['aug'] ?? 0,
      sep: json['sep'] ?? 0,
      oct: json['oct'] ?? 0,
      nov: json['nov'] ?? 0,
      dec: json['dec'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'employeeCode': employeeCode,
      'departmentCode': departmentCode,
      'departmentName': departmentName,
      'annualQuota': annualQuota,
      'registeredDays': registeredDays,
      'unusedDays': unusedDays,
      'jan': jan,
      'feb': feb,
      'mar': mar,
      'apr': apr,
      'may': may,
      'jun': jun,
      'jul': jul,
      'aug': aug,
      'sep': sep,
      'oct': oct,
      'nov': nov,
      'dec': dec,
    };
  }

  /// Lấy dữ liệu theo tháng
  int getMonthValue(int month) {
    switch (month) {
      case 1:
        return jan;
      case 2:
        return feb;
      case 3:
        return mar;
      case 4:
        return apr;
      case 5:
        return may;
      case 6:
        return jun;
      case 7:
        return jul;
      case 8:
        return aug;
      case 9:
        return sep;
      case 10:
        return oct;
      case 11:
        return nov;
      case 12:
        return dec;
      default:
        return 0;
    }
  }

  /// Cập nhật giá trị theo tháng
  MyAnnualLeaveModel copyWithMonthValue(int month, int value) {
    switch (month) {
      case 1:
        return copyWith(jan: value);
      case 2:
        return copyWith(feb: value);
      case 3:
        return copyWith(mar: value);
      case 4:
        return copyWith(apr: value);
      case 5:
        return copyWith(may: value);
      case 6:
        return copyWith(jun: value);
      case 7:
        return copyWith(jul: value);
      case 8:
        return copyWith(aug: value);
      case 9:
        return copyWith(sep: value);
      case 10:
        return copyWith(oct: value);
      case 11:
        return copyWith(nov: value);
      case 12:
        return copyWith(dec: value);
      default:
        return this;
    }
  }

  MyAnnualLeaveModel copyWith({
    String? id,
    String? fullName,
    String? employeeCode,
    String? departmentCode,
    String? departmentName,
    int? annualQuota,
    int? registeredDays,
    int? unusedDays,
    int? jan,
    int? feb,
    int? mar,
    int? apr,
    int? may,
    int? jun,
    int? jul,
    int? aug,
    int? sep,
    int? oct,
    int? nov,
    int? dec,
  }) {
    return MyAnnualLeaveModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      employeeCode: employeeCode ?? this.employeeCode,
      departmentCode: departmentCode ?? this.departmentCode,
      departmentName: departmentName ?? this.departmentName,
      annualQuota: annualQuota ?? this.annualQuota,
      registeredDays: registeredDays ?? this.registeredDays,
      unusedDays: unusedDays ?? this.unusedDays,
      jan: jan ?? this.jan,
      feb: feb ?? this.feb,
      mar: mar ?? this.mar,
      apr: apr ?? this.apr,
      may: may ?? this.may,
      jun: jun ?? this.jun,
      jul: jul ?? this.jul,
      aug: aug ?? this.aug,
      sep: sep ?? this.sep,
      oct: oct ?? this.oct,
      nov: nov ?? this.nov,
      dec: dec ?? this.dec,
    );
  }
}

class MyAnnualLeaveApiResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final MyAnnualLeaveModel? data;

  MyAnnualLeaveApiResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    this.data,
  });

  factory MyAnnualLeaveApiResponse.fromJson(Map<String, dynamic> json) {
    return MyAnnualLeaveApiResponse(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      totalRecord: json['totalRecord'] ?? 0,
      data:
          json['data'] != null
              ? MyAnnualLeaveModel.fromJson(json['data'])
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
