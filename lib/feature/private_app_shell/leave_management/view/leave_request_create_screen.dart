import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/task_date.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/logic/leave_careate_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/buttom_leave.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/widget/listoff_leave.dart';
import 'package:tcs_flutter/common/widgets/widgets/tasks/task_note_section.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/filter_user_view.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: appBar_create(context),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controllerCreate.isloadingSave.value,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                fill_create(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded fill_create(double screenWidth) {
    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: SizedBox(
            height: Get.height * 0.9,
            child: Column(
              children: [
                CustomSelect(
                  label1: "Nhân viên",
                  name: _selectedEmployeeName ?? controllerCreate.controllerProfile.profile?.user?.fullName,
                  searchable: false,
                  selectedName: _selectedEmployeeName ?? controllerCreate.controllerProfile.profile?.user?.fullName,
                  onTap: () async {
                    final result = await Get.to(() => FilterUserView());
                    if (result is Map) {
                      // Support both single and multi-select return shapes
                      final id = (result['id'] ?? (result['ids'] is List && result['ids'].isNotEmpty ? result['ids'][0] : null))?.toString();
                      final name = (result['name'] ?? (result['names'] is List && result['names'].isNotEmpty ? result['names'][0] : null))?.toString();
                      if (id != null && name != null) {
                        setState(() {
                          controllerCreate.usersID = id;
                          _selectedEmployeeName = name;
                        });
                      }
                    }
                  },
                ),
                Obx(() {
                  final leaveList = controllerCreate.leaves.toList(growable: false);
                  return ListoffLeave(
                    label1: "Lý do",
                    leaveList: leaveList,
                    onProjectSelected: (selectedUser) {
                      setState(() {
                        controllerCreate.leaveID = selectedUser?.id;
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
                      selectedDate: controllerCreate.startDate.value,
                      onDateSelected: (date) {
                        controllerCreate.startDate.value =
                            date; 
                      },
                    ),
                  ),
                ),
                Obx(
                  () => TaskDate(
                    colorIcon: AppColors.black,
                    label: 'Đến ngày',
                    selectedDate: controllerCreate.dueDate.value,
                    onDateSelected: (date) {
                      controllerCreate.dueDate.value =
                          date; // Cập nhật ngày hạn
                    },
                  ),
                ),
                8.verticalSpace,
                TaskNoteSection(
                  label: 'Ghi chú',
                  note: '',
                  screenWidth: screenWidth,
                  controllerNote: controllerCreate.controllerNote,
                ),
                30.verticalSpace,
                ButtomLeave(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar_create(BuildContext context) {
    return AppBar(
      title: TextWidget(
        text: "Tạo đơn xin nghỉ",
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
