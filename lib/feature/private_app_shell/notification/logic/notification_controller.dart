import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/data/models/notification_model.dart';

class NotificationController extends GetxController {
  final DioApi dioApi = DioApi();

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final currentPage = 1.obs;
  final pageSize = 10;

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
      final notificationResponse =
          NotificationListResponse.fromJson(data as Map<String, dynamic>);

      if (forceRefresh || currentPage.value == 1) {
        notifications.value = notificationResponse.data;
      } else {
        notifications.addAll(notificationResponse.data);
      }

      hasMore.value = notificationResponse.data.length >= pageSize;
      _updateUnreadCount();

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
      await dioApi.get(
        ApiEndpoints.getNotificationDetail(notificationId),
      );

      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        _updateUnreadCount();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> refresh() async {
    await fetchNotifications(forceRefresh: true);
  }

  Future<void> markAllAsRead() async {
    try {
      await dioApi.post(
        ApiEndpoints.readAllNotifications(),
      );

      for (int i = 0; i < notifications.length; i++) {
        if (!notifications[i].isRead) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
      }
      _updateUnreadCount();
      
      await refresh();
    } catch (e) {
      print('Error marking all notifications as read: $e');
      rethrow;
    }
  }
}

