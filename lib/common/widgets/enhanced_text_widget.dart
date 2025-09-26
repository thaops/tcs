import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Enhanced TextWidget với fonts đẹp hơn
class EnhancedTextWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? lineHeight;
  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final bool useGoogleFonts;

  const EnhancedTextWidget({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.lineHeight,
    this.decoration,
    this.fontStyle,
    this.fontFamily,
    this.useGoogleFonts = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Chọn font family
    String? selectedFontFamily;
    if (fontFamily != null) {
      selectedFontFamily = fontFamily;
    } else if (useGoogleFonts) {
      // Sử dụng Google Fonts với font đẹp
      selectedFontFamily = GoogleFonts.inter().fontFamily;
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize?.sp,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: lineHeight,
        decoration: decoration,
        fontStyle: fontStyle,
        fontFamily: selectedFontFamily,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Predefined text styles cho các trường hợp sử dụng phổ biến
class AppTextStyles {
  // Headers
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
  );

  static TextStyle get h3 =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get h4 =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500);

  // Body text
  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);

  static TextStyle get bodySmall =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.3);

  // Labels
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Buttons
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Overline
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
  );
}

/// Widget cho các trường hợp sử dụng cụ thể
class AppText {
  static Widget h1(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.h1.copyWith(color: color));

  static Widget h2(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.h2.copyWith(color: color));

  static Widget h3(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.h3.copyWith(color: color));

  static Widget h4(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.h4.copyWith(color: color));

  static Widget bodyLarge(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.bodyLarge.copyWith(color: color));

  static Widget bodyMedium(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.bodyMedium.copyWith(color: color));

  static Widget bodySmall(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.bodySmall.copyWith(color: color));

  static Widget labelLarge(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.labelLarge.copyWith(color: color));

  static Widget labelMedium(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.labelMedium.copyWith(color: color));

  static Widget labelSmall(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.labelSmall.copyWith(color: color));

  static Widget buttonLarge(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.buttonLarge.copyWith(color: color));

  static Widget buttonMedium(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.buttonMedium.copyWith(color: color));

  static Widget buttonSmall(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.buttonSmall.copyWith(color: color));

  static Widget caption(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.caption.copyWith(color: color));

  static Widget overline(String text, {Color? color}) =>
      Text(text, style: AppTextStyles.overline.copyWith(color: color));
}
