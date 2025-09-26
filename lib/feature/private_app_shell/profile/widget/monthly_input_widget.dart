import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/my_annual_leave_logic.dart';
import 'package:tcs_flutter/common/widgets/enhanced_text_widget.dart';

class MonthlyInputWidget extends StatelessWidget {
  final String month;
  final MyAnnualLeaveLogic logic;

  const MonthlyInputWidget({Key? key, required this.month, required this.logic})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isEditMode = logic.isEditMode.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.labelLarge(
            'Tháng $month',
            color: isEditMode ? Colors.black87 : Colors.grey.shade700,
          ),
          SizedBox(height: 8.h),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isEditMode ? 1.0 : 0.7,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: logic.monthlyControllers[month],
                enabled: isEditMode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: isEditMode ? Colors.black87 : Colors.grey.shade600,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    color:
                        isEditMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color:
                          isEditMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color:
                          isEditMode
                              ? Colors.grey.shade300
                              : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: isEditMode ? Colors.white : Colors.grey.shade200,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
                onChanged:
                    isEditMode
                        ? (value) => logic.updateMonthlyValue(month, value)
                        : null,
              ),
            ),
          ),
        ],
      );
    });
  }
}
