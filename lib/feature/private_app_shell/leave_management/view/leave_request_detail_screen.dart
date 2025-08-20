import 'package:get/get.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/custom_dialog.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_approve_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/custom_detail_leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_button_browse.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/data/models/leave_id.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_update.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/leave_list_workflow.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListoffDetail extends StatefulWidget {
  const ListoffDetail({Key? key}) : super(key: key);

  @override
  State<ListoffDetail> createState() => _ListoffDetailState();
}

class _ListoffDetailState extends State<ListoffDetail> {
  String? leaveId;
  late final LeaveLogic leaveLogic;
  late final LeaveApproveController controllerApprove;
  String? myId; 
  RxBool isshouldShowApproveButtons = false.obs;

  LeaveID? _leave;
  bool isLoading = false;
  String avatar =
      'https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png';

  @override
  void initState() {
    super.initState();
    leaveLogic = Get.put(LeaveLogic());
    controllerApprove = Get.put(LeaveApproveController());
    
    final arguments = Get.arguments;

    leaveId = arguments != null ? arguments['leaveId'] as String? : null;
    debugPrint('ListoffDetail initialized with leaveId: $leaveId');
    if (leaveId != null){
      getLeaveID(leaveId!, context);
      _loadMyId();
      // Recompute approve buttons after data loads.
    } else {
      debugPrint('No leaveId provided, showing error');
    }
  }

  Future<void> _loadMyId() async {
    try {
      final create = await MyId.create();
      final id = await create.getMyId();
      // controllerApprove.getListApprover(null, null);
      if (!mounted) return;
      
      setState(() {
        myId = id;
      });
      // If leave is available, recompute approve buttons visibility.
      if (_leave != null) {
        final show = await _shouldShowApproveButtons;
        if (mounted) {
          isshouldShowApproveButtons.value = show;
        }
      }
    } catch (e) {
      debugPrint('Failed to load myId: $e');
    }
  }

  void _updateScreen() {
    Get.toNamed(
      AppRouter.leaveUpdate,
      arguments: LeaveUpdateData(leave: _leave),
    )?.then((value) {
      if (value == true) {
        getLeaveID(leaveId!, context);
      }
    });
  }

  Future<LeaveID?> getLeaveID(String leaveId, BuildContext context) async {
    LeaveID? result;
    try {
      setState(() {
        isLoading = true;
      });
      result = await leaveLogic.getLeave(leaveId, context);
      if (result != null) {
        setState(() {
          _leave = result;
        });
        // If myId is available, recompute approve buttons visibility.
        if (myId != null) {
          final show = await _shouldShowApproveButtons;
          if (mounted) {
            isshouldShowApproveButtons.value = show;
          }
        }
      } else {
        // ignore: avoid_print
        print('Failed to load task');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return result;
  }

  Future<bool> get _shouldShowApproveButtons async{
    if (_leave == null || myId == null) return false;
    final bool isApproved = (_leave!.status == 2) || (_leave!.statusLabel == 'Đã duyệt');
    if (isApproved) return false;
    final String currentId = myId!;
    try {
      final approvers = await controllerApprove.getListApprover(null, null);
      return approvers.any((wf) => wf.id == currentId);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveLogic = this.leaveLogic;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateFormat dateFormatD = DateFormat('dd-MM-yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: TextWidget(
          text: "Thông tin chi tiết",
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_sharp, color: AppColors.primary),
            onPressed: () => _updateScreen(),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => leaveLogic.deleteLeave(leaveId!, context),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: isLoading,

        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                applicationDetails(dateFormatD, screenWidth),
                TextWidget(
                  text: "Duyệt Đơn",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
                SizedBox(height: 8),
                WorkflowList(
                  workflows: _leave?.workFlows ?? [],
                  avatar: avatar,
                ),
                Obx(() => isshouldShowApproveButtons.value
                    ? _buildLeaveButtonBrowse(context)
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LeaveButtonBrowse _buildLeaveButtonBrowse(BuildContext context) {
    return LeaveButtonBrowse(
      approver_on: () async {
        CustomDialog()
            .showConfirmationDialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: "Ý kiến lãnh đạo",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    paddingVertical: 10,
                    textAlign: TextAlign.start,
                  ),
                  CustomTextField(
                    controller: controllerApprove.textController,
                    hintText: "Nội dung",
                    maxLines: 5,
                  ),
                ],
              ),
            )
            .then((value) async {
              if (value == true) {
                await controllerApprove.approveOrRejectLeave(
                  _leave!.id.toString(),
                  2,
                  "Cảm ơn, Xếp đã duyệt đơn nghỉ phép!",
                  context,
                );
              }
            });
      },
      approver_off: () async {
        CustomDialog()
            .showConfirmationDialog(
              child: Column(
                children: [TextWidget(text: "Từ chối đơn xin nghĩ phép")],
              ),
            )
            .then((value) async {
              if (value == true) {
                await controllerApprove.approveOrRejectLeave(
                  _leave!.id.toString(),
                  3,
                  "Chân thành cảm ơn, Xếp đã từ chối đơn nghỉ phép",
                  context,
                );
              }
            });
      },
    );
  }

  Padding applicationDetails(DateFormat dateFormatD, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDetailLeave(title: 'Nhân viên', content: _leave?.fullName ?? '-------'),
          CustomDetailLeave(title: 'Phòng ban', content: _leave?.department ?? '-------'),
          CustomDetailLeave(
            paddingVertical: 8,
            title: 'Ngày yêu cầu',
            content: _leave?.createdDate != null
                ? dateFormatD.format(_leave!.createdDate!)
                : '-------',
          ),
          CustomDetailLeave(
            title: 'Số ngày nghỉ',
            content: (_leave != null && _leave!.totalDay != null)
                ? _leave!.totalDay.toString()
                : '-------',
          ),
          Container(
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomDetailLeave(
                    title: 'Từ ngày',
                    content: _leave?.fromDate != null
                        ? dateFormatD.format(_leave!.fromDate!)
                        : '-------',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomDetailLeave(
                      isShowicon: false,
                      title: 'Đến ngày',
                      content: _leave?.toDate != null
                          ? dateFormatD.format(_leave!.toDate!)
                          : '-------',
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomDetailLeave(
            title: 'Trạng thái',
            content: _leave?.statusLabel,
            paddingVertical: 8,
            colorText: _getStatusColor(_leave?.statusLabel),
          ),
          CustomDetailLeave(
            title: 'Lý do',
            content: (_leave?.category?.isNotEmpty ?? false)
                ? _leave!.category
                : '-------',
          ),
          CustomDetailLeave(
            title: 'Ghi chú',
            content: (_leave?.reason?.isNotEmpty ?? false)
                ? _leave!.reason
                : '-------',
          ),
        ],
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
      default:
        return Colors.black;
    }
  }
}
