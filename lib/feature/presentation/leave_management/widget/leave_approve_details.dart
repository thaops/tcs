// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/common/widgets/widgets/tasks/text_tasks.dart';
import 'package:tcs_flutter/common/widgets/widgets/tasks/text_tasks_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveApproveDetails extends StatelessWidget {
  const LeaveApproveDetails({
    Key? key,
    required this.widget,
    required this.dateFormatD,
    required this.screenWidth,
  }) : super(key: key);
  final LeaveID widget;
  final DateFormat dateFormatD;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextTasksRow(
              text1: 'Nhân viên',
              text2: widget.fullName,
            ),
            const SizedBox(height: 20),
            TextTasksRow(
              text1: 'Ngày yêu cầu',
              text2: dateFormatD.format(widget.createdDate ?? DateTime.now()),
            ),
            const SizedBox(height: 20),
            TextTasksRow(
              text1: 'Số ngày nghỉ',
              text2: widget.totalDay.toString(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextTasks(
                    text1: 'Từ ngày',
                    text2: dateFormatD.format(widget.fromDate ?? DateTime.now()),
                    icon: Icons.calendar_month,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextTasks(
                    text1: 'Đến ngày',
                    text2: dateFormatD.format(widget.toDate ?? DateTime.now()),
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextTasksRow(
              text1: 'Trạng thái',
              text2: widget.statusLabel,
            ),
            const SizedBox(height: 20),
            TextTasks(
              text1: 'Lý do',
              text2: widget.reason,
            ),
          ],
        ),
      ),
    );
  }
}
