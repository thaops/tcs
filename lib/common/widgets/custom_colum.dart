import 'package:flutter/material.dart';

class CustomColum extends StatelessWidget {
  final List<Widget> children; // Cho phép nhiều Widget con
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final BoxShadow? boxShadow;
  final CrossAxisAlignment? crossAxisAlignment; // Căn chỉnh theo chiều ngang
  final MainAxisAlignment? mainAxisAlignment; // Căn chỉnh theo chiều dọc
  final double? height; // Chiều cao tùy chỉnh
  final double? width; // Chiều rộng tùy chỉnh

  const CustomColum({
    super.key,
    required this.children, // Nhiều widget con
    this.paddingVertical,
    this.paddingHorizontal,
    this.backgroundColor,
    this.borderRadius,
    this.boxShadow,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent, 
        borderRadius: borderRadius, 
        boxShadow: boxShadow != null ? [boxShadow!] : [], 
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? 0,
        vertical: paddingVertical ?? 0,
      ),
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start, 
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start, 
        children: children, // Nhiều widget con
      ),
    );
  }
}
