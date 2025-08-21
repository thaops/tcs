import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListoffLeave extends StatefulWidget {
  final String label1;
  final String? name;
  final List<LeaveType>? leaveList;
  final void Function(LeaveType?)? onProjectSelected;

  ListoffLeave({
    Key? key,
    required this.label1,
    this.name,
    this.leaveList,
    this.onProjectSelected,
  }) : super(key: key);

  @override
  State<ListoffLeave> createState() => _ListoffLeaveState();
}

class _ListoffLeaveState extends State<ListoffLeave> {
  LeaveType? _selectedUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: widget.label1,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
                ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            width: screenWidth,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonFormField<LeaveType>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
              ),
              isExpanded: true,
              value: _selectedUser,
              hint: TextWidget(text: widget.name ?? 'Lý do',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black.withOpacity(0.8)),
              onChanged: (LeaveType? newValue) {
                setState(() {
                  _selectedUser = newValue;
                  if (widget.onProjectSelected != null) {
                    widget.onProjectSelected!(newValue);
                  }
                });
              },
              items: widget.leaveList?.map((LeaveType user) {
                    return DropdownMenuItem<LeaveType>(
                      value: user,
                      child: TextWidget(
                        text: user.name,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ],
      ),
    );
  }
}
