import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/attachment_widget.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/task_date.dart';
import 'package:tcs_flutter/common/widgets/widgets/tasks/task_note_section.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/filter_user_view.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_careate_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/buttom_leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_leave.dart';

class ListoffAddScreen extends StatefulWidget {
  const ListoffAddScreen({super.key});

  @override
  State<ListoffAddScreen> createState() => _ListoffAddScreenState();
}

class _ListoffAddScreenState extends State<ListoffAddScreen> {
  final controllerCreate = Get.put(LeaveCareateController());
  String? _selectedEmployeeName;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: "Tạo đơn xin nghỉ",
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controllerCreate.isloadingSave.value,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSelect(
                        label1: "Nhân viên",
                        name:
                            _selectedEmployeeName ??
                            controllerCreate
                                .controllerProfile
                                .profile
                                ?.user
                                ?.fullName,
                        searchable: false,
                        isEnabled: false,
                        selectedName:
                            _selectedEmployeeName ??
                            controllerCreate
                                .controllerProfile
                                .profile
                                ?.user
                                ?.fullName,
                        onTap: () async {
                          final result = await Get.to(() => FilterUserView());
                          if (result is Map) {
                            // Support both single and multi-select return shapes
                            final id =
                                (result['id'] ??
                                        (result['ids'] is List &&
                                                result['ids'].isNotEmpty
                                            ? result['ids'][0]
                                            : null))
                                    ?.toString();
                            final name =
                                (result['name'] ??
                                        (result['names'] is List &&
                                                result['names'].isNotEmpty
                                            ? result['names'][0]
                                            : null))
                                    ?.toString();
                            if (id != null && name != null) {
                              setState(() {
                                controllerCreate.updateEmployeeInfo(id, name);
                                _selectedEmployeeName = name;
                              });
                            }
                          }
                        },
                      ),
                      Obx(() {
                        final leaveList = controllerCreate.leaves.toList(
                          growable: false,
                        );
                        return ListoffLeave(
                          label1: "Loại nghỉ phép",
                          leaveList: leaveList,
                          onProjectSelected: (selectedUser) {
                            setState(() {
                              controllerCreate.categoryId = selectedUser?.id;
                            });
                          },
                        );
                      }),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: TaskDate(
                            colorIcon: AppColors.black,
                            label: 'Nghỉ từ ngày',
                            selectedDate: controllerCreate.fromDate.value,
                            onDateSelected: (date) {
                              // Sử dụng method mới để tự động cập nhật toDate
                              controllerCreate.updateStartDate(date);
                            },
                          ),
                        ),
                      ),
                      Obx(
                        () => TaskDate(
                          colorIcon: AppColors.black,
                          label: 'Đến ngày',
                          selectedDate: controllerCreate.toDate.value,
                          onDateSelected: (date) {
                            // Sử dụng method mới để tự động cập nhật fromDate nếu cần
                            controllerCreate.updateDueDate(date);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
                RepaintBoundary(
                  child: TaskNoteSection(
                    label: 'Lý do nghỉ phép',
                    note: 'Nhập lý do nghỉ phép...',
                    screenWidth: screenWidth,
                    controllerNote: controllerCreate.controllerNote,
                  ),
                ),
                16.verticalSpace,
                RepaintBoundary(
                  child: AttachmentWidget(
                    label: 'File đính kèm',
                    attachmentIds: controllerCreate.attachmentIds,
                    onAttachmentsChanged: (attachments) {
                      controllerCreate.attachmentIds = attachments;
                    },
                    onAttachmentFilesChanged: (files) {
                      controllerCreate.attachmentFiles = files;
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
                  ),
                ),
                30.verticalSpace,
                RepaintBoundary(child: ButtomLeave()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
