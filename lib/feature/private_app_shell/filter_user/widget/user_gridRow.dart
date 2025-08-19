// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:npp/common/utils/date_utils.dart';
// import 'package:npp/common/widgets/text_widget.dart';
// import 'package:npp/core/configs/theme/app_colors.dart';
// import 'package:npp/feature/presentation/user_list/model/user_list_model.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import 'package:npp/feature/presentation/user_list/controller/user_controller.dart';

// class UserGridCell {
//   static const String id = 'id';
//   static const String avatar = 'avatar';
//   static const String userTypeLabel = 'userTypeLabel';
//   static const String department = 'department';
//   static const String fullName = 'fullName';
//   static const String tel = 'tel';
//   static const String email = 'email';
//   static const String licensePlace = 'licensePlace';
//   static const String bankInfo = 'bankInfo';
//   static const String startDate = 'startDate';
//   static const String expiredDate = 'expiredDate';
//   static const String edit = 'edit';
//   static const String changePass = 'changePass';
//   static const String delete = 'delete';
// }

// class UserGridDataSource extends DataGridSource {
//   UserGridDataSource({required List<UserListModel> users}) {
//     _employees = users.map<DataGridRow>((e) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: UserGridCell.id, value: e.id ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.avatar, value: e.avatarUrl ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.fullName, value: e.fullName ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.email, value: e.email ?? ''),
//         DataGridCell<String>(columnName: UserGridCell.tel, value: e.tel ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.department, value: e.department ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.userTypeLabel,
//             value: e.userTypeLabel ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.licensePlace, value: e.licensePlace ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.bankInfo, value: e.bankInfo ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.startDate, value: e.startDate ?? ''),
//         DataGridCell<String>(
//             columnName: UserGridCell.expiredDate, value: e.expiredDate ?? ''),
//         // DataGridCell<String>(columnName: UserGridCell.edit, value: ''),        DataGridCell<String>(columnName: UserGridCell.delete, value: ''),
//       ]);
//     }).toList();
//   }

//   List<DataGridRow> _employees = [];

//   @override
//   List<DataGridRow> get rows => _employees;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     int rowIndex = _employees.indexOf(row);
//     bool isEvenRow = rowIndex % 2 == 0;

//     return DataGridRowAdapter(
//       color: isEvenRow ? AppColors.grey.withOpacity(0.2) : AppColors.white,
//       cells: row.getCells().map<Widget>((dataGridCell) {
//         switch (dataGridCell.columnName) {
//           case UserGridCell.avatar:
//             String imageUrl = dataGridCell.value ?? '';
//             return Container(
//               height: 80.0,
//               alignment: Alignment.center,
//               padding: EdgeInsets.all(8.0),
//               child: imageUrl.isNotEmpty
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(6),
//                       child: Image.network(
//                         imageUrl,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stack) {
//                           return Icon(Icons.error);
//                         },
//                       ),
//                     )
//                   : Icon(Icons.error),
//             );
//           case UserGridCell.fullName:
//           case UserGridCell.email:
//           case UserGridCell.tel:
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextWidget(
//                   text: dataGridCell.value.toString(),
//                   fontSize: 12,
//                   maxLines: 5,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             );

//           case UserGridCell.startDate:
//           case UserGridCell.expiredDate:
//             return Center(
//               child: TextWidget(
//                 text: DateUtilsCustom.formatStringDate(
//                     dataGridCell.value.toString()),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             );
//           case UserGridCell.edit:
//             return IconButton(
//               onPressed: () {
//                 // String userId = row
//                 //     .getCells()
//                 //     .firstWhere((cell) => cell.columnName == UserGridCell.id)
//                 //     .value
//                 //     .toString();
//                 // Get.dialog(UserUpdate(userId: userId));
//               },
//               icon: Icon(Icons.edit, color: AppColors.white),
//             );
//           case UserGridCell.changePass:
//             return IconButton(
//               onPressed: () {
//                 // String userId = row
//                 //     .getCells()
//                 //     .firstWhere((cell) => cell.columnName == UserGridCell.id)
//                 //     .value
//                 //     .toString();
//                 // Get.dialog(Changepass(userId: userId));
//               },
//               icon: Icon(Icons.lock, color: AppColors.white),
//             );
//           case UserGridCell.delete:
//             return IconButton(
//               onPressed: () {
//                 // String userId = row
//                 //     .getCells()
//                 //     .firstWhere((cell) => cell.columnName == UserGridCell.id)
//                 //     .value
//                 //     .toString();
//                 // UserController controller = Get.find();
//                 // controller.deleteUserById(userId);
//               },
//               icon: Icon(Icons.delete),
//               color: AppColors.colorRed,
//             );
//           default:
//             return Container(
//               height: 80.0,
//               alignment: Alignment.center,
//               padding: EdgeInsets.all(16.0),
//               child: Text(dataGridCell.value.toString()),
//             );
//         }
//       }).toList(),
//     );
//   }
// }
