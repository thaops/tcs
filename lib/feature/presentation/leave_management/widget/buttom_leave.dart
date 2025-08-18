import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/logic/leave_careate_controller.dart';

class ButtomLeave extends StatelessWidget {
  const ButtomLeave({super.key});

  @override
  Widget build(BuildContext context) {
      final controllerCreate = Get.put(LeaveCareateController());

    return  Row(
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  Get.back();
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextWidget(
                      text: "Huỷ",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            20.horizontalSpace,
            Flexible(
              child: GestureDetector(
                onTap: () async {
                  await controllerCreate.save_create(context);
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextWidget(
                      text: "Tạo",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        
      
    );
  }
}