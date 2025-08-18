import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMultiSelectField<T> extends StatefulWidget {
  final List<MultiSelectItem<T>> items;
  final List<T> initialValues;
  final String title;
  final String buttonText;
  final String searchHint;
  final bool isMultiSelect;
  final Color? chipColor;
  final Color? chipTextColor;
  final Color? borderColor;
  final IconData? trailingIcon;
  final double borderRadius;
  final Function(List<T>) onConfirm;
  final String? Function(List<T>?) validator;
  final InputDecoration? decoration;
  final double? elevation;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final bool animateOnTap;
  final Duration animationDuration;
  final double? bottomSheetHeight;

  const CustomMultiSelectField({
    Key? key,
    required this.items,
    this.initialValues = const [],
    this.title = "Select items",
    this.buttonText = "Select",
    this.searchHint = "Search...",
    this.isMultiSelect = true,
    this.chipColor,
    this.chipTextColor,
    this.borderColor,
    this.trailingIcon = Icons.arrow_drop_down,
    this.borderRadius = 12.0,
    required this.onConfirm,
    required this.validator,
    this.decoration,
    this.elevation = 0,
    this.backgroundColor,
    this.surfaceTintColor,
    this.animateOnTap = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.bottomSheetHeight,
  }) : super(key: key);

  @override
  _CustomMultiSelectFieldState<T> createState() =>
      _CustomMultiSelectFieldState<T>();
}

class _CustomMultiSelectFieldState<T> extends State<CustomMultiSelectField<T>>
    with SingleTickerProviderStateMixin {
  late List<T> _selectedItems;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TextEditingController _searchController = TextEditingController();
  List<MultiSelectItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialValues);
    _filteredItems = List.from(widget.items);
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.label.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = widget.chipColor ?? AppColors.primary;
    final chipTextColor = widget.chipTextColor ?? theme.colorScheme.onPrimary;
    final borderColor = widget.borderColor ?? theme.colorScheme.outline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            elevation: widget.elevation ?? 0,
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            surfaceTintColor: widget.surfaceTintColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                border: Border.all(
                  color: borderColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      _selectedItems.isNotEmpty ? "Số người theo dõi: ${_selectedItems.length}" : widget.buttonText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(widget.trailingIcon,
                        color: theme.colorScheme.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity.compact,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (widget.animateOnTap) {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                          _showMultiSelectDialog(context);
                        });
                      } else {
                        _showMultiSelectDialog(context);
                      }
                    },
                  ),
                  if (_selectedItems.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Wrap(
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        spacing: 6,
                        runSpacing: 6,
                        children: _selectedItems.map((item) {
                          return Chip(
                            backgroundColor: chipColor,
                            label: TextWidget(
                              text: _getItemLabel(item),
                              color: chipTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            deleteIcon: Icon(
                              Icons.close,
                              size: 16,
                              color: chipTextColor,
                            ),
                            onDeleted: () {
                              setState(() {
                                _selectedItems.remove(item);
                                widget.onConfirm(_selectedItems);
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            visualDensity: VisualDensity.compact,
                            elevation: 2,
                            shadowColor: chipColor.withOpacity(0.3),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (widget.validator(_selectedItems) != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              widget.validator(_selectedItems)!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  String _getItemLabel(T item) {
    try {
      final selectedItem = widget.items.firstWhere(
        (element) => element.value == item,
      );
      return selectedItem.label;
    } catch (e) {
      return item.toString();
    }
  }

  void _showMultiSelectDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(widget.borderRadius)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateBottomSheet) {
            void filterItems() {
              final query = _searchController.text.toLowerCase();
              setStateBottomSheet(() {
                _filteredItems = widget.items
                    .where((item) => item.label.toLowerCase().contains(query))
                    .toList();
              });
            }

            _searchController.addListener(filterItems);

            return FractionallySizedBox(
              heightFactor: widget.bottomSheetHeight != null ? null : 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            text: widget.title,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.check,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              _searchController.removeListener(filterItems);
                              FocusScope.of(context).unfocus();
                              Navigator.pop(context, _selectedItems);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: CustomTextField(
                        controller: _searchController,
                        hintText: widget.searchHint,
                        prefixIcon: Icons.search,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: _filteredItems.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: TextWidget(
                                text: "No results found",
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 16.sp,
                              ),
                            )
                          : Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: _filteredItems.map((item) {
                                final isSelected =
                                    _selectedItems.contains(item.value);
                                return ChoiceChip(
                                  label: Text(
                                    item.label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? widget.chipTextColor
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor:
                                      widget.chipColor ?? AppColors.primary,
                                  backgroundColor: Colors.white,
                                  elevation: isSelected ? 2 : 0,
                                  shadowColor: isSelected
                                      ? (widget.chipColor ?? AppColors.primary)
                                          .withOpacity(0.3)
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      setStateBottomSheet(() {
                                        if (selected) {
                                          if (widget.isMultiSelect ||
                                              _selectedItems.isEmpty) {
                                            _selectedItems.add(item.value);
                                          } else {
                                            _selectedItems = [item.value];
                                          }
                                        } else {
                                          _selectedItems.remove(item.value);
                                        }
                                        widget.onConfirm(_selectedItems);
                                      });
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      _searchController.removeListener(_filterItems);
      FocusScope.of(context).unfocus();
      if (value != null) {
        setState(() {
          _selectedItems = value;
          widget.onConfirm(_selectedItems);
        });
      }
    });
  }
}
