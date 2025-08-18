// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:npp/common/design_system/tokens/app_sizes.dart';
// import 'package:npp/common/widgets/text_widget.dart';
// import 'package:npp/core/configs/theme/app_colors.dart';
// import 'package:npp/feature/presentation/report/model/item_role_model.dart';

// class WidgetBuildUtils {
//   static Widget buildCustomCard(
//       {required Widget child,
//       Color? color,
//       double? borderWidth,
//       double? radius,
//       double? paddingH,
//       double? paddingV,
//       Color? boderColor,
//       Function? onTap,
//       double? width,
//       double? paddingB}) {
//     return InkWell(
//       onTap: onTap as void Function()?,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: paddingB ?? AppSizes.paddingMedium.h),
//         child: Container(
//           width: width,
//           padding: EdgeInsets.symmetric(
//               vertical: paddingV ?? AppSizes.paddingSmall.w,
//               horizontal: paddingH ?? AppSizes.paddingSmall.w),
//           decoration: BoxDecoration(
//             color: color ?? AppColors.white,
//             borderRadius:
//                 BorderRadius.circular(radius ?? AppSizes.radiusMedium.r),
//             border: Border.all(
//                 color: boderColor ?? AppColors.colorBacklog,
//                 width: borderWidth ?? AppSizes.cardBorderWidthSmall.w),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }

//   static Widget buildCustomCardElevation(
//       {required Widget child,
//       Color? color,
//       double? borderWidth,
//       double? radius,
//       double? paddingH,
//       double? paddingV,
//       Color? boderColor,
//       Function? onTap,
//       double? width,
//       double? paddingB}) {
//     return InkWell(
//       onTap: onTap as void Function()?,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: paddingB ?? AppSizes.paddingMedium.h),
//         child: SizedBox(
//           width: width,
//           child: Card(
//             elevation: 1,
//             color: color ?? AppColors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius:
//                   BorderRadius.circular(radius ?? AppSizes.radiusMedium.r),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   vertical: paddingV ?? AppSizes.paddingSmall.w,
//                   horizontal: paddingH ?? AppSizes.paddingSmall.w),
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget buildChillRow(String title, IconData icon, Color color,
//           {double? size, double? paddingB, double? padingL}) =>
//       Padding(
//         padding: EdgeInsets.only(bottom: paddingB ?? 0, left: padingL ?? 0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(icon, size: size ?? AppSizes.fontSizeSmall, color: color),
//             SizedBox(width: AppSizes.paddingXSmall.w),
//             TextWidget(
//                 text: title,
//                 fontSize: size ?? AppSizes.fontSizeSmall,
//                 color: color),
//           ],
//         ),
//       );

//   static Widget buildChillRowSpace(String title, String value, Color color,
//           {double? size, double? paddingB, double? padingL}) =>
//       Padding(
//         padding: EdgeInsets.only(bottom: paddingB ?? 0, left: padingL ?? 0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextWidget(
//                 text: title,
//                 fontSize: size ?? AppSizes.fontSizeSmall,
//                 fontWeight: FontWeight.w700,
//                 color: color),
//             Spacer(),
//             TextWidget(
//                 text: value,
//                 fontSize: size ?? AppSizes.fontSizeSmall,
//                 fontWeight: FontWeight.w400,
//                 fontStyle: FontStyle.italic,
//                 color: color),
//           ],
//         ),
//       );

//   static Widget buildChillColumn(String title, String total,
//           {double? size, double? paddingB, double? padingL}) =>
//       Expanded(
//         child: Container(
//           padding: EdgeInsets.symmetric(
//               vertical: AppSizes.paddingXSmall.w,
//               horizontal: AppSizes.paddingSmall.w),
//           decoration: BoxDecoration(
//             color: AppColors.colorBacklog.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(AppSizes.radiusMedium.r),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextWidget(
//                   text: total,
//                   fontSize: AppSizes.fontSizeXLarge,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.darkGrey),
//               SizedBox(height: AppSizes.paddingXSmall),
//               TextWidget(
//                   text: title,
//                   fontSize: size ?? AppSizes.fontSizeSmall,
//                   fontWeight: FontWeight.w400,
//                   color: AppColors.darkGrey.withValues(alpha: 0.5)),
//             ],
//           ),
//         ),
//       );

//   static Widget buildChillColumnWithIcon(
//           {ItemRoleModel? itemRoleModel,
//           String? role,
//           required Color color,
//           required IconData icon}) =>
//       Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//                 color: AppColors.colorBacklog.withOpacity(0.5), width: 0.2)),
//         child: Padding(
//           padding: EdgeInsets.all(AppSizes.paddingXXSmall),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(AppSizes.paddingXXLSmall),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       border: Border.all(color: color.withValues(alpha: 0.5)),
//                       borderRadius:
//                           BorderRadius.circular(AppSizes.radiusMedium.r),
//                     ),
//                     child: Icon(
//                       icon,
//                       size: AppSizes.fontSizeMedium,
//                       color: color,
//                     ),
//                   ),
//                   SizedBox(width: AppSizes.paddingXSmall),
//                   TextWidget(
//                     text: role!,
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSizes.paddingXSmall),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextWidget(
//                     text: 'Kế hoạch',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700]!,
//                   ),
//                   TextWidget(
//                     text: '${itemRoleModel?.toal}',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSizes.paddingXSmall),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextWidget(
//                     text: 'Thực tế',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700]!,
//                   ),
//                   TextWidget(
//                     text: '${itemRoleModel?.actual}',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSizes.paddingSmall),
//               Divider(height: 0.1),
//               SizedBox(height: AppSizes.paddingSmall),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextWidget(
//                     text: 'Báo cáo',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700]!,
//                   ),
//                   TextWidget(
//                     text:
//                         '${itemRoleModel?.report}  - ${itemRoleModel?.reportActual}',
//                     fontSize: AppSizes.fontSizeSmall,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.grey[700]!,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
// }
