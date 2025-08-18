// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:npp/common/utils/custom_color.dart';

// class CustomStatusItem extends StatelessWidget {
//   const CustomStatusItem({super.key, required this.status});

//   final String status;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20.r),
//         border: Border.all(
//           color: CustomColor().getColorLower(status).withValues(alpha: 0.6),
//           width: 1.w,
//         ),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: CustomColor().getColorLower(status),
//           fontSize: 12.sp,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
