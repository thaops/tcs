import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/custom_colum.dart';
import 'package:tcs_flutter/common/widgets/custom_row.dart';
import 'package:tcs_flutter/common/widgets/task_date.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/logic/leave_filter_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';

class LeaveFilterWidget extends StatelessWidget {
  final Function()? onFilter;

  const LeaveFilterWidget({
    super.key,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<LeaveFilterController>()
        ? Get.find<LeaveFilterController>()
        : Get.put(LeaveFilterController());
    if (controller.departmentItems.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.departmentItems.isEmpty) {
          controller.fetchDepartments();
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: TextWidget(
          text: "Lọc dữ liệu",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check_circle_outline,
              color: AppColors.white,
            ),
            onPressed: () {
              onFilter?.call();
            },
          ),
        ],
      ),
      body: CustomColum(
        paddingHorizontal: 16,
        children: [
          16.verticalSpace,
          TextWidget(
            text: "Phòng ban",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          Obx(
            () {
              final ids = controller.departmentItems.map((e) => e.id).toSet();
              final selected = ids.contains(controller.departmentId.value)
                  ? controller.departmentId.value
                  : '';
              return CustomSelect(
                name: 'Chọn phòng ban',
                searchable: false,
                selectList: controller.departmentItems,
                selectedId: selected,
                onProjectSelected: (value) {
                  controller.departmentId.value = (value ?? '').trim();
                },
                isEnabled: true,
              );
            },
          ),
          16.verticalSpace,
          TextWidget(
            text: "Trạng thái",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          Obx(
            () {
              final ids = controller.statusItems.map((e) => e.id).toSet();
              final selected = ids.contains(controller.statusId.value)
                  ? controller.statusId.value
                  : '';
              return CustomSelect(
                name: 'Chọn trạng thái',
                searchable: false,
                selectList: controller.statusItems,
                selectedId: selected,
                onProjectSelected: (value) {
                  controller.statusId.value = (value ?? '').trim();
                },
                isEnabled: true,
              );
            },
          ),
          16.verticalSpace,
          TextWidget(
            text: "Thời gian",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          CustomRow(children: [
            Expanded(
              child: Obx(
                () => TaskDate(
                  colorIcon: AppColors.primary,
                  isHour: false,
                  selectedDate: controller.startDate.value,
                  onDateSelected: (date) {
                    controller.startDate.value = date; // Cập nhật ngày bắt đầu
                  },
                ),
              ),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: Obx(
                () => TaskDate(
                  colorIcon: AppColors.primary,
                  isHour: false,
                  selectedDate: controller.endDate.value,
                  onDateSelected: (date) {
                    controller.endDate.value = date; // Cập nhật ngày bắt đầu
                  },
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
