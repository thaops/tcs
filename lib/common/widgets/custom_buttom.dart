import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomButtom extends StatelessWidget {
  final String? text;
  final Color? colorText;
  final Color? colorBackground;
  final double? boderRadius;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final bool isLoading;
  final Function()? onTap;
  const CustomButtom(
      {super.key,
      this.text,
      this.colorBackground,
      this.colorText,
      this.boderRadius,
      this.isLoading = false,
      this.onTap,
      this.paddingHorizontal,
      this.paddingVertical});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0, vertical: paddingVertical ?? 0),
      child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14),
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(boderRadius ?? 12),
              color: colorBackground ?? AppColors.primary,
              border: Border.all(color: colorText ?? AppColors.white, width: 1),
            ),
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: AppColors.white,
                    )
                  : TextWidget(
                      text: text ?? '',
                      color: colorText ?? AppColors.white,
                    ),
            ),
          )),
    );
  }
}
