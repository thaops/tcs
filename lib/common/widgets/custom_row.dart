import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final List<Widget> children; // Cho phép nhiều Widget con
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;
  final MainAxisAlignment? mainAxisAlignment; // Căn chỉnh theo chiều ngang
  final CrossAxisAlignment? crossAxisAlignment; // Căn chỉnh theo chiều dọc
  final double? height; // Chiều cao tùy chỉnh
  final double? width; // Chiều rộng tùy chỉnh

  const CustomRow({
    super.key,
    required this.children, // Nhiều widget con
    this.paddingVertical,
    this.paddingHorizontal,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent, // Màu nền tùy chỉnh
        borderRadius: borderRadius, // Bo góc nếu cần
        boxShadow: boxShadow != null ? [boxShadow!] : [], // Shadow tùy chọn
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
        vertical: paddingVertical ?? 0,
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment ??
            MainAxisAlignment.start, // Căn chỉnh theo chiều ngang
        crossAxisAlignment: crossAxisAlignment ??
            CrossAxisAlignment.center, // Căn chỉnh theo chiều dọc
        children: children, // Nhiều widget con
      ),
    );
  }
}
