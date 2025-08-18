import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/widget/custom_user_fliter.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/controller/filter_user_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterUserView extends StatelessWidget {
  final FilterUserController controller = Get.find<FilterUserController>();

  FilterUserView({super.key}) {
    controller.selectEmployeeIds.clear();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.searchController.clear();
        await controller.fetchUserList();
      },
      child: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: () => Get.back(),
              ),
              title: TextWidget(
                text: "Chọn nhân viên",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Trả về Map chứa ids và names
                    Get.back(result: {
                      'ids': controller.selectEmployeeIds.map((e) => e.id).toList(),
                      'names': controller.selectEmployeeIds.map((e) => e.name).toList(),
                    });
                  },
                  child: TextWidget(
                    text: "Xong",
                    fontSize: 14.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: _buildSearch(),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.userDepartmentListSearch.isEmpty) {
                      return Center(
                        child: TextWidget(
                          text: "Không có nhân viên nào",
                          fontSize: 14.sp,
                          color: AppColors.grey,
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: controller.userDepartmentListSearch.length,
                      itemBuilder: (context, index) {
                        final department = controller.userDepartmentListSearch[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Obx(() => Row(
                                    children: [
                                      Expanded(
                                        child: TextWidget(
                                          text: department.name ?? "Không xác định",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      Checkbox(
                                        value: controller.isDepartmentSelected(
                                            department.name ?? ""),
                                        onChanged: (value) {
                                          controller.toggleDepartmentSelection(
                                              department.name ?? "", value ?? false);
                                        },
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(color: Colors.grey.shade400, width: 1.w),
                                ),
                                child: ListView.builder(
                                  itemCount: department.employees?.length ?? 0,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, empIndex) {
                                    final employee = department.employees![empIndex];
                                    return Obx(() => Row(
                                          children: [
                                            Expanded(
                                              child: CustomUserFilter(
                                                name: employee.fullName,
                                                avatar: employee.avatarUrl,
                                                email: employee.email,
                                                department: department.name,
                                              ),
                                            ),
                                            Checkbox(
                                              value: controller.selectEmployeeIds.any(
                                                  (item) => item.id == employee.id),
                                              onChanged: (bool? value) {
                                                if (value != null &&
                                                    employee.id != null &&
                                                    employee.fullName != null) {
                                                  controller.toggleEmployeeSelection(
                                                    ItemFilter(
                                                      id: employee.id!,
                                                      name: employee.fullName!,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ));
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSearch() {
    return Row(
      children: [
        Flexible(
          child: CustomTextField(
            controller: controller.searchController,
            hintText: "Tìm kiếm nhân viên",
            prefixIcon: Icons.search,
            backgroundColor: AppColors.colorbackgroundProfile,
            borderWidth: 1,
            borderColor: AppColors.grey,
            borderRadius: 20,
          ),
        ),
      ],
    );
  }
}