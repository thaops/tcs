import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ValidateTextfield extends StatelessWidget {
  final String? title;
  final TextEditingController? controller;
  final String? hint;
  final int? minLines;
  final double? paddingVertical;
  final bool? isNumberic;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final bool isRequiredOnChanged;
  final Function()? onSuffixTap;
  final IconData? suffixIcon;

  final RxnString? error;
  final bool isCheckError;
  final String? Function(String?)? validator;

  ValidateTextfield({
    super.key,
    this.title,
    this.controller,
    this.hint,
    this.minLines,
    this.paddingVertical,
    this.isNumberic,
    this.keyboardType,
    this.error,
    this.validator,
    this.onChanged,
    this.isRequiredOnChanged = false,
    this.isCheckError = false,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title ?? '',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          8.verticalSpace,
          Obx(() => CustomTextField(
                borderRadius: 12,
                controller: controller ?? TextEditingController(),
                hintText: hint ?? '',
                minLines: minLines ?? 1,
                isNumberic: isNumberic ?? false,
                suffixIcon: suffixIcon,
                onSuffixTap: onSuffixTap,
                keyboardType: keyboardType,
                error: error?.value,
                isCheckError: isCheckError,
                onChanged: (val) {
                  if (validator != null && error != null) {
                    error!.value = validator!(val);
                  }
                  else if (isRequiredOnChanged && error != null) {
                    error!.value =
                        val.trim().isEmpty ? 'Không được để trống' : null;
                  }
                  onChanged?.call(val);
                },
              )),
        ],
      ),
    );
  }
}
