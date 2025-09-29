import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/summary_day_off_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/summary_user_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryDayOffScreen extends StatefulWidget {
  const SummaryDayOffScreen({super.key});

  @override
  State<SummaryDayOffScreen> createState() => _SummaryDayOffScreenState();
}

class _SummaryDayOffScreenState extends State<SummaryDayOffScreen> {
  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SummaryDayOffLogic>()) {
      Get.put(SummaryDayOffLogic());
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SummaryDayOffLogic>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Obx(() {
                  final data = controller.summaryData.value;

                  if (data == null) {
                    return Center(
                      child: TextWidget(
                        text: 'Không có dữ liệu',
                        fontSize: 16.sp,
                        color: AppColors.grey,
                      ),
                    );
                  }

                  return Column(
                    children: [
                      SummaryUserProfile(
                        title: 'Tiêu chuẩn phép',
                        subtitle: data.quota.toString(),
                      ),
                      16.verticalSpace,
                      // SummaryUserProfile(
                      //   title: 'Tổng ngày phép đã nghỉ',
                      //   subtitle: controller.usedDays.toString(),
                      //   color: AppColors.colorRed,
                      // ),
                      SummaryUserProfile(
                        title: 'Ngày phép còn tồn',
                        subtitle: data.leaveDaysLeft.toString(),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
      ),
      title: TextWidget(
        text: 'Theo dõi ngày phép',
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      centerTitle: true,
    );
  }
}
