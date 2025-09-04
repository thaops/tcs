import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approver_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approval_list_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/repositories/leave_management_repository.dart';
import 'package:tcs_flutter/src/config/customdialog/customdialog.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/repositories/leave_repository_interface.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/domain/usecases/approve_leave_usecase.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/add.leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/approve_req.dart';

class LeaveApproveController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final LeaveRepositoryInterface leaveManagementRepository;
  late final ApproveLeaveUseCase _approveLeave;
  LeaveApproveController({LeaveRepositoryInterface? repo})
    : leaveManagementRepository = repo ?? LeaveManagementRepository() {
    _approveLeave = ApproveLeaveUseCase(leaveManagementRepository);
  }
  RxBool isLoading = false.obs;

  Future<void> approveOrRejectLeave(
    String leaveID,
    String categoryId,
    int status,
    String message,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      final ApproveReq approveReq = ApproveReq(
        categoryId: categoryId,
        status: status,
        note: textController.text,
      );
      final AddDayOffResponseModel response = await _approveLeave(
        approveReq.toJson(),
        leaveID,
        status,
        context,
      );
      print("response: ${response.data}");
      await CustomDialog.show(
        context,
        message: message,
        subMessage: "Chúc sếp luôn vui vẻ, khỏe mạnh",
        icon: Icons.favorite,
        iconColor: Colors.blue,
        messageColor: Colors.green,
        duration: Duration(seconds: 3),
      );

      if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
        await Future.delayed(Duration(seconds: 3));
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
        Navigator.pop(context, false);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Approver>> getListApprover(int? step, String? keyword) {
    return leaveManagementRepository.getListApprover(step, keyword);
  }

  // Method mới để gọi API get-list-approval-by
  Future<List<ApprovalData>> getListApprovalByUser(String leaveOffId) {
    return (leaveManagementRepository as LeaveManagementRepository)
        .getListApprovalByUser(leaveOffId);
  }
}
