import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/state_widget/empty_lottie_state.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_statistics_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_statistics_card.dart';

class LeaveStatisticsScreen extends StatelessWidget {
  const LeaveStatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveStatisticsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading.value,
          child: Column(
            children: [
              SizedBox(height: 55),
              _buildTabBar(controller),
              Expanded(child: _buildTabContent(controller)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(LeaveStatisticsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE9EDF1), // Nền xám nhạt cho container
          borderRadius: BorderRadius.circular(22), // Pill shape
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildTabItem(
                controller,
                0,
                "Hôm nay",
                controller.todayLeaves.length,
              ),
            ),
            const SizedBox(width: 8), // Khoảng cách giữa 2 tab
            Expanded(
              child: _buildTabItem(
                controller,
                1,
                "Sắp tới",
                controller.upcomingLeaves.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    LeaveStatisticsController controller,
    int index,
    String title,
    int count,
  ) {
    final isSelected = controller.selectedTabIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 40, // Chiều cao 36-44dp
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFF4A100) // Nền cam khi được chọn
                  : Colors.transparent, // Trong suốt khi không chọn
          borderRadius: BorderRadius.circular(18), // Pill shape
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFFF4A100).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected
                          ? Colors
                              .white // Chữ trắng khi được chọn
                          : const Color(
                            0xFF5F6B76,
                          ), // Chữ xám đậm khi không chọn
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.white.withOpacity(
                            0.2,
                          ) // Badge trong suốt khi chọn
                          : const Color(
                            0xFF5F6B76,
                          ).withOpacity(0.1), // Badge xám nhạt khi không chọn
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:
                        isSelected
                            ? Colors
                                .white // Số trắng khi được chọn
                            : const Color(
                              0xFF5F6B76,
                            ), // Số xám đậm khi không chọn
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(LeaveStatisticsController controller) {
    return Obx(() {
      final selectedIndex = controller.selectedTabIndex.value;

      if (selectedIndex == 0) {
        return _buildTodayTab(controller);
      } else {
        return _buildUpcomingTab(controller);
      }
    });
  }

  Widget _buildTodayTab(LeaveStatisticsController controller) {
    return Obx(() {
      if (controller.todayLeaves.isEmpty &&
          controller.isLoading.value == false) {
        return EmptyLottieState();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: RefreshIndicator(
          onRefresh: () => controller.fetchStatistics(),
          child: ListView.builder(
            itemCount: controller.todayLeaves.length,
            itemBuilder: (context, index) {
              return LeaveStatisticsCard(
                leave: controller.todayLeaves[index],
                showDateTime: false, // Tab "Hôm nay" không hiển thị ngày/giờ
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildUpcomingTab(LeaveStatisticsController controller) {
    return Obx(() {
      if (controller.upcomingLeaves.isEmpty &&
          controller.isLoading.value == false) {
        return EmptyLottieState();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: RefreshIndicator(
          onRefresh: () => controller.fetchStatistics(),
          child: ListView.builder(
            itemCount: controller.upcomingLeaves.length,
            itemBuilder: (context, index) {
              return LeaveStatisticsCard(
                leave: controller.upcomingLeaves[index],
                showDateTime: true, // Tab "Sắp tới" hiển thị ngày/giờ
              );
            },
          ),
        ),
      );
    });
  }
}
