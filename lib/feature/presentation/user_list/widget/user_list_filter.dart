import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/custom_colum.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/feature/presentation/user_list/controller/user_controller.dart';

class UserListFilter extends StatelessWidget {
  final Function()? onFilter;

  const UserListFilter({
    super.key,
    this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
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
              controller.applyFilters();
              onFilter?.call();
              Get.back();
            },
          ),
        ],
      ),
      body: CustomColum(
        paddingHorizontal: 16,
        children: [
          20.verticalSpace,
          TextWidget(
            text: "Danh mục nhân viên",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          
          CustomSelect(
            name: 'Danh mục nhân viên',
            searchable: false,
            selectList: controller.userTypeItems,
            selectedId: controller.userType.value,
            onProjectSelected: (value) {
              controller.userType.value = value ?? '';
            },
            isEnabled: true,
          ),
          TextWidget(
            text: "Phòng ban",
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
          
          CustomSelect(
            name: 'Chọn phòng ban',
            searchable: false,
            selectList: controller.departmentItems,
            selectedId: controller.departmentId.value,
            onProjectSelected: (value) {
              controller.departmentId.value = value ?? '';
            },
            isEnabled: true,
          )
        ],
      ),
    );
  }
}
