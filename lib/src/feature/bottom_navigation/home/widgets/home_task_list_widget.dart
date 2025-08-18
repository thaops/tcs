// import 'package:flutter/material.dart';
// import 'package:NPP/src/feature/bottom_navigation/home/data/models/home_task_model.dart';
// import 'package:NPP/src/config/constants/color/colors.dart';
// import 'package:NPP/src/feature/bottom_navigation/home/view/home_detail_screen.dart';
// import 'package:NPP/styles/gogbal_styles.dart';
// import 'package:intl/intl.dart';

// class HomeTaskListWidget extends StatefulWidget {
//   final List<Task>? tasksList;
//   final Function(bool update) updateTaskList;
//   const HomeTaskListWidget({
//     Key? key,
//     this.tasksList,
//     required this.updateTaskList,
//   }) : super(key: key);

//   @override
//   State<HomeTaskListWidget> createState() => _HomeTaskListWidgetState();
// }

// class _HomeTaskListWidgetState extends State<HomeTaskListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: widget.tasksList!.length,
//       itemBuilder: (context, index) {
//         final task = widget.tasksList![index];
//         switch (task.state) {
//           case 'In progress':
//             break;
//           case 'Backlog':
//             break;
//           case 'Done':
//             break;
//           case 'Pending':
//             break;
//           default:
//         }

//         return GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 builder: (context) => TaskBottomSheet(
//                   task: task,
//                   onUpdate: widget.updateTaskList,
//                 ),
//               );
//             },
//             child: _buildTaskItem(task, screenWidth));
//       },
//     );
//   }
// }

// Widget _buildTaskItem(Task task, double screenWidth) {
//   final DateFormat dateFormat = DateFormat("dd-MM");

//   String avatar =
//       'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
//   final titleColor = _getStatusColor(task.state);
//   return GestureDetector(
//     child: Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: Image.network(
//                     avatar,
//                     width: 50,
//                     height: 50,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 16,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: screenWidth * 0.4,
//                       child: Text(
//                         task.title ?? 'Không lý do',
//                         style: GogbalStyles.bodyText2,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       '${dateFormat.format(task.startDate)} - ${dateFormat.format(task.dueDate)}',
//                       style: GogbalStyles.bodyText3,
//                     )
//                   ],
//                 )
//               ],
//             ),
//             Row(
//               children: [
//                 Text(
//                   task.state ?? 'Chưa có thông tin',
//                   style: TextStyle(color: titleColor),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//                 const Icon(Icons.arrow_drop_down, size: 24),
//               ],
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Color _getStatusColor(String? state) {
//   switch (state) {
//     case 'In progress':
//       return in_progress;

//     case 'Backlog':
//       return backlog;

//     case 'Done':
//       return done;

//     case 'Pending':
//       return pending;

//     default:
//       return Colors.black;
//   }
// }
