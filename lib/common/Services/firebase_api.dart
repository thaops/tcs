// // lib/common/Services/firebase_api.dart
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseApi {
//   final _fireBaseMessaging = FirebaseMessaging.instance;

//   // Yêu cầu quyền và lấy FCM token
//   Future<String?> initNotifications() async {
//     try {
//       await _fireBaseMessaging.requestPermission();
//       final fcmToken = await _fireBaseMessaging.getToken();
//       print(fcmToken); // In ra FCM token để kiểm tra

//       return fcmToken;  // Trả về token để sử dụng ở nơi khác
//     } catch (e) {
//       print('Error initializing FCM: $e');
//       return null;  // Nếu có lỗi, trả về null
//     }
//   }
// }
