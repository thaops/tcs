class AddDayOffResponseModel {
  final int statusCode;
  final String message;
  final int totalRecord;
  final bool data;

  AddDayOffResponseModel({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory AddDayOffResponseModel.fromJson(Map<String, dynamic> json) {
    // Hỗ trợ cả key viết hoa/thường và ép kiểu an toàn
    final dynamic rawStatus = json['statusCode'] ?? json['StatusCode'] ?? 500;
    final int statusCode = rawStatus is int
        ? rawStatus
        : int.tryParse(rawStatus.toString()) ?? 500;

    final String message =
        (json['message'] ?? json['Message'] ?? '').toString();

    final dynamic rawTotal = json['totalRecord'] ?? json['TotalRecord'] ?? 0;
    final int totalRecord = rawTotal is int
        ? rawTotal
        : int.tryParse(rawTotal.toString()) ?? 0;

    final dynamic rawData = json['data'] ?? json['Data'];
    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is num) return v != 0;
      final s = v.toString().trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'success' || s == 'ok';
    }

    return AddDayOffResponseModel(
      statusCode: statusCode,
      message: message,
      totalRecord: totalRecord,
      data: toBool(rawData),
    );
  }
}
