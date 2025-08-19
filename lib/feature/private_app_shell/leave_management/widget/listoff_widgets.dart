// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/api/models/employee_model.dart';
import 'package:tcs_flutter/src/config/constants/color/colors.dart';

class ListWidgets extends StatefulWidget {
  final listOff;
  final Function(bool) onUpdateCallback;
  const ListWidgets({
    Key? key,
    this.listOff,
    required this.onUpdateCallback,
  }) : super(key: key);

  @override
  State<ListWidgets> createState() => _ListWidgetsState();
}

class _ListWidgetsState extends State<ListWidgets> {
  final controllerUser = Get.put(FilterUserController());
  final DateFormat dateFormat = DateFormat("dd/MM");
  String avatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        cacheExtent: 2000.0,
        itemCount: widget.listOff!.length,
        itemBuilder: (context, index) {
          final employee = widget.listOff![index];
          return RepaintBoundary(child: _buildEmployeeItem(employee));
        },
      ),
    );
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

  Widget _buildEmployeeItem(Employee employee) {
    final titleColor = _getStatusColor(employee.statusLabel);
    return GestureDetector(
      onTap: () {
       Get.toNamed(
        AppRouter.leaveDetail,
        arguments: {
          'leaveId': employee.id,
        },
      )?.then((value) {
        if (value == true) {
          widget.onUpdateCallback(true);
        }
      });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: employee.fullName ?? 'Không lý do',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            maxLines: 2,
                          ),
                          10.verticalSpace,
                          TextWidget(
                            text:
                                'Ngày: ${dateFormat.format(employee.fromDate!)} - ${dateFormat.format(employee.toDate!)}',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextWidget(
                        fontSize: 12,
                        color: AppColors.darkBackground.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                        text: (() {
                          final fromController = controllerUser.departmentNameForEmployee(employee.employeeId);
                          final dep = fromController ?? employee.department;
                          if (dep == null || dep.trim().isEmpty) return 'Chưa phòng';
                          return dep.trim();
                        })()),
                    16.verticalSpace,
                    Text(
                      employee.statusLabel ?? 'Chưa có thông tin',
                      style: TextStyle(color: titleColor, fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
