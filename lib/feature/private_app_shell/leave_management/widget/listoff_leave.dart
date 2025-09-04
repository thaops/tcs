import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/models/leave_management.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ListoffLeave extends StatefulWidget {
  final String label1;
  final String? name;
  final List<LeaveType>? leaveList;
  final void Function(LeaveType?)? onProjectSelected;

  ListoffLeave({
    Key? key,
    required this.label1,
    this.name,
    this.leaveList,
    this.onProjectSelected,
  }) : super(key: key);

  @override
  State<ListoffLeave> createState() => _ListoffLeaveState();
}

class _ListoffLeaveState extends State<ListoffLeave> {
  LeaveType? _selectedUser;
  bool _isDropdownOpen = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị được chọn từ widget.name nếu có
    _initializeSelectedValue();
  }

  @override
  void didUpdateWidget(ListoffLeave oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cập nhật giá trị được chọn khi widget được rebuild
    if (oldWidget.name != widget.name ||
        oldWidget.leaveList != widget.leaveList) {
      _initializeSelectedValue();
    }
  }

  void _initializeSelectedValue() {
    if (widget.name != null && widget.leaveList != null) {
      // Tìm item có tên khớp với widget.name
      final matchingItem = widget.leaveList!.firstWhere(
        (item) => item.name == widget.name,
        orElse: () => LeaveType(id: '', name: ''),
      );
      if (matchingItem.id.isNotEmpty) {
        _selectedUser = matchingItem;
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isDropdownOpen = false;
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeOverlay();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    final RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemHeight = 56.h; // Chiều cao mỗi item
    final maxItemsToShow = 5; // Số lượng item tối đa hiển thị
    final dropdownHeight =
        (widget.leaveList?.length ?? 0).clamp(0, maxItemsToShow) * itemHeight;

    // Tính toán vị trí dropdown
    bool showAbove = false;
    double topPosition = offset.dy + size.height + 4.h; // Vị trí dưới ô chọn

    // Kiểm tra xem có đủ chỗ hiển thị dưới không
    if (topPosition + dropdownHeight > screenHeight - 50.h) {
      // Nếu không đủ chỗ, hiển thị phía trên
      showAbove = true;
      topPosition = offset.dy - dropdownHeight - 4.h;

      // Đảm bảo không vượt quá top của màn hình
      if (topPosition < 50.h) {
        topPosition = 50.h;
        showAbove = false;
        topPosition = offset.dy + size.height + 4.h;
      }
    }

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              // Barrier để đóng dropdown khi nhấn ra ngoài
              GestureDetector(
                onTap: _removeOverlay,
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.transparent,
                ),
              ),
              // Dropdown menu
              Positioned(
                left: offset.dx,
                top: topPosition,
                width: size.width,
                child: Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: dropdownHeight),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.leaveList?.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = widget.leaveList![index];
                          final isSelected = _selectedUser?.id == item.id;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedUser = item;
                              });
                              widget.onProjectSelected?.call(item);
                              _removeOverlay();
                            },
                            child: Container(
                              height: itemHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.transparent,
                                border:
                                    index < (widget.leaveList!.length - 1)
                                        ? Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        )
                                        : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextWidget(
                                      text: item.name,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : AppColors.black,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check,
                                      color: AppColors.primary,
                                      size: 20.sp,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: widget.label1,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            key: _dropdownKey,
            onTap: () {
              if (widget.leaveList != null && widget.leaveList!.isNotEmpty) {
                _toggleDropdown();
              }
            },
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      _isDropdownOpen
                          ? AppColors.primary
                          : Colors.grey.shade400,
                  width: _isDropdownOpen ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      text: _selectedUser?.name ?? widget.name ?? 'Lý do',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color:
                          _selectedUser != null
                              ? AppColors.black
                              : AppColors.black.withOpacity(0.6),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isDropdownOpen ? 0.5 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color:
                          _isDropdownOpen
                              ? AppColors.primary
                              : AppColors.black.withOpacity(0.6),
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
