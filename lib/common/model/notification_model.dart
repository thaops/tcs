// lib/models/notification_model.dart

class NotificationModel {
  final String title;
  final String body;

  NotificationModel({required this.title, required this.body});

  // Phương thức để chuyển đổi thông báo thành JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}
