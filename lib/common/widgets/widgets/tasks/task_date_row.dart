import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class TaskDateRow extends StatelessWidget {
  final String label1;
  final DateTime date1;
  final String label2;
  final DateTime date2;
  final Function(DateTime, bool) onDateSelected;

  TaskDateRow({
    required this.label1,
    required this.date1,
    required this.label2,
    required this.date2,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDateDetailColumn(label1, date1, context, true),
        const SizedBox(width: 16),
        _buildDateDetailColumn(label2, date2, context, false),
      ],
    );
  }

  Widget _buildDateDetailColumn(
    String label,
    DateTime dateTime,
    BuildContext context,
    bool isStartDate,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              _selectDateTime(context, dateTime, isStartDate);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(width: 1.0, color: Colors.grey.shade400),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(dateTime),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _formatTime(dateTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _selectDateTime(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) async {
    // Kiểm tra nền tảng và sử dụng picker phù hợp
    if (Theme.of(context).platform == TargetPlatform.iOS ||
        (!kIsWeb && Platform.isIOS)) {
      // Sử dụng Cupertino Date Time Picker cho iOS
      await _showCupertinoDateTimePicker(context, initialDate, isStartDate);
    } else {
      // Sử dụng Material Date Time Picker cho Android
      await _showMaterialDateTimePicker(context, initialDate, isStartDate);
    }
  }

  Future<void> _showCupertinoDateTimePicker(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) async {
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
            height: 350,
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
                      Column(
                        children: [
                          Text(
                            'Chọn ngày và giờ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(selectedDateTime),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade400,
                                Colors.blue.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
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
                          // Cập nhật ngày và giờ
                          onDateSelected(selectedDateTime, isStartDate);
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
                // Cupertino Date Time Picker
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      initialDateTime: initialDate,
                      minimumDate: DateTime(2000),
                      maximumDate: DateTime(2100),
                      backgroundColor: Colors.transparent,
                      onDateTimeChanged: (DateTime dateTime) {
                        selectedDateTime = dateTime;
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

  Future<void> _showMaterialDateTimePicker(
    BuildContext context,
    DateTime initialDate,
    bool isStartDate,
  ) async {
    // Chọn ngày trước
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Chọn giờ sau khi chọn ngày
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        final DateTime newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Cập nhật ngày và giờ
        onDateSelected(newDateTime, isStartDate);
      }
    }
  }
}
