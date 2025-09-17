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
  const ListWidgets({Key? key, this.listOff, required this.onUpdateCallback})
    : super(key: key);

  @override
  State<ListWidgets> createState() => _ListWidgetsState();
}

class _ListWidgetsState extends State<ListWidgets> {
  final controllerUser = Get.put(FilterUserController());
  final DateFormat dateFormat = DateFormat("dd/MM");

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
        return Color.fromARGB(255, 158, 158, 4); // Vàng
      case 'Đã duyệt':
        return Colors.green;
      case 'Chờ xử lý':
        return Colors.grey;
      case 'Từ chối':
        return pending;
      case '1': // Trạng thái số
        return Color.fromARGB(255, 158, 158, 4); // Vàng cho "Đang xử lý"
      case '2': // Trạng thái số
        return Colors.green; // Xanh cho "Đã duyệt"
      case '3': // Trạng thái số
        return pending; // Đỏ cho "Từ chối"
      default:
        return Colors.black;
    }
  }

  Widget _buildEmployeeItem(Employee employee) {
    // Hiển thị trực tiếp từ Employee (đã convert từ LeaveRequest)
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRouter.leaveDetail,
          arguments: {'leaveId': employee.id},
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
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: employee.fullName ?? 'Không có tên',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            maxLines: 2,
                          ),
                          10.verticalSpace,
                          TextWidget(
                            text:
                                employee.fromDate != null &&
                                        employee.toDate != null
                                    ? 'Ngày: ${dateFormat.format(employee.fromDate!)} - ${dateFormat.format(employee.toDate!)}'
                                    : 'Không có ngày',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text:
                                'Lý do: ${employee.reason ?? 'Không có lý do'}',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey[600],
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Số ngày: ${employee.totalDay ?? 0} ngày',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue[600],
                          ),
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
                      maxLines: 2,
                      text:
                          employee.departmentName ?? employee.department ?? '',
                    ),
                    8.verticalSpace,
                    // Hiển thị trạng thái với màu sắc phù hợp
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          employee.statusLabel,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(employee.statusLabel),
                          width: 1,
                        ),
                      ),
                      child: TextWidget(
                        text: employee.statusLabel ?? 'Không xác định',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(employee.statusLabel),
                      ),
                    ),
                    8.verticalSpace,
                    // Hiển thị loại nghỉ phép
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue, width: 1),
                      ),
                      child: TextWidget(
                        text: employee.category ?? 'Nghỉ phép',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
