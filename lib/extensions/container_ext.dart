import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';

extension ContainerExtensions on Container {
  Container _copyWith({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Widget? child,
    double? width,
    double? height,
  }) {
    return Container(
      key: key ?? this.key,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      color: decoration != null ? null : color ?? this.color,
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      constraints: constraints ?? this.constraints,
      margin: margin ?? this.margin,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      width: width ??
          (constraints?.maxWidth != double.infinity
              ? constraints?.maxWidth
              : null),
      height: height ??
          (constraints?.maxHeight != double.infinity
              ? constraints?.maxHeight
              : null),
      child: child ?? this.child,
    );
  }

  BoxDecoration _getEffectiveDecoration() {
    return (decoration is BoxDecoration)
        ? (decoration as BoxDecoration)
        : BoxDecoration(color: color);
  }

  /* ----------- Kích thước ----------- */
  Container withSize(double width, double height) => _copyWith(
        constraints: BoxConstraints.tightFor(width: width, height: height),
      );

  Container get smallSize => withSize(
        AppSizes.containerWidthSmall,
        AppSizes.containerHeightSmall,
      );

  Container get mediumSize => withSize(
        AppSizes.containerWidthMedium,
        AppSizes.containerHeightMedium,
      );

  Container get largeSize => withSize(
        AppSizes.containerWidthLarge,
        AppSizes.containerHeightLarge,
      );

  /* ----------- Border Radius ----------- */
  Container rounded(double radius) => _copyWith(
        decoration: _getEffectiveDecoration().copyWith(
          borderRadius: BorderRadius.circular(radius.r),
        ),
      );

  Container get roundedXSmall => rounded(AppSizes.radiusXSmall);
  Container get roundedSmall => rounded(AppSizes.radiusSmall);
  Container get roundedMedium => rounded(AppSizes.radiusMedium);
  Container get roundedLarge => rounded(AppSizes.radiusLarge);
  Container get roundedXLarge => rounded(AppSizes.radiusXLarge);
  Container get roundedXXLarge => rounded(AppSizes.radiusXXLarge);

  /* ----------- Shadow ----------- */
  Container shadow({
    Color color = Colors.black12,
    double blurRadius = 4.0,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
  }) {
    final effectiveDecoration = _getEffectiveDecoration();
    return _copyWith(
      decoration: effectiveDecoration.copyWith(
        boxShadow: [
          ...?effectiveDecoration.boxShadow,
          BoxShadow(
            color: color,
            blurRadius: blurRadius.w,
            offset: offset,
            spreadRadius: spreadRadius.w,
          ),
        ],
      ),
    );
  }

  Container get shadowSmall => shadow(blurRadius: AppSizes.shadowSmall);
  Container get shadowMedium => shadow(blurRadius: AppSizes.shadowMedium);
  Container get shadowLarge => shadow(blurRadius: AppSizes.shadowLarge);

  /* ----------- Border ----------- */
  Container withBorder({
    Color color = Colors.black,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    final effectiveDecoration = _getEffectiveDecoration();
    return _copyWith(
      decoration: effectiveDecoration.copyWith(
        border: Border.all(
          color: color,
          width: width.w,
          style: style,
        ),
      ),
    );
  }

  Container get borderXSmall => withBorder(width: AppSizes.borderWidthXSmall);
  Container get borderSmall => withBorder(width: AppSizes.borderWidthSmall);
  Container get borderMedium => withBorder(width: AppSizes.borderWidthMedium);
  Container get borderLarge => withBorder(width: AppSizes.borderWidthLarge);

  /* ----------- Màu sắc & Gradient ----------- */
  Container withColor(Color color) => _copyWith(
        color: color,
        decoration: null,
      );

  Container withGradient(Gradient gradient) => _copyWith(
        decoration: _getEffectiveDecoration().copyWith(
          gradient: gradient,
          color: null,
        ),
      );

  /* ----------- Padding & Margin ----------- */
  Container withPadding(EdgeInsetsGeometry padding) =>
      _copyWith(padding: padding);
  Container withMargin(EdgeInsetsGeometry margin) => _copyWith(margin: margin);

  Container get paddingXSmall =>
      withPadding(EdgeInsets.all(AppSizes.paddingXSmall));
  Container get paddingSmall =>
      withPadding(EdgeInsets.all(AppSizes.paddingSmall));
  Container get paddingMedium =>
      withPadding(EdgeInsets.all(AppSizes.paddingMedium));
  Container get paddingLarge =>
      withPadding(EdgeInsets.all(AppSizes.paddingLarge));

  Container get marginXSmall =>
      withMargin(EdgeInsets.all(AppSizes.marginXSmall));
  Container get marginSmall => withMargin(EdgeInsets.all(AppSizes.marginSmall));
  Container get marginMedium =>
      withMargin(EdgeInsets.all(AppSizes.marginMedium));
  Container get marginLarge => withMargin(EdgeInsets.all(AppSizes.marginLarge));

  /* ----------- Layout ----------- */
  Container withAlignment(AlignmentGeometry alignment) =>
      _copyWith(alignment: alignment);
  Container get center => withAlignment(Alignment.center);
}

extension ContainerPresetExt on Container {
  Container withGreyBoxStyle() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingXSmall.w,
          horizontal: AppSizes.paddingSmall.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: child,
    );
  }
}
