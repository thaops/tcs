import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';

extension WidgetExtensions on Widget {
  /* =========== Padding =========== */
  Widget p(double value) => Padding(
    padding: EdgeInsets.all(value.w),
    child: this,
  );

  Widget px(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value.w),
    child: this,
  );

  Widget py(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value.h),
    child: this,
  );

  Widget pt(double value) => Padding(
    padding: EdgeInsets.only(top: value.h),
    child: this,
  );

  Widget pb(double value) => Padding(
    padding: EdgeInsets.only(bottom: value.h),
    child: this,
  );

  Widget pl(double value) => Padding(
    padding: EdgeInsets.only(left: value.w),
    child: this,
  );

  Widget pr(double value) => Padding(
    padding: EdgeInsets.only(right: value.w),
    child: this,
  );

  // Preset padding từ AppSizes
  Widget get pXSmall => p(AppSizes.paddingXSmall);
  Widget get pSmall => p(AppSizes.paddingSmall);
  Widget get pMedium => p(AppSizes.paddingMedium);
  Widget get pLarge => p(AppSizes.paddingLarge);

  /* =========== Margin =========== */
  Widget m(double value) => Container(
    margin: EdgeInsets.all(value.w),
    child: this,
  );

  Widget mx(double value) => Container(
    margin: EdgeInsets.symmetric(horizontal: value.w),
    child: this,
  );

  Widget my(double value) => Container(
    margin: EdgeInsets.symmetric(vertical: value.h),
    child: this,
  );

  Widget mt(double value) => Container(
    margin: EdgeInsets.only(top: value.h),
    child: this,
  );

  Widget mb(double value) => Container(
    margin: EdgeInsets.only(bottom: value.h),
    child: this,
  );

  Widget ml(double value) => Container(
    margin: EdgeInsets.only(left: value.w),
    child: this,
  );

  Widget mr(double value) => Container(
    margin: EdgeInsets.only(right: value.w),
    child: this,
  );

  // Preset margin từ AppSizes
  Widget get mXSmall => m(AppSizes.marginXSmall);
  Widget get mSmall => m(AppSizes.marginSmall);
  Widget get mMedium => m(AppSizes.marginMedium);
  Widget get mLarge => m(AppSizes.marginLarge);

  /* =========== Alignment =========== */
  Widget align(AlignmentGeometry alignment) => Align(
    alignment: alignment,
    child: this,
  );

  Widget get alignTopLeft => align(Alignment.topLeft);
  Widget get alignTopCenter => align(Alignment.topCenter);
  Widget get alignTopRight => align(Alignment.topRight);
  Widget get alignCenterLeft => align(Alignment.centerLeft);
  Widget get alignCenter => align(Alignment.center);
  Widget get alignCenterRight => align(Alignment.centerRight);
  Widget get alignBottomLeft => align(Alignment.bottomLeft);
  Widget get alignBottomCenter => align(Alignment.bottomCenter);
  Widget get alignBottomRight => align(Alignment.bottomRight);

  /* =========== Gesture =========== */
  Widget onTap(VoidCallback action, {bool opaque = true}) => GestureDetector(
    behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
    onTap: action,
    child: this,
  );

  Widget onDoubleTap(VoidCallback action) => GestureDetector(
    onDoubleTap: action,
    child: this,
  );

  Widget onLongPress(VoidCallback action) => GestureDetector(
    onLongPress: action,
    child: this,
  );

  /* =========== Visibility =========== */
  Widget visible(bool visible, {bool maintainState = false}) => Visibility(
    visible: visible,
    maintainState: maintainState,
    child: this,
  );

  Widget get gone => Visibility(
    visible: false,
    child: this,
  );

  Widget get invisible => Opacity(
    opacity: 0,
    child: this,
  );

  /* =========== Sizing =========== */
  Widget size({double? width, double? height}) => SizedBox(
    width: width?.w,
    height: height?.h,
    child: this,
  );

  Widget width(double width) => SizedBox(
    width: width.w,
    child: this,
  );

  Widget height(double height) => SizedBox(
    height: height.h,
    child: this,
  );

  Widget expand([int flex = 1]) => Expanded(
    flex: flex,
    child: this,
  );

  Widget flexible([int flex = 1, FlexFit fit = FlexFit.loose]) => Flexible(
    flex: flex,
    fit: fit,
    child: this,
  );

  /* =========== Decoration =========== */
  Widget decorated(Decoration decoration) => DecoratedBox(
    decoration: decoration,
    child: this,
  );

  Widget backgroundColor(Color color) => DecoratedBox(
    decoration: BoxDecoration(color: color),
    child: this,
  );

  /* =========== Transformation =========== */
  Widget rotate(double angle) => Transform.rotate(
    angle: angle,
    child: this,
  );

  Widget scale(double scale) => Transform.scale(
    scale: scale,
    child: this,
  );

  Widget translate({double x = 0, double y = 0}) => Transform.translate(
    offset: Offset(x.w, y.h),
    child: this,
  );

  /* =========== Advanced =========== */
  Widget clipRRect(double radius) => ClipRRect(
    borderRadius: BorderRadius.circular(radius.r),
    child: this,
  );

  Widget clipOval() => ClipOval(child: this);

  Widget hero({required String tag}) => Hero(
    tag: tag,
    child: this,
  );
}