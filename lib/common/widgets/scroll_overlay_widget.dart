// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ScrollOverlayWidget extends StatelessWidget {
//   final double top;
//   final double bottom;
//   final double left;
//   final double right;
//   final Color backgroundColor;
//   final double opacity;
//   final Future<void> Function() onRefresh;

//   const ScrollOverlayWidget({
//     Key? key,
//     this.top = 100, // Khoảng cách từ trên
//     this.bottom = 100, // Khoảng cách từ dưới
//     this.left = 0, // Khoảng cách từ trái
//     this.right = 0, // Khoảng cách từ phải
//     this.backgroundColor = Colors.white, // Màu nền của lớp phủ
//     this.opacity = 0.7, // Độ mờ của nền
//     required this.onRefresh, // Hàm gọi khi refresh
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: left,
//       right: right,
//       top: top,
//       bottom: bottom,
//       child: IgnorePointer(
//         ignoring: false, // Cho phép cuộn
//         child: RefreshIndicator(
//           onRefresh: onRefresh, // Gọi hàm refresh khi cuộn
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   color: backgroundColor.withOpacity(opacity),
//                   height: Get.height * 2, // Điều chỉnh chiều cao để có thể cuộn
//                   width: Get.width,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
