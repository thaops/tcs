import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomMandaysButton extends StatelessWidget {
  final String title;
  final bool? isDisabled;
  final RxDouble value;
  final double? borderRadius;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? height;
  final double? space;

  const CustomMandaysButton({
    Key? key,
    required this.title,
     this.isDisabled = false,
    required this.value,
    this.borderRadius = 24.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.height = 45.0,
    this.space = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment!,
      children: [
        TextWidget(
          text: title,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        SizedBox(height: space!),
        Container(
          height: height!,
          decoration: BoxDecoration(
            color: isDisabled! ? Colors.grey[200] : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius!),
            border: Border.all(color: Colors.grey[400]!, width: 0.5),
            boxShadow: isDisabled!
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Expanded(
                    child: isDisabled! ? Container() : IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 16.r,
                          color: isDisabled! ? Colors.grey : Colors.black87,
                        ),
                        onPressed: isDisabled!
                            ? null
                            : () {
                                if (value.value > 0) value.value -= 0.5;
                              },
                      ),
                  ),
                    Expanded(
                      child: TextWidget(
                          text: value.value.toString(),
                          fontSize: 12.sp,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                          color: isDisabled! ? Colors.grey : Colors.black87,
                        ),
                      
                    ),
                    Expanded(
                      child: isDisabled! ? Container() : IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 16.r,
                          color: isDisabled! ? Colors.grey : Colors.black87,
                        ),
                        onPressed: isDisabled!
                            ? null
                            : () {
                                value.value += 0.5;
                              },
                      ),
                    ),
                  ])),
        ),
      ],
    );
  }
}
