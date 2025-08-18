import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show(String message) {
    Get.snackbar(
      "Thống báo",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 145, 144, 144),
      colorText: Colors.white,
    );
  }
}