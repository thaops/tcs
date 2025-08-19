// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:npp/core/configs/theme/app_colors.dart';
// import 'package:npp/src/config/constants/color/colors.dart';
// import 'package:npp/styles/gogbal_styles.dart';

// class ListoffAddWidget extends StatelessWidget {
//   final Function() onAdd; // Thay đổi ở đây

//   const ListoffAddWidget({
//     Key? key,
//     required this.onAdd, // Thay đổi ở đây
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
      
//       onTap: onAdd, // Gọi hàm khi nhấn vào widget
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Card(
//           color: AppColors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Tạo đơn nghỉ phép",
//                       style: GogbalStyles.bodyText2,
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       "Tạo đơn để xin nghỉ đúng quy trình",
//                       style: GogbalStyles.bodyText3,
//                     ),
//                   ],
//                 ),
//                 Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                         color: dark_blue,
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Icon(
//                       Icons.add,
//                       color: Colors.white,
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
