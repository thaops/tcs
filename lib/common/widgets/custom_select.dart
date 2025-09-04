import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';

class Item {
  final String id;
  final String name;

  Item({required this.id, required this.name});
}

class CustomSelect extends StatefulWidget {
  final String? label1;
  final String? name;
  final Color? colorIcon;
  final Color? textColor;
  final IconData? icon;
  final List<Item>? selectList;
  final bool isEnabled;
  final void Function(String?)? onProjectSelected;
  final bool isNotChange;
  final String? errorText;
  final bool searchable;
  final String? selectedId;
  final String? selectedName;
  final Future<void> Function()? onTap;

  const CustomSelect({
    Key? key,
    this.label1,
    this.name,
    this.selectList,
    this.textColor,
    this.colorIcon,
    this.onProjectSelected,
    this.icon,
    this.isEnabled = true,
    this.isNotChange = false,
    this.errorText,
    this.searchable = true,
    this.selectedId,
    this.selectedName,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomSelect> createState() => _SelectState();
}

class _SelectState extends State<CustomSelect> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    if (widget.selectedId != null) {
      _selectedId = widget.selectedId;
      final selectedItem = widget.selectList!.firstWhere(
        (item) => item.id == widget.selectedId,
        orElse: () => Item(id: '', name: ''),
      );
      _controller.text = selectedItem.name;
    }
    // Initialize from external selectedName if provided
    if ((widget.selectedName ?? '').isNotEmpty) {
      _controller.text = widget.selectedName!;
    }
    // Kích hoạt gợi ý khi TextField được nhấn
    _focusNode.addListener(() {
      if (_focusNode.hasFocus &&
          widget.selectList != null &&
          widget.selectList!.isNotEmpty) {
        // Gửi sự kiện để hiển thị gợi ý
        _controller.text = _controller.text; // Kích hoạt suggestionsCallback
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update when selectedId changes
    if (widget.selectedId != oldWidget.selectedId ||
        widget.selectList != oldWidget.selectList) {
      if (widget.selectedId != null && (widget.selectList ?? []).isNotEmpty) {
        final selectedItem = widget.selectList!.firstWhere(
          (item) => item.id == widget.selectedId,
          orElse: () => Item(id: '', name: ''),
        );
        setState(() {
          _selectedId = widget.selectedId;
          _controller.text = selectedItem.name;
        });
      }
    }
    // Update when selectedName changes externally
    if (widget.selectedName != oldWidget.selectedName &&
        (widget.selectedName ?? '').isNotEmpty) {
      setState(() {
        _controller.text = widget.selectedName!;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isEnabledEffective = widget.isEnabled && !widget.isNotChange;

    return Container(
      padding: EdgeInsets.only(bottom: 16.h),
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label1 != null)
            TextWidget(
              text: widget.label1 ?? '',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: widget.colorIcon ?? Colors.black,
            ),
          SizedBox(height: 10.h),
          if (widget.searchable)
            TypeAheadField<String>(
              controller: _controller,
              focusNode: _focusNode,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  enabled: isEnabledEffective,
                  readOnly: widget.onTap != null,
                  decoration: InputDecoration(
                    hintText: widget.name ?? 'Chọn một tùy chọn',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      fontFamily: 'Inter',
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color:
                            widget.errorText != null
                                ? Colors.red
                                : Colors.grey.shade400,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color:
                            widget.errorText != null
                                ? Colors.red
                                : Colors.grey.shade400,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    filled: true,
                    fillColor:
                        isEnabledEffective
                            ? Colors.white
                            : Colors.grey.shade100,
                    suffixIcon:
                        isEnabledEffective
                            ? Icon(
                              widget.icon ?? Icons.keyboard_arrow_down_rounded,
                              color:
                                  isEnabledEffective
                                      ? widget.colorIcon ?? Colors.black
                                      : Colors.grey.shade400,
                              size: 20.sp,
                            )
                            : null,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                  ),
                  onTap: () {
                    // If provided, delegate to external picker
                    if (widget.onTap != null) {
                      widget.onTap!.call();
                      return;
                    }
                    if (widget.selectList != null &&
                        widget.selectList!.isNotEmpty) {
                      // Kích hoạt gợi ý khi nhấn
                      _controller.text = _controller.text; // Gửi sự kiện
                      _focusNode.requestFocus();
                    }
                  },
                );
              },
              suggestionsCallback: (pattern) async {
                if (widget.selectList == null || widget.selectList!.isEmpty)
                  return [];
                return widget.selectList!
                    .where(
                      (item) => item.name.toLowerCase().contains(
                        pattern.toLowerCase(),
                      ),
                    )
                    .map((item) => item.name)
                    .toList();
              },
              itemBuilder: (context, String suggestion) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        suggestion == _controller.text
                            ? Colors.blue.shade50
                            : Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      suggestion,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              },
              onSelected: (String suggestion) {
                if (widget.selectList != null) {
                  final selectedItem = widget.selectList!.firstWhere(
                    (item) => item.name == suggestion,
                    orElse: () => Item(id: '', name: ''),
                  );
                  setState(() {
                    _selectedId = selectedItem.id;
                    _controller.text = selectedItem.name;
                  });
                  widget.onProjectSelected?.call(selectedItem.id);
                }
              },
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.3,
                maxWidth: Get.width - 32.w,
              ),
              decorationBuilder: (context, child) {
                return Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                  child: child,
                );
              },
              emptyBuilder:
                  (context) => Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    child: Text(
                      'Không tìm thấy',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
            )
          else if (widget.onTap != null)
            TextFormField(
              controller: _controller,
              readOnly: true,
              enabled: isEnabledEffective,
              onTap:
                  isEnabledEffective
                      ? () async {
                        await widget.onTap!.call();
                      }
                      : null,
              decoration: InputDecoration(
                hintText: widget.name ?? 'Chọn một tùy chọn',
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color:
                        widget.errorText != null
                            ? Colors.red
                            : Colors.grey.shade400,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color:
                        widget.errorText != null
                            ? Colors.red
                            : Colors.grey.shade400,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                filled: true,
                fillColor:
                    isEnabledEffective ? Colors.white : Colors.grey.shade100,
                suffixIcon:
                    isEnabledEffective
                        ? Icon(
                          widget.icon ?? Icons.keyboard_arrow_down_rounded,
                          color:
                              isEnabledEffective
                                  ? widget.colorIcon ?? Colors.black
                                  : Colors.grey.shade400,
                          size: 20.sp,
                        )
                        : null,
              ),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            )
          else
            DropdownButtonFormField<String>(
              value: _selectedId?.isNotEmpty == true ? _selectedId : null,
              items:
                  (widget.selectList ?? [])
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item.id,
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged:
                  isEnabledEffective
                      ? (val) {
                        final selectedItem = (widget.selectList ?? [])
                            .firstWhere(
                              (e) => e.id == val,
                              orElse: () => Item(id: '', name: ''),
                            );
                        setState(() {
                          _selectedId = selectedItem.id;
                          _controller.text = selectedItem.name;
                        });
                        widget.onProjectSelected?.call(selectedItem.id);
                      }
                      : null,
              // Thiết lập chiều cao tối đa cho dropdown menu
              menuMaxHeight: 300.h,
              // Đảm bảo dropdown hiển thị trên nền trắng
              dropdownColor: Colors.white,
              // Điều chỉnh icon để rõ ràng hơn
              icon: Icon(
                Icons.keyboard_arrow_down,
                color:
                    isEnabledEffective
                        ? Colors.black.withOpacity(0.6)
                        : Colors.grey.shade400,
                size: 20.sp,
              ),
              decoration: InputDecoration(
                hintText: widget.name ?? 'Chọn một tùy chọn',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color:
                        widget.errorText != null
                            ? Colors.red
                            : Colors.grey.shade400,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color:
                        widget.errorText != null
                            ? Colors.red
                            : Colors.grey.shade400,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                filled: true,
                fillColor:
                    isEnabledEffective ? Colors.white : Colors.grey.shade100,
              ),
            ),
          if (widget.errorText != null) ...[
            SizedBox(height: 4.h),
            TextWidget(
              paddingHorizontal: 24.w,
              text: widget.errorText!,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
          ],
        ],
      ),
    );
  }
}
