// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:npp/feature/presentation/home_management_task/model/req_task_model.dart';
// import 'package:npp/feature/presentation/home_management_task/widget/home_filter.dart';

// class CustomShowFilter {
//   Future<void> buildShowFilter(
//     BuildContext context,
//     Function(ReqKanban) onFilter,
//     Function() onClearFilter,
//     bool? isBoard,
//   ) async {
//     final result = await showModalBottomSheet<ReqKanban>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).canvasColor,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r),
//               topRight: Radius.circular(20.r),
//             ),
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: FractionallySizedBox(
//             heightFactor: 0.8,
//             child: HomeFilter(
//               isBoard: isBoard ?? false,
//               onFilter: (reqKanban) {
//                 Navigator.pop(context, reqKanban);
//               },
//               onClearFilter: () {
//                 onClearFilter();
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         );
//       },
//     );

//     if (result != null) {
//       onFilter(result); // Gọi callback với ReqKanban
//     }
//   }
// }
