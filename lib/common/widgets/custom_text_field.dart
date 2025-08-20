import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function()? onTap;
  final bool obscureText;
  final IconData? suffixIcon;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final double? width;
  final bool isMobile;
  final IconData? prefixIcon;
  final double? borderWidth;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final double? fontSize;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Color? colorIconSuffix;
  final Function()? onSuffixTap;
  final bool? isNumberic;
  String? error;
  final bool isCheckError;
  final Function()? onPrefixTap;
  final TextInputType? keyboardType;
  final bool? isEnabled;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool? autocorrect;
  final bool? enableSuggestions;
  final TextInputAction? textInputAction;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.onSubmit,
    this.focusNode,
    this.width,
    this.isMobile = false,
    this.prefixIcon,
    this.borderWidth,
    this.backgroundColor,
    this.borderRadius = 12,
    this.borderColor,
    this.fontSize,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.paddingVertical,
    this.paddingHorizontal,
    this.colorIconSuffix,
    this.onSuffixTap,
    this.isNumberic = false,
    this.onChanged,
    this.onPrefixTap,
    this.keyboardType,
    this.isEnabled = true,
    this.error,
    this.validator,
    this.isCheckError = false,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect,
    this.enableSuggestions,
    this.textInputAction,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  final ValueNotifier<String?> errorNotifier = ValueNotifier(null);


  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.paddingHorizontal ?? 0,
        vertical: widget.paddingVertical ?? 0,
      ),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        ),
        child: TextField(
          enabled: widget.isEnabled,
          focusNode: widget.focusNode,
          controller: widget.controller,
          autocorrect: widget.autocorrect ?? true,
          enableSuggestions: widget.enableSuggestions ?? true,
          autofocus: false,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines ?? widget.minLines ?? 1,
          keyboardType: widget.keyboardType ??
              (widget.isNumberic == true
                  ? TextInputType.number
                  : (((widget.maxLines ?? widget.minLines ?? 1) > 1)
                      ? TextInputType.multiline
                      : TextInputType.text)),
          textInputAction: widget.textInputAction ??
              (((widget.maxLines ?? widget.minLines ?? 1) > 1)
                  ? TextInputAction.newline
                  : TextInputAction.done),
          textCapitalization: widget.textCapitalization,
          inputFormatters: widget.isNumberic == true
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          style: TextStyle(
            fontSize: widget.fontSize ?? 16,
            fontWeight: FontWeight.w400,
            color: widget.isEnabled == true
                ? AppColors.black
                : Colors.grey.shade500,
          ),
          textAlignVertical: TextAlignVertical.center,
          onTap: widget.onTap,
          obscureText: _obscureText,
          onSubmitted: widget.onSubmit,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.isCheckError) {
              setState(() {
                if (widget.controller.text.isNotEmpty) {
                  widget.error = null;
                } else {
                  widget.error = widget.error;
                }
              });
            }
            if (widget.validator != null) {
              setState(() {
                widget.error = widget.validator!(widget.controller.text);
              });
            }
          },
          decoration: InputDecoration(
            filled: true,
            errorText: widget.error,
            errorStyle: TextStyle(
              color: Colors.redAccent,
              fontSize: 12.sp,
              textBaseline: TextBaseline.alphabetic,
            ),
            errorMaxLines: 2, // Cho phép hiển thị nhiều dòng nếu lỗi dài
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
            fillColor:
                widget.isEnabled == true ? Colors.white : Colors.grey.shade100,
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 12 : 24,
              vertical: widget.isMobile ? 12 : 12,
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: widget.fontSize ?? 16,
              fontWeight: FontWeight.w500,
              color: widget.isEnabled == true
                  ? Colors.grey.shade600
                  : Colors.grey.shade400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.grey,
                width: widget.borderWidth ?? 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.grey,
                width: widget.borderWidth ?? 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: widget.borderWidth ?? 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.primary,
                width: widget.borderWidth ?? 1.5,
              ),
            ),
            prefixIcon: widget.prefixIcon != null
                ? IconButton(
                    onPressed:
                        widget.isEnabled == true ? widget.onPrefixTap : null,
                    icon: Icon(
                      widget.prefixIcon,
                      size: 24,
                      color: widget.isEnabled == true
                          ? null
                          : Colors.grey.shade400,
                    ),
                  )
                : null,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: Icon(
                      _obscureText && widget.obscureText
                          ? Icons.visibility_off
                          : widget.suffixIcon,
                      size: 24,
                      color: widget.isEnabled == true
                          ? ((widget.controller.text.isEmpty &&
                                  widget.colorIconSuffix != null)
                              ? widget.colorIconSuffix
                              : AppColors.colorIcon)
                          : Colors.grey.shade400,
                    ),
                    onPressed: widget.isEnabled == true
                        ? (widget.onSuffixTap ??
                            (widget.obscureText
                                ? _togglePasswordVisibility
                                : null))
                        : null,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}