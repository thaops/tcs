import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/my_annual_leave_logic.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/summary_user_profile.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/monthly_input_widget.dart';
import 'package:tcs_flutter/common/widgets/enhanced_text_widget.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';

class ProfileAnnualGoalsScreen extends StatelessWidget {
  const ProfileAnnualGoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAnnualLeaveLogic>(
      builder: (logic) {
        return Obx(
          () => LoadingOverlay(
            isLoading: logic.isLoading.value,
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: _buildAppBar(logic),
              body: _buildBody(logic),
              bottomNavigationBar: _buildBottomButtons(logic),
            ),
          ),
        );
      },
    );
  }

  /// AppBar với nút edit
  PreferredSizeWidget _buildAppBar(MyAnnualLeaveLogic logic) {
    return _DynamicAppBar(logic: logic);
  }

  /// Body chính
  Widget _buildBody(MyAnnualLeaveLogic logic) {
    return RefreshIndicator(
      onRefresh: () => logic.refreshData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSummarySection(logic),
            _buildMonthlyInputsSection(logic),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(MyAnnualLeaveLogic logic) {
    return Obx(() {
      final data = logic.annualLeaveData.value;
      if (data == null) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: const Center(child: Text('Không có dữ liệu')),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            SummaryUserProfile(
              title: 'Tổng phép năm',
              subtitle: data.annualQuota.toString(),
              color: AppColors.primary,
            ),
            SummaryUserProfile(
              title: 'Tổng đăng ký',
              subtitle: logic.totalRegistered.toString(),
              color: AppColors.primary,
            ),
            SummaryUserProfile(
              title: 'Ngày không sử dụng',
              subtitle: logic.unusedDays.toString(),
              color: AppColors.primary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMonthlyInputsSection(MyAnnualLeaveLogic logic) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildMonthlyGrid(logic)],
      ),
    );
  }

  /// Grid input theo tháng
  Widget _buildMonthlyGrid(MyAnnualLeaveLogic logic) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = (index + 1).toString();
        return _buildMonthInput(logic, month);
      },
    );
  }

  Widget _buildMonthInput(MyAnnualLeaveLogic logic, String month) {
    return MonthlyInputWidget(month: month, logic: logic);
  }

  Widget _buildBottomButtons(MyAnnualLeaveLogic logic) {
    return Obx(() {
      if (!logic.isEditMode.value) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: OutlinedButton(
                  onPressed: logic.cancelChanges,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: AppText.buttonMedium(
                    'Đóng',
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 48.h,
                child: ElevatedButton(
                  onPressed: logic.canSave ? logic.saveData : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child:
                      logic.isLoading.value
                          ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : AppText.buttonMedium('Lưu', color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// Dynamic AppBar widget để hỗ trợ reactive icon
class _DynamicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final MyAnnualLeaveLogic logic;

  const _DynamicAppBar({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AppBarWidget(
        title: 'Nguyện vọng phép năm',
        backgroundColor: const Color(0xFFF5F5F5),
        iconRightfirst: logic.isEditMode.value ? Icons.close : Icons.edit,
        colorfirst: AppColors.primary,
        functionfirst: () => logic.toggleEditMode(),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
