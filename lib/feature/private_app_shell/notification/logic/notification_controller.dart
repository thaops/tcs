import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/data/models/notification_model.dart';

class NotificationController extends GetxController {
  final DioApi dioApi = DioApi();

  final notifications = <NotificationModel>[].obs;
  final filteredNotifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final pageSize = 30;

  // Filter states
  final selectedStatus = NotificationStatus.all.obs;
  final selectedReadStatus = ReadStatus.all.obs;

  // Selection states
  final isSelectAll = false.obs;
  final selectedNotificationIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({bool forceRefresh = false}) async {
    try {
      if (forceRefresh) {
        currentPage.value = 1;
        notifications.clear();
        hasMore.value = true;
      }

      if (isLoading.value || isLoadingMore.value) return;

      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await dioApi.get(
        ApiEndpoints.getNotificationList(
          pageIndex: currentPage.value,
          pageSize: pageSize,
        ),
      );

      final data = response.data ?? {};
      final notificationResponse = NotificationListResponse.fromJson(
        data as Map<String, dynamic>,
      );

      if (forceRefresh || currentPage.value == 1) {
        notifications.value = notificationResponse.data;
      } else {
        notifications.addAll(notificationResponse.data);
      }

      hasMore.value = notificationResponse.data.length >= pageSize;
      _updateUnreadCount();
      _applyFilters();

      if (hasMore.value) {
        currentPage.value++;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await dioApi.get(ApiEndpoints.getNotificationDetail(notificationId));

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        _updateUnreadCount();
        _applyFilters();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void _applyFilters() {
    var filtered = notifications.toList();

    // Filter by status
    if (selectedStatus.value != NotificationStatus.all) {
      filtered =
          filtered.where((notification) {
            final status = NotificationUtils.getNotificationStatus(
              notification.title,
            );
            return status == selectedStatus.value;
          }).toList();
    }

    // Filter by read status
    if (selectedReadStatus.value != ReadStatus.all) {
      filtered =
          filtered.where((notification) {
            if (selectedReadStatus.value == ReadStatus.read) {
              return notification.isRead;
            } else {
              return !notification.isRead;
            }
          }).toList();
    }

    filteredNotifications.value = filtered;
  }

  void setStatusFilter(NotificationStatus status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void setReadStatusFilter(ReadStatus status) {
    selectedReadStatus.value = status;
    _applyFilters();
  }

  void resetFilters() {
    selectedStatus.value = NotificationStatus.all;
    selectedReadStatus.value = ReadStatus.all;
    _applyFilters();
  }

  Future<void> refresh() async {
    await fetchNotifications(forceRefresh: true);
  }

  Future<void> markAllAsRead() async {
    try {
      await dioApi.post(ApiEndpoints.readAllNotifications());

      for (int i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
      }
      _updateUnreadCount();
      _applyFilters();

      await refresh();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      rethrow;
    }
  }

  // Get unread notifications from filtered list
  List<NotificationModel> get unreadNotifications {
    return filteredNotifications.where((n) => !n.isRead).toList();
  }

  // Toggle select all
  void toggleSelectAll() {
    isSelectAll.value = !isSelectAll.value;

    if (isSelectAll.value) {
      final unreadIds = unreadNotifications.map((item) => item.id).toSet();
      selectedNotificationIds.addAll(unreadIds);
    } else {
      selectedNotificationIds.clear();
    }
  }

  // Toggle select individual notification
  void toggleSelectNotification(String notificationId) {
    // Chỉ cho phép chọn notification chưa đọc
    final notification =
        filteredNotifications
            .where((n) => n.id == notificationId)
            .firstOrNull ??
        notifications.where((n) => n.id == notificationId).firstOrNull;

    if (notification == null || notification.isRead) {
      return; // Không cho phép chọn notification đã đọc hoặc không tồn tại
    }

    if (selectedNotificationIds.contains(notificationId)) {
      selectedNotificationIds.remove(notificationId);
    } else {
      selectedNotificationIds.add(notificationId);
    }

    final unreadIds = unreadNotifications.map((item) => item.id).toSet();
    isSelectAll.value =
        unreadIds.isNotEmpty && selectedNotificationIds.containsAll(unreadIds);
  }

  // Mark selected notifications as read
  Future<void> markSelectedAsRead() async {
    try {
      if (isSelectAll.value) {
        // Mark all as read
        final result = await dioApi.post(ApiEndpoints.readAllNotifications());

        if (result.statusCode == 200 ||
            (result.data is Map &&
                (result.data['statusCode'] == 200 ||
                    result.data['StatusCode'] == 200))) {
          for (var i = 0; i < notifications.length; i++) {
            if (!notifications[i].isRead) {
              notifications[i] = notifications[i].copyWith(isRead: true);
            }
          }
          _updateFilteredLists();
          selectedNotificationIds.clear();
          isSelectAll.value = false;
          await refresh();
        }
      } else {
        // Mark selected as read
        final notificationIds = selectedNotificationIds.toList();

        if (notificationIds.isNotEmpty) {
          final result = await dioApi.post(
            ApiEndpoints.readNotifications(),
            data: notificationIds,
          );

          if (result.statusCode == 200 ||
              (result.data is Map &&
                  (result.data['statusCode'] == 200 ||
                      result.data['StatusCode'] == 200))) {
            for (var notificationId in notificationIds) {
              final index = notifications.indexWhere(
                (item) => item.id == notificationId,
              );
              if (index != -1) {
                notifications[index] = notifications[index].copyWith(
                  isRead: true,
                );
              }
            }
            _updateFilteredLists();
            selectedNotificationIds.clear();
            isSelectAll.value = false;
            await refresh();
          }
        }
      }
    } catch (e) {
      print('Error marking selected notifications as read: $e');
      rethrow;
    }
  }

  void _updateFilteredLists() {
    _updateUnreadCount();
    _applyFilters();
  }

  // Clear selection
  void clearSelection() {
    selectedNotificationIds.clear();
    isSelectAll.value = false;
  }
}
