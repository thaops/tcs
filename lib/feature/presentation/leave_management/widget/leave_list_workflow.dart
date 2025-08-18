import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/widget/leave_text_row.dart';
import 'package:tcs_flutter/src/config/constants/color/colors.dart';

class WorkflowList extends StatelessWidget {
  final List<WorkFlow> workflows;
  final String avatar;

  const WorkflowList({
    Key? key,
    required this.workflows,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllerUser = Get.put(FilterUserController());
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    if (workflows.isEmpty) {
      return Center(child: Text('Không có quy trình nào.'));
    }

    List<Widget> workflowWidgets = workflows.map((workflow) {
      Color titleColor = _getStatusColor(workflow.statusLabel);
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: titleColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  imageUrl: controllerUser.userList.value
                          .firstWhereOrNull(
                              (user) => user.id == workflow.approverId)
                          ?.avatarUrl ??
                      avatar,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: LeaveTextRow(
                            name: workflow.approver,
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: TextWidget(
                            text: "${workflow.statusLabel}",
                            color: titleColor,
                            textAlign: TextAlign.right,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 6),
                    LeaveTextRow(
                      name: workflow.approvalDate != null
                          ? dateFormat.format(workflow.approvalDate!)
                          : '--',
                    ),
                    SizedBox(height: 6),
                    LeaveTextRow(
                      mission: "Ghi chú:",
                      name: " ${workflow.note ?? '--'}",
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: workflowWidgets,
      ),
    );
  }
}

Color _getStatusColor(String? statusLabel) {
  switch (statusLabel) {
    case 'Đang xử lý':
      return Color.fromARGB(255, 158, 158, 4);
    case 'Đã duyệt':
      return Colors.green;
    case 'Chờ xử lý':
      return Colors.grey;
    case 'Từ chối':
      return pending;
    default:
      return Colors.black;
  }
}
