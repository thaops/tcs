import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class TaskDate extends StatelessWidget {
  final String? label;
  final DateTime selectedDate;
  final IconData? icon;
  final Color? colorIcon;
  final bool? isHour;
  final Function(DateTime) onDateSelected;
  final bool? isEnabled;

  const TaskDate({
    this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.icon,
    this.colorIcon,
    this.isHour = true,
    this.isEnabled = true, // Mặc định là bật
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildDateTimeColumns(label, selectedDate, context);
  }

  Widget _buildDateTimeColumns(
    String? label,
    DateTime dateTime,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              label == null
                  ? Container()
                  : TextWidget(
                    text: label,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    fontSize: 14.sp,
                  ),
            ],
          ),
          SizedBox(height: 10.h),
          AbsorbPointer(
            // Chặn tương tác khi isEnabled = false
            absorbing: !isEnabled!,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap:
                        isEnabled == true
                            ? () {
                              _selectDate(context, dateTime);
                            }
                            : null,
                    child: _buildDateOrTimeRow(
                      'Chọn ngày',
                      _formatDate(dateTime),
                      Icons.calendar_today,
                      context,
                    ),
                  ),
                ),
                if (isHour == true) SizedBox(width: 16.h),
                if (isHour == true)
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap:
                          isEnabled == true
                              ? () {
                                _selectTime(context, dateTime);
                              }
                              : null,
                      child: _buildDateOrTimeRow(
                        'Chọn giờ',
                        _formatTime(dateTime),
                        Icons.access_time,
                        context,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateOrTimeRow(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            isEnabled == true
                ? Colors.white
                : Colors.grey.shade100, // Nền xám khi vô hiệu hóa
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 1.w,
          color:
              isEnabled == true
                  ? Colors.grey.shade400
                  : Colors.grey.shade200, // Viền mờ khi vô hiệu hóa
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: value,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 0.6),
              fontSize: 14.sp,
            ),
            Icon(icon, color: Colors.black.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    if (isEnabled == false)
      return; // Ngăn không hiển thị picker khi vô hiệu hóa

    DateTime selectedDate = initialDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Container(
            height: 320,
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header với nút Cancel và Done
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Chọn ngày',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Xong',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onPressed: () {
                          final DateTime updatedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            initialDate.hour,
                            initialDate.minute,
                          );
                          onDateSelected(updatedDateTime);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.grey.shade200,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Cupertino Date Picker
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      minimumDate: DateTime(2000),
                      maximumDate: DateTime(2100),
                      backgroundColor: Colors.transparent,
                      onDateTimeChanged: (DateTime date) {
                        selectedDate = date;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context, DateTime initialDate) async {
    if (isEnabled == false)
      return; // Ngăn không hiển thị picker khi vô hiệu hóa

    DateTime selectedDateTime = initialDate;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Container(
            height: 320,
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header với nút Cancel và Done
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Chọn giờ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Xong',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onPressed: () {
                          final DateTime updatedDateTime = DateTime(
                            initialDate.year,
                            initialDate.month,
                            initialDate.day,
                            selectedDateTime.hour,
                            selectedDateTime.minute,
                          );
                          onDateSelected(updatedDateTime);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.grey.shade200,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Cupertino Time Picker
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      initialDateTime: initialDate,
                      backgroundColor: Colors.transparent,
                      onDateTimeChanged: (DateTime time) {
                        selectedDateTime = time;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
