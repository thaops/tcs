import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/config.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class ShowDialogSetUrl {
   void showConfigDialog({required TextEditingController baseUrlController, required DioApi dioApi, required RxInt tapCount}) {
    if (tapCount.value == 5) {
      baseUrlController.text = Config.baseUrl;
      String initialBaseUrl = Config.baseUrl;
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Developer Settings",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                SizedBox(height: 16),
                TextField(
                  controller: baseUrlController,
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                  decoration: InputDecoration(
                    labelText: 'Base URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            tapCount.value = 0;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Cancel",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            String currentBaseUrl =
                                baseUrlController.text.trim();
                            if (currentBaseUrl != initialBaseUrl) {
                              Config.baseUrl = baseUrlController.text;
                              dioApi = DioApi();
                              Get.back();
                              tapCount.value = 0;
                              Get.snackbar('Success', 'Base URL updated');
                            } else {
                              Get.back();
                              Get.snackbar(
                                  'Info', 'No changes made to Base URL');
                              tapCount.value = 0;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Apply",
                              style: TextStyle(color: Colors.white)),
                        ),
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
}