import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final double? paddingVertical;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final TextAlign? textAlign;
  final double? paddingHorizontal;
  final String? fontFamily;
  final int? maxLines;
  final int? minLines;
  TextWidget({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.black,
    this.textAlign = TextAlign.left,
    this.paddingHorizontal,
    this.paddingVertical,
    this.minLines = 1,
    this.fontStyle,
    this.maxLines = 1,
    this.fontFamily = 'Roboto',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
        vertical: paddingVertical ?? 0,
      ),
      child: Text(
        text.toString(),
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
          overflow: TextOverflow.ellipsis,
          fontStyle: fontStyle,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
