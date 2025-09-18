import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';

/// Header section widget hiển thị thông tin chính của leave request
class LeaveRequestHeaderSection extends StatelessWidget {
  final LeaveID? leave;
  final Color Function(String?) getStatusColor;

  const LeaveRequestHeaderSection({
    Key? key,
    required this.leave,
    required this.getStatusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.r, 8.r, 20.r, 20.r),
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          _buildStatusBadge(),
          SizedBox(height: 20.h),

          // Employee Avatar & Info
          _buildEmployeeInfo(),
          SizedBox(height: 20.h),

          // Quick Stats
          _buildQuickStats(),
          SizedBox(height: 20.h),

          // Created Date
          _buildModernInfoRow(
            "Ngày tạo đơn",
            leave?.createdDate != null
                ? DateFormat('dd/MM/yyyy HH:mm').format(leave!.createdDate!)
                : '-------',
          ),

          // Date Range
          _buildDateRange(),
          SizedBox(height: 16.h),

          // Leave Details
          _buildModernInfoRow("Loại nghỉ phép", leave?.category ?? '-------'),
          _buildModernInfoRow("Lý do", leave?.reason ?? '-------'),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
          decoration: BoxDecoration(
            color: getStatusColor(leave?.statusLabel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: getStatusColor(leave?.statusLabel).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: getStatusColor(leave?.statusLabel),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                leave?.statusLabel ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: getStatusColor(leave?.statusLabel),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfo() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Icon(Icons.person, color: AppColors.primary, size: 28.sp),
        ),
        SizedBox(width: 16.w),

        // Employee Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${leave?.fullName ?? ''} - ${leave?.employeeCode ?? '-------'}",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              Text(
                leave?.jobTitle ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 2.h),
              Text(
                leave?.department ?? '',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStat(
            'Số ngày nghỉ',
            leave?.totalDay?.toString() ?? '0',
            Icons.calendar_today,
            Color(0xFF3B82F6),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildQuickStat(
            'Còn lại',
            leave?.leaveDaysLeft?.toString() ?? '0',
            Icons.schedule,
            Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildQuickStat(
            'Tổng quota',
            leave?.quota?.toString() ?? '0',
            Icons.assignment,
            Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(height: 6.h),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRange() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDateItem(
                  "Từ ngày",
                  leave?.fromDate != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(leave!.fromDate!)
                      : '-------',
                  Icons.play_arrow,
                  Color(0xFF3B82F6),
                ),
              ),
              Container(width: 1, height: 40.h, color: Color(0xFFE2E8F0)),
              Expanded(
                child: _buildDateItem(
                  "Đến ngày",
                  leave?.toDate != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(leave!.toDate!)
                      : '-------',
                  Icons.stop,
                  Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildModernInfoRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
