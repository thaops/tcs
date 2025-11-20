import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/utils/navigation_utils.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/data/models/notification_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/logic/notification_controller.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/widget/notification_filter_dialog.dart';
import 'package:tcs_flutter/router/app_router.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late final NotificationController controller;
  late final ScrollController _scrollController;
  final RxString _loadingNotificationId = ''.obs;
  final RxBool _isMarkingAllAsRead = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NotificationController());
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!controller.isLoadingMore.value && controller.hasMore.value) {
        controller.fetchNotifications();
      }
    }
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    if (_loadingNotificationId.value.isNotEmpty || _isMarkingAllAsRead.value) {
      return;
    }

    _loadingNotificationId.value = notification.id;

    try {
      if (!notification.isRead) {
        await controller.markAsRead(notification.id);
      }

      await Future.delayed(Duration(milliseconds: 300));

      final source = notification.source;
      final sourceId = notification.sourceId;

      if (sourceId.isEmpty) {
        await Get.toNamed(
          AppRouter.notificationDetail,
          arguments: {'notification': notification, 'sourceId': sourceId},
        );
        controller.refresh();
        return;
      }

      final rawTypeLower = source.toLowerCase();
      if (rawTypeLower == "dayoff" || source == "DayOff") {
        await NavigationUtils.navigateByNotificationType(
          type: NotificationType.leaveRequest,
          id: sourceId,
        );
      } else {
        final type = NotificationUtils.getNotificationType(source);
        if (type != null) {
          await NavigationUtils.navigateByNotificationType(
            type: type,
            id: sourceId,
          );
        } else {
          await Get.toNamed(
            AppRouter.notificationDetail,
            arguments: {'notification': notification, 'sourceId': sourceId},
          );
        }
      }

      controller.refresh();
    } catch (e) {
      print('Error navigating to notification detail: $e');
    } finally {
      _loadingNotificationId.value = '';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => NotificationFilterDialog(),
    );
  }

  Widget _buildFilterBar() {
    return Obx(() {
      final hasStatusFilter =
          controller.selectedStatus.value != NotificationStatus.all;
      final hasReadStatusFilter =
          controller.selectedReadStatus.value != ReadStatus.all;

      if (!hasStatusFilter && !hasReadStatusFilter) {
        return SizedBox.shrink();
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt, size: 16, color: AppColors.primary),
            SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (hasStatusFilter)
                    _buildFilterChip(
                      label: NotificationUtils.getStatusDisplayName(
                        controller.selectedStatus.value,
                      ),
                      onTap:
                          () => controller.setStatusFilter(
                            NotificationStatus.all,
                          ),
                    ),
                  if (hasReadStatusFilter)
                    _buildFilterChip(
                      label: NotificationUtils.getReadStatusDisplayName(
                        controller.selectedReadStatus.value,
                      ),
                      onTap:
                          () => controller.setReadStatusFilter(ReadStatus.all),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Icon(Icons.close, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Checkbox "Tất cả"
          Obx(() {
            final hasUnread = controller.unreadNotifications.isNotEmpty;
            final isSelectAll = controller.isSelectAll.value;
            final hasSelection = controller.selectedNotificationIds.isNotEmpty;

            // Enable nếu có unread hoặc đang có selection
            final isEnabled = hasUnread || hasSelection;

            return GestureDetector(
              onTap: isEnabled ? () => controller.toggleSelectAll() : null,
              child: Row(
                children: [
                  Checkbox(
                    value: isSelectAll,
                    onChanged:
                        isEnabled
                            ? (value) => controller.toggleSelectAll()
                            : null,
                    activeColor: AppColors.primary,
                  ),
                  SizedBox(width: 2),
                  TextWidget(
                    text: 'Tất cả',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? AppColors.black : Colors.grey.shade400,
                  ),
                ],
              ),
            );
          }),
          Spacer(),
          // Nút đánh dấu đã đọc
          Obx(() {
            final hasSelection = controller.selectedNotificationIds.isNotEmpty;
            final isSelectAll = controller.isSelectAll.value;
            final isEnabled = hasSelection || isSelectAll;

            return InkWell(
              onTap: isEnabled ? () => _handleMarkSelectedAsRead() : null,
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    color: isEnabled ? AppColors.primary : Colors.grey,
                  ),
                  TextWidget(
                    text: 'Đã đọc',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isEnabled ? AppColors.primary : Colors.grey,
                  ),
                ],
              ),
            );
          }),
          SizedBox(width: 4),
        ],
      ),
    );
  }

  Future<void> _handleMarkSelectedAsRead() async {
    if (_isMarkingAllAsRead.value) {
      return;
    }

    final selectedCount = controller.selectedNotificationIds.length;
    final isSelectAll = controller.isSelectAll.value;

    if (!isSelectAll && selectedCount == 0) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng chọn thông báo cần đánh dấu đã đọc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade600,
        colorText: Colors.white,
      );
      return;
    }

    _isMarkingAllAsRead.value = true;

    try {
      await controller.markSelectedAsRead();
      Get.snackbar(
        'Thành công',
        isSelectAll
            ? 'Đã đánh dấu tất cả thông báo đã đọc'
            : 'Đã đánh dấu $selectedCount thông báo đã đọc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể đánh dấu thông báo đã đọc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.colorRed,
        colorText: Colors.white,
      );
    } finally {
      _isMarkingAllAsRead.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: 'Thông báo',
        isBack: true,
        isTitleCenter: true,
        iconRightSecond: Icons.filter_list,
        functionSecond: () => _showFilterDialog(context),
      ),
      body: Obx(
        () => Padding(
          padding: EdgeInsets.only(right: 4),
          child: Column(
            children: [
              Divider(color: Colors.grey.shade200, height: 0.5),
              _buildFilterBar(),
              _buildSelectionBar(),
              Expanded(
                child: LoadingOverlay(
                  isLoading:
                      controller.isLoading.value &&
                      controller.notifications.isEmpty,
                  child: AbsorbPointer(
                    absorbing: _isMarkingAllAsRead.value,
                    child: RefreshIndicator(
                      onRefresh: () => controller.refresh(),
                      child:
                          controller.filteredNotifications.isEmpty &&
                                  !controller.isLoading.value
                              ? _buildEmptyState()
                              : ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    controller.filteredNotifications.length +
                                    (controller.isLoadingMore.value ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index >=
                                      controller.filteredNotifications.length) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final notification =
                                      controller.filteredNotifications[index];
                                  final isLoading =
                                      _loadingNotificationId.value ==
                                      notification.id;

                                  return _buildNotificationItem(
                                    context,
                                    notification,
                                    isLoading,
                                  );
                                },
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          TextWidget(
            text: 'Không có thông báo',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    bool isLoading,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final isUnread = !notification.isRead;

    return Obx(
      () => AbsorbPointer(
        absorbing: _loadingNotificationId.value.isNotEmpty,
        child: Container(
          decoration: BoxDecoration(
            color:
                isUnread ? AppColors.primary.withOpacity(0.05) : Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          padding: EdgeInsets.only(right: 4, top: 12, bottom: 12),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Checkbox
                  Obx(
                    () => Container(
                      margin: EdgeInsets.only(right: 2),
                      child: Checkbox(
                        value: controller.selectedNotificationIds.contains(
                          notification.id,
                        ),
                        onChanged:
                            notification.isRead
                                ? null
                                : (value) => controller
                                    .toggleSelectNotification(notification.id),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          isLoading
                              ? null
                              : () => _handleNotificationTap(notification),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextWidget(
                                  text: notification.title,
                                  fontSize: 15,
                                  fontWeight:
                                      isUnread
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                  color: AppColors.primary,
                                  maxLines: 2,
                                ),
                              ),
                              if (notification.isPinned)
                                Icon(
                                  Icons.push_pin,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                          SizedBox(height: 6),
                          TextWidget(
                            text: notification.content,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade700,
                            maxLines: 3,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                text: dateFormat.format(
                                  notification.createdDate,
                                ),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
