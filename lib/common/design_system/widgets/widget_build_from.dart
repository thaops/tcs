import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tcs_flutter/common/widgets/custom_button.dart';
import 'package:tcs_flutter/common/widgets/task_date.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/widgets/buildH.dart';
import 'package:tcs_flutter/common/widgets/widgets/custom_mandays_buton.dart';

class WidgetBuildFrom {
  static Column buildEditRow(
      String? title, TextEditingController controllerText, bool? isUpdate,
      {bool? isDescription = false, String? error, bool? isCheckError = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? TextWidget(
                text: title,
                fontSize: 14.sp,
                maxLines: isDescription ?? false ? 4 : 1,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              )
            : Container(),
        title != null ? SizedBox(height: 8.h) : Container(),
        CustomTextField(
          minLines: isDescription ?? false ? 4 : 1,
          controller: controllerText,
          error: error,
          isEnabled: isUpdate ?? false,
          borderWidth: (isUpdate ?? false) ? 0.7 : 0.1,
          borderColor: AppColors.grey,
          isCheckError: isCheckError ?? false,
          onChanged: (value) {
            controllerText.text = value;
          },
          hintText: "",
        ),
      ],
    );
  }

  static Widget buildCustomCard(Widget childList,
      {String title = "", IconData icon = Icons.description_outlined, double padding = 16}) {
    return Column(
      children: [
        BuildH(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(title, icon),
              SizedBox(height: 8.h),
              childList,
            ],
          ),
        ),
      ],
    );
  }

  static Row _buildTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.primary,
        ),
        SizedBox(width: 8.w),
        TextWidget(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ],
    );
  }



  static Column buildFromDate(
      DateTime startDate,
      DateTime finishDate,
      bool isUpdate,
      Function(DateTime) onDateSelected,
      Function(DateTime) onDateSelectedFinish) {
    return Column(
      children: [
        TaskDate(
          colorIcon: AppColors.primary,
          icon: Icons.calendar_month,
          label: 'Ngày bắt đầu',
          selectedDate: startDate,
          onDateSelected: onDateSelected,
          isEnabled: isUpdate,
        ),
        TaskDate(
          colorIcon: AppColors.primary,
          icon: Icons.calendar_month,
          label: 'Ngày đến hạn',
          selectedDate: finishDate,
          onDateSelected: onDateSelectedFinish,
          isEnabled: isUpdate,
        ),
      ],
    );
  }

  static Padding buildButonAction(Function() onPressed,
      {int paddingHorizontal = 16}) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 20.h, horizontal: paddingHorizontal.w),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Cancel',
              color: AppColors.grey,
              textColor: AppColors.white,
              onPressed: () {
                Get.back(result: false);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomButton(
                text: 'Save',
                color: AppColors.primary,
                textColor: AppColors.white,
                onPressed: onPressed),
          ),
        ],
      ),
    );
  }
}
