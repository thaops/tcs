enum NotificationType { leaveRequest, task, meeting }

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
}