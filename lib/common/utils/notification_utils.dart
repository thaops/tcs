enum NotificationType { leaveRequest, task, meeting }

enum NotificationStatus {
  pendingApproval, // Chờ duyệt
  approved, // Đã duyệt
  rejected, // Từ chối
  pendingCancel, // Chờ hủy đơn
  cancelled, // Hủy đơn
  all, // Tất cả
}

enum ReadStatus {
  all, // Tất cả
  read, // Đã đọc
  unread, // Chưa đọc
}

class NotificationUtils {
  static NotificationType? getNotificationType(String? type) {
    switch (type) {
      case 'leave':
        return NotificationType.leaveRequest;
      case 'task':
        return NotificationType.task;
      case 'meeting':
        return NotificationType.meeting;
      default:
        return null;
    }
  }

  /// Parse notification status từ title
  static NotificationStatus? getNotificationStatus(String? title) {
    if (title == null || title.isEmpty) return null;

    final titleLower = title.toLowerCase();

    if (titleLower.contains('yêu cầu phê duyệt đơn nghỉ phép') ||
        titleLower.contains('yêu cầu phê duyệt')) {
      return NotificationStatus.pendingApproval;
    } else if (titleLower.contains('đã được phê duyệt') ||
        titleLower.contains('phê duyệt')) {
      return NotificationStatus.approved;
    } else if (titleLower.contains('bị từ chối') ||
        titleLower.contains('từ chối')) {
      return NotificationStatus.rejected;
    } else if (titleLower.contains('yêu cầu hủy đơn nghỉ phép') ||
        titleLower.contains('yêu cầu hủy đơn')) {
      return NotificationStatus.pendingCancel;
    } else if (titleLower.contains('đã được hủy thành công') ||
        titleLower.contains('hủy thành công')) {
      return NotificationStatus.cancelled;
    }

    return null;
  }

  /// Lấy tên hiển thị của status
  static String getStatusDisplayName(NotificationStatus status) {
    switch (status) {
      case NotificationStatus.pendingApproval:
        return 'Chờ duyệt';
      case NotificationStatus.approved:
        return 'Đã duyệt';
      case NotificationStatus.rejected:
        return 'Từ chối';
      case NotificationStatus.pendingCancel:
        return 'Chờ hủy đơn';
      case NotificationStatus.cancelled:
        return 'Hủy đơn';
      case NotificationStatus.all:
        return 'Tất cả';
    }
  }

  /// Lấy tên hiển thị của read status
  static String getReadStatusDisplayName(ReadStatus status) {
    switch (status) {
      case ReadStatus.all:
        return 'Tất cả';
      case ReadStatus.read:
        return 'Đã đọc';
      case ReadStatus.unread:
        return 'Chưa đọc';
    }
  }
}