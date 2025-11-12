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

  Future<void> _handleMarkAllAsRead() async {
    if (_isMarkingAllAsRead.value) {
      return;
    }

    final unreadCount = controller.unreadCount.value;
    if (unreadCount == 0) {
      Get.snackbar(
        'Thông báo',
        'Không có thông báo chưa đọc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade600,
        colorText: Colors.white,
      );
      return;
    }

    _isMarkingAllAsRead.value = true;

    try {
      await controller.markAllAsRead();
      Get.snackbar(
        'Thành công',
        'Đã đánh dấu tất cả thông báo đã đọc',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể đánh dấu tất cả đã đọc',
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
        iconRightfirst: Icons.check,
        functionfirst: () => _handleMarkAllAsRead(),
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading:
              controller.isLoading.value && controller.notifications.isEmpty,
          child: AbsorbPointer(
            absorbing: _isMarkingAllAsRead.value,
            child: RefreshIndicator(
              onRefresh: () => controller.refresh(),
              child:
                  controller.notifications.isEmpty &&
                          !controller.isLoading.value
                      ? _buildEmptyState()
                      : ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            controller.notifications.length +
                            (controller.isLoadingMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= controller.notifications.length) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          }

                          final notification = controller.notifications[index];
                          final isLoading =
                              _loadingNotificationId.value == notification.id;

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
        child: GestureDetector(
          onTap: isLoading ? null : () => _handleNotificationTap(notification),
          child: Container(
            decoration: BoxDecoration(
              color:
                  isUnread ? AppColors.primary.withOpacity(0.05) : Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
      ),
    );
  }
}
