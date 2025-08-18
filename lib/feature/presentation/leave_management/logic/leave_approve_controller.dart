import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/src/config/customdialog/customdialog.dart';

class LeaveApproveController extends GetxController {
  final TextEditingController textController = TextEditingController();
  LeaveManagementRepository leaveManagementRepository =
      LeaveManagementRepository();
  RxBool isLoading = false.obs;

  Future<void> approveOrRejectLeave(
      String leaveID, int status, String message, BuildContext context) async {
    try {
      isLoading.value = true;
      final Map<String, dynamic> approveData = {
        'note': textController.text,
        'status': status
      };
      final response = await leaveManagementRepository.approveLeave(
          approveData, leaveID, status, context);
      await CustomDialog.show(
        context,
        message: "Cảm ơn, sếp đã duyệt ",
        subMessage: "Chúc sếp luôn vui vẻ, khỏe mạnh",
        icon: Icons.favorite,
        iconColor: Colors.blue,
        messageColor: Colors.green,
        duration: Duration(seconds: 2),
      );

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Bạn không có quyền duyệt')));
        Navigator.pop(context, false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Bạn không có quyền từ chối hoặc duyệt đơn xin nghỉ phép')),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
