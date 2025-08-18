import 'package:flutter/material.dart';

class CustomStatus {
  String status(int statusCode) {
    switch (statusCode) {
      case 0:
        return "Đang Xử lý";
      case 1:
        return "Đã Hoàn Thành";
      case 2:
        return "Trễ hạn";
      default:
        return "Trạng thái không xác định";
    }
  }

  Color getStatusColor(String? statusLabel) {
    switch (statusLabel) {
      case 'Đang Xử lý':
        return Color.fromARGB(255, 158, 158, 4);
      case 'Đã Hoàn Thành':
        return Colors.green;
      case 'Trễ hạn':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
