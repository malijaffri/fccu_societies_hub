import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/notifications/repositories/firestore_notification_repository.dart';
import 'package:fccu_societies_hub/features/notifications/repositories/notification_repository.dart';
import 'package:fccu_societies_hub/models/notification_item.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => FirestoreNotificationRepository(),
);

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return [];
  return ref.watch(notificationRepositoryProvider).fetchNotifications(uid);
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final uid = ref.watch(currentUserProvider)?.uid;
  if (uid == null) return 0;
  return ref.watch(notificationRepositoryProvider).fetchUnreadCount(uid);
});
