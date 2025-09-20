import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class MonthSelector extends StatefulWidget {
  final List<Map<String, DateTime>> months;
  final DateTime? selectedMonth;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final void Function(DateTime firstDay, DateTime lastDay) onMonthSelected;

  const MonthSelector({
    Key? key,
    required this.months,
    required this.selectedMonth,
    this.filterStartDate,
    this.filterEndDate,
    required this.onMonthSelected,
  }) : super(key: key);

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll đến tháng hiện tại sau khi widget được build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentMonth() {
    final now = DateTime.now();
    final currentMonthIndex = now.month - 1; // 0-based index

    if (currentMonthIndex < widget.months.length) {
      // Tính toán vị trí scroll để tháng hiện tại ở giữa
      final itemWidth = 100.0 + 16.0; // width + padding
      final screenWidth = MediaQuery.of(context).size.width;
      final targetPosition =
          (currentMonthIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        targetPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 8.h),
      child: SizedBox(
        height: 65.h,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.months.length,
          itemBuilder: (context, index) {
            DateTime firstDay = widget.months[index]['firstDay']!;
            DateTime lastDay = widget.months[index]['lastDay']!;
            String monthName = DateFormat('MMMM', 'vi_VN').format(firstDay);
            String yearName = DateFormat('yyyy', 'vi_VN').format(firstDay);
            // Highlight tháng dựa vào khoảng filter hoặc tháng được chọn
            bool isSelected = false;

            if (widget.filterStartDate != null &&
                widget.filterEndDate != null) {
              // Ưu tiên: highlight các tháng trong khoảng filter
              final monthStart = DateTime(firstDay.year, firstDay.month, 1);
              final monthEnd = DateTime(firstDay.year, firstDay.month + 1, 0);

              // Kiểm tra tháng có nằm trong khoảng filter không
              isSelected =
                  (monthStart.isBefore(widget.filterEndDate!) ||
                      monthStart.isAtSameMomentAs(widget.filterEndDate!)) &&
                  (monthEnd.isAfter(widget.filterStartDate!) ||
                      monthEnd.isAtSameMomentAs(widget.filterStartDate!));
            } else if (widget.selectedMonth != null) {
              // Fallback: highlight tháng được chọn trực tiếp
              isSelected = widget.selectedMonth == firstDay;
            } else {
              // Fallback cuối: highlight tháng hiện tại
              final now = DateTime.now();
              final currentMonthIndex = now.month - 1;
              isSelected = index == currentMonthIndex;
            }

            return GestureDetector(
              onTap: () {
                widget.onMonthSelected(firstDay, lastDay);
              },
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppColors.primary
                            : AppColors.colorMessageEnemy.withOpacity(0.3),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.colorMessageEnemy.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SizedBox(
                    width: 100.w,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            text: monthName,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),

                          TextWidget(
                            paddingHorizontal: 1.r,
                            text: '/',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),
                          TextWidget(
                            text: yearName,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
