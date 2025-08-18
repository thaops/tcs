// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:npp/common/model/item_select.dart';

// // Định nghĩa class GroupedItem
// class GroupedItem {
//   final String groupTitle;
//   final List<ItemSelect> items;

//   GroupedItem({required this.groupTitle, required this.items});
// }

// // GetX Controller để quản lý trạng thái
// class MultiSelectController extends GetxController {
//   final RxList<String> selectedItemIds = <String>[].obs;
//   final void Function(List<String>)? onItemsSelected;

//   MultiSelectController({List<String>? initialSelectedIds, this.onItemsSelected}) {
//     if (initialSelectedIds != null && initialSelectedIds.isNotEmpty) {
//       selectedItemIds.addAll(initialSelectedIds.toSet());
//     }
//   }

//   void toggleItem(String id) {
//     if (selectedItemIds.contains(id)) {
//       selectedItemIds.remove(id);
//     } else {
//       selectedItemIds.add(id);
//     }
//     onItemsSelected?.call(selectedItemIds.toList());
//   }

//   void toggleGroup(List<ItemSelect> groupItems, bool shouldSelect) {
//     final groupItemIds = groupItems.map((item) => item.id).toList();
//     if (shouldSelect) {
//       selectedItemIds.addAll(groupItemIds.where((id) => !selectedItemIds.contains(id)));
//     } else {
//       selectedItemIds.removeWhere((id) => groupItemIds.contains(id));
//     }
//     onItemsSelected?.call(selectedItemIds.toList());
//   }
// }

// // Widget chính
// class CustomMultiSelectItem extends StatelessWidget {
//   final String? label;
//   final String? hintText;
//   final Color? colorIcon;
//   final IconData? icon;
//   final List<GroupedItem>? groupedItems;
//   final List<String>? initialSelectedIds;
//   final void Function(List<String>)? onItemsSelected;

//   const CustomMultiSelectItem({
//     Key? key,
//     this.label,
//     this.hintText,
//     this.groupedItems,
//     this.colorIcon,
//     this.onItemsSelected,
//     this.initialSelectedIds,
//     this.icon,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(
//       MultiSelectController(
//         initialSelectedIds: initialSelectedIds,
//         onItemsSelected: onItemsSelected,
//       ),
//       tag: label ?? UniqueKey().toString(),
//     );

//     // Tạo FocusNode và TextEditingController cho ô tìm kiếm
//     final searchController = TextEditingController();
//     final focusNode = FocusNode();

//     final screenWidth = MediaQuery.of(context).size.width;
//     final allItems = groupedItems?.expand((group) => group.items).toList() ?? [];

//     return Container(
//       padding: EdgeInsets.only(bottom: 16.h),
//       width: screenWidth,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (label != null)
//             Padding(
//               padding: EdgeInsets.only(bottom: 8.h),
//               child: Text(
//                 label!,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400,
//                   color: colorIcon ?? Colors.black,
//                   fontFamily: 'Inter',
//                 ),
//               ),
//             ),
//           DropdownButtonHideUnderline(
//             child: DropdownButton2<String>(
//               isExpanded: true,
//               hint: Text(
//                 hintText ?? 'Chọn mục',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w400,
//                   color: colorIcon ?? Colors.grey,
//                   fontFamily: 'Inter',
//                 ),
//               ),
//               items: _buildGroupedDropdownItems(controller),
//               value: null,
//               onChanged: (value) {},
//               onMenuStateChange: (isOpen) {
//                 // Khi dropdown mở, tự động focus vào ô tìm kiếm
//                 if (isOpen) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     focusNode.requestFocus();
//                   });
//                 }
//               },
//               buttonStyleData: ButtonStyleData(
//                 padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                 height: 50.h,
//                 width: screenWidth,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                   border: Border.all(color: Colors.grey.shade300, width: 1.5),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//               ),
//               iconStyleData: IconStyleData(
//                 iconEnabledColor: colorIcon ?? Colors.grey.shade700,
//                 iconSize: 20.sp,
//                 icon: Icon(
//                   icon ?? Icons.keyboard_arrow_down_rounded,
//                 ),
//               ),
//               dropdownStyleData: DropdownStyleData(
//                 maxHeight: Get.height * 0.4,
//                 padding: EdgeInsets.symmetric(vertical: 8.h),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12.r),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.15),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 scrollbarTheme: ScrollbarThemeData(
//                   radius: Radius.circular(16.r),
//                   thickness: WidgetStateProperty.all(6),
//                 ),
//               ),
//               menuItemStyleData: MenuItemStyleData(
//                 height: 50.h,
//                 padding: EdgeInsets.zero,
//               ),
//               dropdownSearchData: DropdownSearchData(
//                 searchController: searchController,
//                 searchInnerWidgetHeight: 50.h,
//                 searchInnerWidget: Container(
//                   height: 50.h,
//                   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                   child: TextFormField(
//                     controller: searchController,
//                     focusNode: focusNode,
//                     autofocus: true, // Tự động focus khi ô tìm kiếm hiển thị
//                     decoration: InputDecoration(
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//                       hintText: 'Tìm kiếm...',
//                       hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                     ),
//                   ),
//                 ),
//                 searchMatchFn: (item, searchValue) {
//                   if (item.value == null) return false;
//                   // Bỏ qua các mục không phải item (như tiêu đề nhóm hoặc divider)
//                   if (item.value!.startsWith('divider_') ||
//                       groupedItems!.any((group) => group.groupTitle == item.value)) {
//                     return false;
//                   }
//                   // Lấy tên item từ groupedItems
//                   final itemName = groupedItems!
//                       .expand((group) => group.items)
//                       .firstWhere((i) => i.id == item.value, orElse: () => ItemSelect(id: '', name: ''))
//                       .name;
//                   return itemName.toLowerCase().contains(searchValue.toLowerCase());
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           _buildChipList(controller, allItems),
//         ],
//       ),
//     );
//   }

//   Widget _buildChipList(MultiSelectController controller, List<ItemSelect> allItems) {
//     return Obx(() {
//       final uniqueSelectedIds = controller.selectedItemIds.toSet();
//       if (uniqueSelectedIds.isEmpty) {
//         return const SizedBox.shrink();
//       }
//       final validSelectedIds = uniqueSelectedIds.where((id) => allItems.any((item) => item.id == id)).toList();
//       if (validSelectedIds.isEmpty) {
//         return const SizedBox.shrink();
//       }
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Wrap(
//           spacing: 6.w,
//           runSpacing: 4.h,
//           children: validSelectedIds.map((id) {
//             final item = allItems.firstWhere(
//               (item) => item.id == id,
//               orElse: () => ItemSelect(id: id, name: 'Không xác định'),
//             );
//             return AnimatedOpacity(
//               opacity: validSelectedIds.contains(id) ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 200),
//               child: Chip(
//                 label: Text(
//                   item.name,
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 13.sp,
//                     fontFamily: 'Inter',
//                   ),
//                 ),
//                 deleteIcon: Icon(
//                   Icons.close,
//                   size: 16.sp,
//                   color: Colors.grey.shade600,
//                 ),
//                 onDeleted: () {
//                   controller.toggleItem(item.id);
//                 },
//                 backgroundColor: Colors.grey.shade100,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16.r),
//                   side: BorderSide(color: Colors.grey.shade300, width: 1),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
//                 elevation: 2,
//                 shadowColor: Colors.black.withOpacity(0.1),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     });
//   }

//   List<DropdownMenuItem<String>> _buildGroupedDropdownItems(MultiSelectController controller) {
//     List<DropdownMenuItem<String>> dropdownItems = [];

//     for (var group in groupedItems ?? []) {
//       if (group.groupTitle.isNotEmpty) {
//         dropdownItems.add(
//           DropdownMenuItem<String>(
//             value: group.groupTitle,
//             enabled: false,
//             child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 final allSelected = group.items.every((item) => controller.selectedItemIds.contains(item.id));
//                 return GestureDetector(
//                   onTap: () {
//                     controller.toggleGroup(group.items, !allSelected);
//                     setState(() {});
//                   },
//                   child: Container(
//                     height: 40.h,
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                     color: Colors.grey.shade50,
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: allSelected,
//                           onChanged: (value) {
//                             controller.toggleGroup(group.items, value ?? false);
//                             setState(() {});
//                           },
//                           activeColor: Colors.blue.shade600,
//                           checkColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4.r),
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             group.groupTitle,
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 15.sp,
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//         dropdownItems.add(
//           DropdownMenuItem<String>(
//             value: 'divider_${group.groupTitle}',
//             enabled: false,
//             child: Divider(
//               height: 1.h,
//               thickness: 1,
//               color: Colors.grey.shade300,
//             ),
//           ),
//         );
//       }

//       for (var item in group.items) {
//         dropdownItems.add(
//           DropdownMenuItem<String>(
//             value: item.id,
//             enabled: false,
//             child: StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 final isSelected = controller.selectedItemIds.contains(item.id);
//                 return InkWell(
//                   onTap: () {
//                     controller.toggleItem(item.id);
//                     setState(() {});
//                   },
//                   child: Container(
//                     height: 48.h,
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//                     child: Row(
//                       children: [
//                         Checkbox(
//                           value: isSelected,
//                           onChanged: (value) {
//                             controller.toggleItem(item.id);
//                             setState(() {});
//                           },
//                           activeColor: Colors.blue.shade600,
//                           checkColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4.r),
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             item.name,
//                             style: TextStyle(
//                               color: isSelected ? Colors.blue.shade600 : Colors.black87,
//                               fontWeight: FontWeight.w400,
//                               fontSize: 14.sp,
//                               fontFamily: 'Inter',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       }
//     }

//     return dropdownItems;
//   }
// }