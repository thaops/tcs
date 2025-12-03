import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_request_model.dart';
import 'package:tcs_flutter/router/app_router.dart';

class LeaveStatisticsCard extends StatelessWidget {
  final LeaveRequest leave;
  final bool showDateTime; // true cho tab "Sắp tới", false cho tab "Hôm nay"

  const LeaveStatisticsCard({
    Key? key,
    required this.leave,
    this.showDateTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRouter.leaveDetail, arguments: {'leaveId': leave.id});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mã nhân viên - Họ tên
            Row(
              children: [
                Expanded(
                  child: TextWidget(
                    text: ' ${leave.fullName ?? 'N/A'}',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Vị trí công tác (Đội/Phòng)
            if (leave.departmentName != null || leave.unitName != null)
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: AppColors.colortextGray,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextWidget(
                      text: _getWorkLocation(),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.colortextGray,
                    ),
                  ),
                ],
              ),

            // Ngày/giờ nghỉ (chỉ hiển thị cho tab "Sắp tới")
            if (showDateTime &&
                leave.fromDate != null &&
                leave.toDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.colortextGray,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextWidget(
                      text: _formatDateTimeRange(),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.colortextGray,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),

            // Số ngày nghỉ
            Row(
              children: [
                Icon(Icons.event_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                TextWidget(
                  text: '${leave.totalDay ?? 0} ngày nghỉ',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWorkLocation() {
    final parts = <String>[];
    if (leave.unitName != null && leave.unitName!.isNotEmpty) {
      parts.add(leave.unitName!);
    }
    if (leave.departmentName != null && leave.departmentName!.isNotEmpty) {
      parts.add(leave.departmentName!);
    }
    return parts.isEmpty ? 'N/A' : parts.join(' / ');
  }

  String _formatDateTimeRange() {
    if (leave.fromDate == null || leave.toDate == null) {
      return 'N/A';
    }

    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    final fromDateStr = dateFormat.format(leave.fromDate!);
    final fromTimeStr = timeFormat.format(leave.fromDate!);

    // Kiểm tra xem có phải cùng ngày không
    final isSameDay =
        leave.fromDate!.year == leave.toDate!.year &&
        leave.fromDate!.month == leave.toDate!.month &&
        leave.fromDate!.day == leave.toDate!.day;

    if (isSameDay) {
      // Cùng ngày: 31/07/2025 – 08:00–17:30
      final toTimeStr = timeFormat.format(leave.toDate!);
      return '$fromDateStr – $fromTimeStr–$toTimeStr';
    } else {
      // Khác ngày: 31/07/2025 08:00 – 02/08/2025 17:30
      final toDateStr = dateFormat.format(leave.toDate!);
      final toTimeStr = timeFormat.format(leave.toDate!);
      return '$fromDateStr $fromTimeStr – $toDateStr $toTimeStr';
    }
  }
}
