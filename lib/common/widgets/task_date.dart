import 'package:flutter/material.dart';
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
      String? label, DateTime dateTime, BuildContext context) {
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
                      fontSize: 16.sp,
                    ),
            ],
          ),
          SizedBox(height: 10.h),
          AbsorbPointer( // Chặn tương tác khi isEnabled = false
            absorbing: !isEnabled!,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: isEnabled == true
                        ? () {
                            _selectDate(context, dateTime);
                          }
                        : null,
                    child: _buildDateOrTimeRow(
                        'Chọn ngày', _formatDate(dateTime), Icons.calendar_today, context),
                  ),
                ),
                if (isHour == true) SizedBox(width: 16.h),
                if (isHour == true)
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: isEnabled == true
                          ? () {
                              _selectTime(context, dateTime);
                            }
                          : null,
                      child: _buildDateOrTimeRow(
                          'Chọn giờ', _formatTime(dateTime), Icons.access_time, context),
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
      String label, String value, IconData icon, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isEnabled == true ? Colors.white : Colors.grey.shade100, // Nền xám khi vô hiệu hóa
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 1.w,
          color: isEnabled == true ? Colors.grey.shade400 : Colors.grey.shade200, // Viền mờ khi vô hiệu hóa
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
            Icon(
              icon,
              color: Colors.black.withValues(alpha: 0.6), 
            ),
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
    if (isEnabled == false) return; // Ngăn không hiển thị picker khi vô hiệu hóa
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final DateTime updatedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
      );
      onDateSelected(updatedDateTime);
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime initialDate) async {
    if (isEnabled == false) return; // Ngăn không hiển thị picker khi vô hiệu hóa
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime != null) {
      final DateTime updatedDateTime = DateTime(
        initialDate.year,
        initialDate.month,
        initialDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      onDateSelected(updatedDateTime);
    }
  }
}