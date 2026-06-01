import 'package:fccu_societies_hub/models/notification_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications(String userId);

  Future<int> fetchUnreadCount(String userId);

  Future<void> markAsRead(String userId, String notifId);

  Future<void> markAllAsRead(String userId);

  Future<void> createNotification(String recipientId, NotificationItem notif);
}
