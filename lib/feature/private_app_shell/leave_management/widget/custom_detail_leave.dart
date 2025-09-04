import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomDetailLeave extends StatelessWidget {
  final String? title;
  final String? content;
  final bool? isShowicon;
  final double? paddingVertical;
  final Color? colorText;
  const CustomDetailLeave({
    super.key,
    this.content,
    this.title,
    this.isShowicon = true,
    this.paddingVertical,
    this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(height: 6.h),
                  isShowicon == true
                      ? Image.asset(Img.copy, fit: BoxFit.cover)
                      : Container(),
                ],
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSizes.spacingXSmall,
                  children: [
                    TextWidget(
                      text: title ?? '',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGrey.withOpacity(0.9),
                    ),
                    TextWidget(
                      paddingVertical: 2.h,
                      text: content.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      maxLines: 8,
                      color: colorText ?? AppColors.darkGrey.withOpacity(0.9),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
