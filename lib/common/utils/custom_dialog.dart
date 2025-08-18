import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomDialog {
  Future<bool?> showConfirmationDialog({dynamic data, Widget? child, String? yes = "Có", String? no = "Hủy"}) {
    return Get.dialog<bool>(
      Dialog( 
        child: Container(
          width: MediaQuery.of(Get.context!).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: EdgeInsets.all(20), // Padding cho nội dung
          child: Column(
            mainAxisSize: MainAxisSize.min, // Để chiều cao tự động điều chỉnh
            children: [
              child ?? Container(),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: no.toString(),
                      color: AppColors.grey.withOpacity(0.2),
                      borderColor: Colors.transparent,
                      textColor: AppColors.black,
                      onPressed: () {
                        Get.back(result: false);
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa hai nút
                  Expanded(
                    child: CustomButton(
                      text: yes.toString(),
                      color: AppColors.primary,
                      textColor: AppColors.white,
                      onPressed: (data == null ||
                              (data != null && data.isNotEmpty))
                          ? () {
                              Get.back(result: true);
                            }
                          : () => Get.snackbar(
                              "Thông báo", "Vui lòng đợi 3 giây rồi thử lại"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
