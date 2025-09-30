// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_request_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_list_controller.dart';

class ListWidgets extends StatefulWidget {
  final listOff;
  final Function(bool) onUpdateCallback;
  final DateTime? firstDay;
  final DateTime? lastDay;
  const ListWidgets({
    Key? key,
    this.listOff,
    required this.onUpdateCallback,
    this.firstDay,
    this.lastDay,
  }) : super(key: key);

  @override
  State<ListWidgets> createState() => _ListWidgetsState();
}

class _ListWidgetsState extends State<ListWidgets> {
  final controllerUser = Get.put(FilterUserController());
  final listController = Get.find<LeaveListController>();
  final DateFormat dateFormat = DateFormat("dd/MM");
  final DateFormat timeFormat = DateFormat("HH:mm");
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
  
      if (widget.firstDay != null &&
          widget.lastDay != null &&
          !listController.isLoadingMore.value &&
          listController.hasMore.value) {
        listController.loadMore(widget.firstDay!, widget.lastDay!);
      }
    }
  }

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
        controller: _scrollController,
        cacheExtent: 2000.0,
        itemCount:
            widget.listOff!.length +
            (listController.isLoadingMore.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.listOff!.length) {
            return Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final leave = widget.listOff![index];
          return RepaintBoundary(child: _buildEmployeeItem(leave));
        },
      ),
    );
  }

  Color _getStatusColor(String? statusLabel) {
    if (statusLabel == null || statusLabel.isEmpty) {
      return Colors.grey;
    }

    switch (statusLabel.toLowerCase().trim()) {
      case 'đang xử lý':
      case 'đơn cần duyệt':
        return Color(0xFFD97706); // Vàng đậm
      case 'đã duyệt':
        return Color(0xFF059669); // Xanh lá đậm
      case 'chờ xử lý':
      case 'chờ duyệt':
        return Color(0xFFEA580C); // Cam đậm
      case 'chờ huỷ đơn':
        return Color.fromARGB(255, 237, 192, 58); // Tím đậm
      case 'từ chối':
        return Color(0xFFDC2626); // Đỏ đậm
      case 'hủy đơn':
        return Color(0xFFB91C1C); // Đỏ đậm hơn
      case '1': // Trạng thái số - Đơn cần duyệt
        return Color(0xFFD97706); // Vàng đậm
      case '2': // Trạng thái số - Đã duyệt
        return Color(0xFF059669); // Xanh lá đậm
      case '3': // Trạng thái số - Từ chối
        return Color(0xFFDC2626); // Đỏ đậm
      case '4': // Trạng thái số - Hủy đơn
        return Color(0xFFB91C1C); // Đỏ đậm hơn
      case '99': // Trạng thái số - Chờ hủy đơn
        return Color(0xFF7C3AED); // Tím đậm
      default:
        return Color(0xFF374151); // Xám đậm
    }
  }

  String _getStatusDisplayText(String? statusLabel) {
    if (statusLabel == null || statusLabel.isEmpty) {
      return 'Không xác định';
    }

    // Handle numeric status
    switch (statusLabel) {
      case '1':
        return 'Đơn cần duyệt';
      case '2':
        return 'Đã duyệt';
      case '3':
        return 'Từ chối';
      case '4':
        return 'Hủy đơn';
      case '99':
        return 'Chờ hủy đơn';
      default:
        return statusLabel;
    }
  }

  Widget _buildEmployeeItem(LeaveRequest leave) {
    // Hiển thị trực tiếp từ LeaveRequest
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRouter.leaveDetail,
          arguments: {'leaveId': leave.id},
        )?.then((value) {
          debugPrint('Detail screen returned with value: $value');
          if (value == true) {
            debugPrint('Calling onUpdateCallback(true) to reload list');
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
                            text: leave.fullName ?? '',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            maxLines: 2,
                          ),
                          10.verticalSpace,

                          TextWidget(
                            text: leave.departmentName ?? '',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: _formatDateRange(
                              leave.fromDate,
                              leave.toDate,
                            ),
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Loại: ${leave.category ?? ''}',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Lý do: ${leave.reason ?? ''}',
                            fontSize: 12.0.sp,
                            fontWeight: FontWeight.w400,
                            maxLines: 1,
                          ),
                          5.verticalSpace,
                          TextWidget(
                            text: 'Số ngày: ${leave.totalDay ?? 0} ngày',
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
                        color: _getStatusColor(leave.statusName),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextWidget(
                        text: _getStatusDisplayText(leave.statusName),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
