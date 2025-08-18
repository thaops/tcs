// import 'package:flutter/material.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String label;
//   final IconData icon;
//   final bool obscureText;
//   final bool enabled;

//   CustomTextField({
//     required this.controller,
//     required this.hintText,
//     required this.label,
//     required this.icon,
//     this.obscureText = false,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         Container(
//           height: 50,
//           decoration: BoxDecoration(
//             border: Border.all(width: 1, color: Colors.grey),
//             borderRadius: BorderRadius.circular(24),
//           ),
//           child: TextField(
//             controller: controller,
//             enabled: enabled,
//             obscureText: obscureText,
//             decoration: InputDecoration(
//               contentPadding:
//                   EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               hintText: hintText,
//               border: InputBorder.none,
//               prefixIcon: Icon(icon, size: 24),
//               suffixIcon: obscureText
//                   ? IconButton(
//                       icon: Icon(
//                         Icons.remove_red_eye,
//                         size: 24,
//                       ),
//                       onPressed: () {

//                       },
//                     )
//                   : null,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
