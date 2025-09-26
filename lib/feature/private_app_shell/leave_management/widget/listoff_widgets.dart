// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
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
  final DateFormat timeFormat = DateFormat("HH:mm");

  String _formatDateRange(DateTime? fromDate, DateTime? toDate) {
    if (fromDate == null || toDate == null) {
      return 'Không có ngày';
    }

    final fromDay = fromDate.day;
    final fromMonth = fromDate.month;
    final fromYear = fromDate.year;
    final fromTime = timeFormat.format(fromDate);

    final toDay = toDate.day;
    final toMonth = toDate.month;
    final toYear = toDate.year;
    final toTime = timeFormat.format(toDate);

    // Cùng 1 ngày
    if (fromDay == toDay && fromMonth == toMonth && fromYear == toYear) {
      return 'Ngày: ${fromDay.toString().padLeft(2, '0')}/${fromMonth.toString().padLeft(2, '0')}/$fromYear ($fromTime - $toTime)';
    }

    // Cùng 1 năm
    if (fromYear == toYear) {
      return 'Ngày: ${fromDay.toString().padLeft(2, '0')}/${fromMonth.toString().padLeft(2, '0')} - ${toDay.toString().padLeft(2, '0')}/${toMonth.toString().padLeft(2, '0')}/$fromYear ($fromTime - $toTime)';
    }

    // Khác năm
    return 'Ngày: ${fromDay.toString().padLeft(2, '0')}/${fromMonth.toString().padLeft(2, '0')}/$fromYear - ${toDay.toString().padLeft(2, '0')}/${toMonth.toString().padLeft(2, '0')}/$toYear ($fromTime - $toTime)';
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            text: employee.fullName ?? '',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            maxLines: 2,
                          ),
                          10.verticalSpace,

                          TextWidget(
                            text:
                                employee.departmentName ??
                                employee.department ??
                                '',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: _formatDateRange(
                              employee.fromDate,
                              employee.toDate,
                            ),
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Loại: ${employee.category ?? ''}',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Lý do: ${employee.reason ?? ''}',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Số ngày: ${employee.totalDay ?? 0} ngày',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
                        text:
                            employee.statusLabel == "Không xác định"
                                ? "Chờ huỷ đơn"
                                : employee.statusLabel ?? '',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(employee.statusLabel),
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
