import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/attachment_widget.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/task_date.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_update_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_leave.dart';
import 'package:tcs_flutter/common/widgets/widgets/tasks/task_note_section.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveRequestUpdateScreen extends StatefulWidget {
  const LeaveRequestUpdateScreen({super.key});

  @override
  State<LeaveRequestUpdateScreen> createState() =>
      _LeaveRequestUpdateScreenState();
}

class _LeaveRequestUpdateScreenState extends State<LeaveRequestUpdateScreen> {
  final controllerUpdate = Get.put(LeaveUpdateController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar_create(context),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controllerUpdate.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [fill_create(screenWidth, controllerUpdate.canEdit)],
            ),
          ),
        ),
      ),
    );
  }

  Row button_seve(double screenWidth, BuildContext context, bool canEdit) {
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextWidget(
                  text: "Huỷ",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        if (canEdit) 20.horizontalSpace,
        if (canEdit)
          Flexible(
            child: Obx(
              () => GestureDetector(
                onTap:
                    controllerUpdate.isLoading.value
                        ? null
                        : () async {
                          await controllerUpdate.leaveUpdate(context);
                        },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:
                        controllerUpdate.isLoading.value
                            ? Colors.grey.shade400
                            : AppColors.primary,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        controllerUpdate.isLoading.value
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                TextWidget(
                                  text: "Đang cập nhật...",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                  color: Colors.white,
                                ),
                              ],
                            )
                            : TextWidget(
                              text: "Cập nhật",
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              color: Colors.white,
                            ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Expanded fill_create(double screenWidth, bool canEdit) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Opacity(
              opacity: 0.6,
              child: AbsorbPointer(
                absorbing: true,
                child: CustomSelect(
                  label1: "Nhân viên",
                  name: controllerUpdate.leave.value?.fullName,
                  selectList:
                      controllerUpdate.users!
                          .map(
                            (e) => Item(
                              id: e.id.toString(),
                              name: e.fullName.toString(),
                            ),
                          )
                          .toList(),
                  isEnabled: false,
                  onProjectSelected: (value) {
                    controllerUpdate.usersID = value;
                  },
                ),
              ),
            ),
            Opacity(
              opacity: canEdit ? 1.0 : 0.6,
              child: AbsorbPointer(
                absorbing: !canEdit,
                child: ListoffLeave(
                  label1: "Lý do ",
                  leaveList: controllerUpdate.leaves,
                  name:
                      controllerUpdate.leaves
                          ?.firstWhere(
                            (leaveType) =>
                                leaveType.id ==
                                controllerUpdate.leave.value?.categoryId,
                            orElse:
                                () => LeaveType(id: "1", name: 'Default Name'),
                          )
                          .name,
                  onProjectSelected: (selectedUser) {
                    setState(() {
                      controllerUpdate.leaveID = selectedUser!.id;
                    });
                  },
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: TaskDate(
                  colorIcon: AppColors.black,
                  label: 'Nghỉ từ ngày',
                  selectedDate:
                      controllerUpdate.startDate.value ?? DateTime.now(),
                  isEnabled: canEdit,
                  onDateSelected: (date) {
                    controllerUpdate.startDate.value =
                        date; // Cập nhật ngày bắt đầu
                  },
                ),
              ),
            ),
            Obx(
              () => TaskDate(
                colorIcon: AppColors.black,
                label: 'Đến ngày',
                selectedDate: controllerUpdate.dueDate.value ?? DateTime.now(),
                isEnabled: canEdit,
                onDateSelected: (date) {
                  controllerUpdate.dueDate.value = date; // Cập nhật ngày hạn
                },
              ),
            ),
            8.verticalSpace,
            Opacity(
              opacity: canEdit ? 1.0 : 0.6,
              child: AbsorbPointer(
                absorbing: !canEdit,
                child: TaskNoteSection(
                  label: 'Lý do nghỉ phép',
                  note: 'Nhập lý do nghỉ phép...',
                  screenWidth: screenWidth,
                  controllerNote: controllerUpdate.controllerNote,
                  isEnabled: canEdit,
                ),
              ),
            ),
            16.verticalSpace,
            Opacity(
              opacity: canEdit ? 1.0 : 0.6,
              child: AbsorbPointer(
                absorbing: !canEdit,
                child: AttachmentWidget(
                  label: 'File đính kèm',
                  attachmentIds: controllerUpdate.attachmentIds,
                  existingAttachmentFiles: controllerUpdate.attachmentFiles,
                  onAttachmentsChanged: (attachments) {
                    controllerUpdate.attachmentIds = attachments;
                  },
                  onAttachmentFilesChanged: (files) {
                    controllerUpdate.attachmentFiles = files;
                  },
                  onAttachmentDeleted: (attachmentId) {
                    // Thêm ID vào danh sách file bị xóa
                    if (!controllerUpdate.deletedAttachmentIds.contains(
                      attachmentId,
                    )) {
                      controllerUpdate.deletedAttachmentIds.add(attachmentId);
                    }
                  },
                  maxFiles: 3,
                  allowedExtensions: [
                    'pdf',
                    'doc',
                    'docx',
                    'jpg',
                    'jpeg',
                    'png',
                  ],
                  isEnabled: canEdit,
                ),
              ),
            ),
            30.verticalSpace,
            button_seve(screenWidth, context, canEdit),
          ],
        ),
      ),
    );
  }

  AppBar appBar_create(BuildContext context) {
    return AppBar(
      title: TextWidget(
        text: "Cập nhật đơn xin nghỉ",
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
