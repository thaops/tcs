import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildH extends StatelessWidget {
  final Color? color;
  const BuildH({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        color: color ?? Colors.grey.shade300,
        height: 12.h,
      ),
    );
  }
}
