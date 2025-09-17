import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_list_workflow.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';

/// Workflow card widget hiển thị quy trình duyệt
class LeaveRequestWorkflowCard extends StatelessWidget {
  final List<WorkFlow>? workflows;

  const LeaveRequestWorkflowCard({Key? key, required this.workflows})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            WorkflowList(workflows: workflows ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.account_tree,
            color: Color(0xFFF59E0B),
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          "Quy trình duyệt",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
          decoration: BoxDecoration(
            color: Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "${workflows?.length ?? 0} bước",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    );
  }
}
