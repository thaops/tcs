import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/logic/notification_controller.dart';

class NotificationFilterOption {
  final NotificationStatus? status;
  final ReadStatus? readStatus;
  final String label;

  NotificationFilterOption({this.status, this.readStatus, required this.label});
}

class NotificationFilterDialog extends StatefulWidget {
  const NotificationFilterDialog({Key? key}) : super(key: key);

  @override
  State<NotificationFilterDialog> createState() =>
      _NotificationFilterDialogState();
}

class _NotificationFilterDialogState extends State<NotificationFilterDialog> {
  late NotificationController controller;
  late ReadStatus _tempReadStatus;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationController>();
    _tempReadStatus = controller.selectedReadStatus.value;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Lấy danh sách trạng thái đọc
  List<NotificationFilterOption> _getReadStatusOptions() {
    return [
      NotificationFilterOption(
        readStatus: ReadStatus.read,
        label: NotificationUtils.getReadStatusDisplayName(ReadStatus.read),
      ),
      NotificationFilterOption(
        readStatus: ReadStatus.unread,
        label: NotificationUtils.getReadStatusDisplayName(ReadStatus.unread),
      ),
    ];
  }

  // Hiển thị picker cho trạng thái đọc
  void _showReadStatusPicker() {
    final options = _getReadStatusOptions();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _buildPickerSheet(
            title: 'Chọn trạng thái',
            options: options,
            isStatusPicker: false,
            currentReadStatus: _tempReadStatus,
            onSelectedReadStatus: (readStatus) {
              if (mounted && !_isDisposed) {
                setState(() {
                  _tempReadStatus = readStatus ?? ReadStatus.all;
                });
              }
            },
          ),
    );
  }

  Widget _buildPickerSheet({
    required String title,
    required List<NotificationFilterOption> options,
    required bool isStatusPicker,
    NotificationStatus? currentStatus,
    ReadStatus? currentReadStatus,
    Function(NotificationStatus?)? onSelected,
    Function(ReadStatus?)? onSelectedReadStatus,
  }) {
    final primaryColor = AppColors.primary;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF757575),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),

          // Danh sách options
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length + 1, // +1 for "Tất cả" option
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // "Tất cả" option
                    final isSelected =
                        isStatusPicker
                            ? (currentStatus == null ||
                                currentStatus == NotificationStatus.all)
                            : (currentReadStatus == null ||
                                currentReadStatus == ReadStatus.all);

                    return ListTile(
                      title: Text(
                        'Tất cả',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? primaryColor : Colors.black87,
                        ),
                      ),
                      trailing:
                          isSelected
                              ? Icon(Icons.check, color: primaryColor, size: 20)
                              : null,
                      selected: isSelected,
                      selectedTileColor: primaryColor.withOpacity(0.1),
                      onTap: () {
                        if (isStatusPicker) {
                          onSelected?.call(NotificationStatus.all);
                        } else {
                          onSelectedReadStatus?.call(ReadStatus.all);
                        }
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                    );
                  }

                  final option = options[index - 1];
                  final isSelected =
                      isStatusPicker
                          ? (currentStatus == option.status)
                          : (currentReadStatus == option.readStatus);

                  return ListTile(
                    title: Text(
                      option.label,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? primaryColor : Colors.black87,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? Icon(Icons.check, color: primaryColor, size: 20)
                            : null,
                    selected: isSelected,
                    selectedTileColor: primaryColor.withOpacity(0.1),
                    onTap: () {
                      if (isStatusPicker) {
                        onSelected?.call(option.status);
                      } else {
                        onSelectedReadStatus?.call(option.readStatus);
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget field filter
  Widget _buildFilterField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF424242),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF757575),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Lấy giá trị hiển thị cho trạng thái đọc
  String _getReadStatusDisplayValue() {
    if (_tempReadStatus == ReadStatus.all) return 'Tất cả';
    return NotificationUtils.getReadStatusDisplayName(_tempReadStatus);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header với tiêu đề và nút đóng
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Bộ lọc',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF757575),
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),

          // Nội dung filter
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trường: Trạng thái đọc
                _buildFilterField(
                  label: 'Trạng thái',
                  value: _getReadStatusDisplayValue(),
                  onTap: _showReadStatusPicker,
                ),

                SizedBox(height: 24.h),

                // Nút hành động
                Row(
                  children: [
                    // Nút Thiết lập lại
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.resetFilters();
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Thiết lập lại',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Nút Áp dụng
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.setReadStatusFilter(_tempReadStatus);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Áp dụng',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
