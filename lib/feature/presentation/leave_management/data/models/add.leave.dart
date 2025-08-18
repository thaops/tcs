class AddDayOffResponseModel {
  final int statusCode;
  final String message;
  final int totalRecord;
  final dynamic data;  // Để 'dynamic' nếu dữ liệu có thể thay đổi kiểu

  AddDayOffResponseModel({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory AddDayOffResponseModel.fromJson(Map<String, dynamic> json) {
    return AddDayOffResponseModel(
      statusCode: json['statusCode'] ?? 500,
      message: json['message'] ?? 'Unknown error',
      totalRecord: json['totalRecord'] ?? 0,
      data: json['data'] ?? true,  // Đảm bảo 'data' không null, nếu null, trả về true
    );
  }
}
