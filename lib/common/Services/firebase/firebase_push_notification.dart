// lib/services/firebase_push_notification.dart
import 'package:dio/dio.dart';
import 'dio_client.dart';  // Đừng quên import DioClient

class FirebasePushNotification {
  final DioClient dioClient;

  FirebasePushNotification({required this.dioClient});

  // Gửi thông báo đến một thiết bị thông qua FCM Token
  Future<void> sendNotification(String fcmToken, String title, String body) async {
    // Dữ liệu thông báo
    Map<String, dynamic> notificationData = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': body,
      },
    };

    try {
      Response response = await dioClient.sendPushNotification(notificationData);
      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
