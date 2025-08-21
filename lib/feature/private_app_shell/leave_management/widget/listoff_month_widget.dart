import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class MonthSelector extends StatelessWidget {
  final List<Map<String, DateTime>> months;
  final DateTime? selectedMonth;
  final void Function(DateTime firstDay, DateTime lastDay) onMonthSelected;

  const MonthSelector({
    Key? key,
    required this.months,
    required this.selectedMonth,
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
            final defaultIndex = months.length > 1 ? 1 : 0;
            bool isSelected =
                selectedMonth == null
                    ? index == defaultIndex
                    : selectedMonth == firstDay;

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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 100.w, // Đặt chiều rộng cụ thể cho Card
                    child: Center(
                      // Sử dụng Center để căn giữa nội dung
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
                            paddingHorizontal: 1,
                            text: '/',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),
                          TextWidget(
                            text: yearName,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                  isSelected
                                      ? AppColors.white
                                      : AppColors.black,
                              
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
