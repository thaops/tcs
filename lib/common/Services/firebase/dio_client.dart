// lib/services/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  Dio _dio;

  DioClient()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/send',
          headers: {
            'Content-Type': 'application/json',
            // Thêm header Authorization với Server Key của bạn
            'Authorization': 'key=fnhIiqDjRMClzii_wJIptV:APA91bGlO-uUhf2kHJGyixambwjclTrHGvT7utJYi_dtJ4YzmQk_BzQwHAqp4USJK6mC_z9qTuOgWqhq6fySjY548hbjIui1m9Snw7fOimACNC97ItWHIXI',  // Thay YOUR_SERVER_KEY bằng Server Key của bạn
          },
        ));

  // Gửi yêu cầu POST đến FCM API
  Future<Response> sendPushNotification(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('', data: payload);
      return response;
    } catch (e) {
      throw Exception('Error sending push notification: $e');
    }
  }
}
