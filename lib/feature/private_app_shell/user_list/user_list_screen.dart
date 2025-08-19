import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/view/profile_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/user_list/controller/user_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/feature/private_app_shell/user_list/widget/custom_user_list.dart';
import 'package:tcs_flutter/feature/private_app_shell/user_list/widget/user_list_filter.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) => RefreshIndicator(
        onRefresh: () async {
          controller.searchController.clear();
          await controller.fetchUserList();
        },
        child: Obx(
          () => LoadingOverlay(
            isLoading: controller.isLoading.value,
            child: Scaffold(
              appBar: AppBarWidget(
                title: "Danh sách Nhân viên",
                isTitleCenter: false,
                iconRightfirst: Icons.filter_alt_rounded,
                colorfirst: AppColors.primary,
                functionfirst: () {
                  final controller = Get.find<UserController>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const UserListFilter(),
                        ),
                      );
                    },
                  );
                },
                isBack: false,
              ),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: controller.searchController,
                          hintText: "Tìm kiếm nhân viên",
                          prefixIcon: Icons.search,
                          backgroundColor: AppColors.colorbackgroundProfile,
                          borderColor: AppColors.colorBackgroundGoogle,
                          borderRadius: 20,
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      // Error state in center
                      if (controller.errorMessage.value.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline, color: AppColors.primary, size: 40.sp),
                                12.verticalSpace,
                                TextWidget(
                                  text: controller.errorMessage.value,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Empty state when no data and not loading
                      if (!controller.isLoading.value && controller.userDepartmentListSearch.isEmpty) {
                        return Center(
                          child: TextWidget(
                            text: 'Không có dữ liệu',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        );
                      }

                      // Normal list
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.r),
                        child: CustomScrollView(
                          cacheExtent: 3000.0,
                          slivers: [
                            ...controller.userDepartmentListSearch.map((department) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (index == 0) {
                                      return TextWidget(
                                        text: department.name.toString(),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      );
                                    }
                                    final employee = department.employees?[index - 1];
                                    if (employee == null) return const SizedBox.shrink();
                                    return RepaintBoundary(
                                      child: CustomUserList(
                                        name: employee.fullName,
                                        avatar: employee.avatarUrl,
                                        email: employee.email,
                                        department: department.name,
                                        onTap: () {
                                          Get.to(
                                            ProfileScreen(flag: true),
                                            arguments: employee.id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  childCount: (department.employees?.length ?? 0) + 1,
                                ),
                              );
                            })
                          ],
                        ),
                      );
                    })
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
