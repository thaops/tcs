
// import 'package:NPP/widgets/tasks/text_tasks.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class HomeDetailWidget extends StatelessWidget {
//   const HomeDetailWidget({
//     super.key,
//     required Task? fetchedTask,
//     required this.widget,
//     required this.screenWidth,
//     required this.dateFormatD,
//   }) : _fetchedTask = fetchedTask;

//   final Task? _fetchedTask;
//   final TaskBottomSheet widget;
//   final double screenWidth;
//   final DateFormat dateFormatD;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextTasks(
//             text1: 'Dự án',
//             text2: _fetchedTask?.project ?? widget.task.project,
//           ),
//           SizedBox(height: 20),
//           TextTasks(
//             text1: 'Nhân viên',
//             text2: _fetchedTask?.assignee ?? widget.task.assignee,
//           ),
//           SizedBox(height: 20),
//           Container(
//             width: screenWidth,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextTasks(
//                       text1: 'Độ ưu tiên',
//                       text2: _fetchedTask?.priority ?? widget.task.priority,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   flex: 1,
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextTasks(
//                       text1: 'Trạng thái',
//                       text2: _fetchedTask?.state ?? widget.task.state,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           Container(
//             width: screenWidth,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: TextTasks(
//                     text1: 'Ngày bắt đầu',
//                     text2: dateFormatD.format(
//                         _fetchedTask?.startDate ?? widget.task.startDate),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: TextTasks(
//                       text1: 'Ngày kết thúc',
//                       text2: dateFormatD
//                           .format(_fetchedTask?.dueDate ?? widget.task.dueDate),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20),
//           TextTasks(
//             text1: 'Chú thích',
//             text2: _fetchedTask?.note ?? widget.task.note,
//           ),
//         ],
//       ),
//     );
//   }
// }
