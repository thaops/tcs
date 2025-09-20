import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class MonthSelector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, top: 8.h),
      child: SizedBox(
        height: 65.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: months.length,
          itemBuilder: (context, index) {
            DateTime firstDay = months[index]['firstDay']!;
            DateTime lastDay = months[index]['lastDay']!;
            String monthName = DateFormat('MMMM', 'vi_VN').format(firstDay);
            String yearName = DateFormat('yyyy', 'vi_VN').format(firstDay);
            // Highlight tháng dựa vào khoảng filter hoặc tháng được chọn
            bool isSelected = false;

            if (filterStartDate != null && filterEndDate != null) {
              // Ưu tiên: highlight các tháng trong khoảng filter
              final monthStart = DateTime(firstDay.year, firstDay.month, 1);
              final monthEnd = DateTime(firstDay.year, firstDay.month + 1, 0);

              // Kiểm tra tháng có nằm trong khoảng filter không
              isSelected =
                  (monthStart.isBefore(filterEndDate!) ||
                      monthStart.isAtSameMomentAs(filterEndDate!)) &&
                  (monthEnd.isAfter(filterStartDate!) ||
                      monthEnd.isAtSameMomentAs(filterStartDate!));
            } else if (selectedMonth != null) {
              // Fallback: highlight tháng được chọn trực tiếp
              isSelected = selectedMonth == firstDay;
            } else {
              // Fallback cuối: highlight tháng hiện tại
              final now = DateTime.now();
              final currentMonthIndex = now.month - 1;
              isSelected = index == currentMonthIndex;
            }

            return GestureDetector(
              onTap: () {
                onMonthSelected(firstDay, lastDay);
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
