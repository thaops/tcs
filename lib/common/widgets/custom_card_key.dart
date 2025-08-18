import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';

/// Widget to measure size and call back when size changes
class MeasureSize extends StatefulWidget {
  final Widget child;
  final void Function(Size size) onChange;

  const MeasureSize({
    Key? key,
    required this.child,
    required this.onChange,
  }) : super(key: key);

  @override
  _MeasureSizeState createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final newSize = renderBox.size;
          if (_oldSize == null || _oldSize != newSize) {
            _oldSize = newSize;
            widget.onChange(newSize);
          }
        }
      });
      return widget.child;
    });
  }
}

/// CustomCard widget without using 
class CustomCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  final double? borderWidth;
  final double? radius;
  final double? paddingH;
  final double? paddingV;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double? width;
  // final double? height;
  final double? paddingB;
  final bool initiallyExpanded;

  const CustomCard({
    Key? key,
    required this.child,
    this.color,
    this.borderWidth,
    this.radius,
    this.paddingH,
    this.paddingV,
    this.borderColor,
    this.onTap,
    this.width,
    // this.height = 300.0,
    this.paddingB,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final RxBool isExpanded = false.obs;
  final RxDouble childHeight = 0.0.obs;

  @override
  void initState() {
    super.initState();
    isExpanded.value = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: widget.paddingB ?? AppSizes.paddingMedium.h,
        ),
        child: MeasureSize(
                  onChange: (size) {
                    childHeight.value = size.height;
                  },
                  child: Container(
                    // height: childHeight.value > widget.height! && !isExpanded.value
                    //     ? widget.height
                    //     : null,
                    // width: widget.width,
                    padding: EdgeInsets.symmetric(
                      vertical: widget.paddingV ?? AppSizes.paddingSmall.w,
                      horizontal: widget.paddingH ?? AppSizes.paddingSmall.w,
                    ),
                    decoration: BoxDecoration(
                      color: widget.color ?? AppColors.white,
                      borderRadius: BorderRadius.circular(
                        widget.radius ?? AppSizes.radiusMedium.r,
                      ),
                      border: Border.all(
                        color: widget.borderColor ?? AppColors.colorBacklog,
                        width: widget.borderWidth ?? AppSizes.cardBorderWidthSmall.w,
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ClipRect(child: widget.child),
                    ),
                  ),
                ),
                // if (childHeight.value > widget.height!)
                //   Positioned(
                //     bottom: -16.h,
                //     left: 0,
                //     right: 0,
                //     child: Container(
                //       height: 32.h,
                //       width: 32.w,
                //       alignment: Alignment.center,
                //       child: InkWell(
                //         onTap: () => isExpanded.toggle(),
                //         child: Container(
                //           height: 32.h,
                //           width: 32.w,
                //           decoration: BoxDecoration(
                //             color: widget.color ?? AppColors.white,
                //             shape: BoxShape.circle,
                //             border: Border.all(
                //               color: widget.borderColor ?? AppColors.colorBacklog,
                //               width: widget.borderWidth ?? AppSizes.cardBorderWidthSmall.w,
                //             ),
                //           ),
                //           child: Center(
                //             child: Icon(
                //               isExpanded.value
                //                   ? Icons.keyboard_arrow_up
                //                   : Icons.keyboard_arrow_down,
                //               color: AppColors.primary,
                //               size: 20.sp,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              
            ),
          
        
      
    );
  }
}