import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/widgets/enhanced_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class SummaryUserProfile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color? color;
  const SummaryUserProfile({super.key, this.title, this.subtitle, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Img.copy, fit: BoxFit.cover),
                    10.horizontalSpace,
                    AppText.bodyMedium(
                      title ?? '',
                      color: AppColors.darkGrey.withOpacity(0.9),
                    ),
                  ],
                ),

                16.horizontalSpace,
                Expanded(
                  flex: 2,
                  child: AppText.bodyMedium(
                    subtitle ?? '',
                    color: color ?? Colors.black,
                  ),
                ),
              ],
            ),
            8.verticalSpace,
            Divider(),
          ],
        ),
      ),
    );
  }
}
