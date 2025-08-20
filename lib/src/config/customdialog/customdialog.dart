import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';

class CustomDialog {
  static Future<void> show(
    BuildContext context, {
    required String message,
    String? subMessage,
    IconData? icon = Icons.pets,
    Color? iconColor = Colors.orangeAccent,
    Color? messageColor = Colors.greenAccent,
    Color? backgroundColor = Colors.white,
    Duration? duration = const Duration(seconds: 1),
  }) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor, // Màu nền của AlertDialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Bo góc AlertDialog
          ),
          content: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: duration ?? Duration(seconds: 1),
            builder: (context, double opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Giới hạn chiều dài của AlertDialog
                  children: [
                    // Hình ảnh con vật hoặc biểu tượng
                    // Lottie.network(
                    //   'https://lottie.host/884d1114-1e8c-4a9b-95e1-741e4c6393de/JvDkxroilL.json',
                    //   width: 200, // Adjust width as needed
                    //   height: 200, // Adjust height as needed
                    //   fit: BoxFit.cover, // Adjust fit as needed
                    // ),
                    Lottie.asset(
                      Img.animation_approve,
                      width: 200, // Adjust width as needed
                      height: 200, // Adjust height as needed
                      fit: BoxFit.cover, // Adjust fit as needed
                    ),
                    SizedBox(height: 20), // Khoảng cách giữa icon và thông báo
                    // Thông báo chính
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24, // Kích thước chữ
                        fontWeight: FontWeight.bold,
                        color:
                            messageColor ?? Colors.greenAccent, // Màu chữ động
                        letterSpacing: 1.2, // Khoảng cách giữa các chữ
                      ),
                    ),
                    SizedBox(
                        height:
                            15), // Khoảng cách cuối cùng trước khi đóng hộp thoại
                    // Thêm một hiệu ứng bóng đổ nhẹ cho biểu tượng và chữ
                    if (subMessage != null)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Text(
                          subMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
