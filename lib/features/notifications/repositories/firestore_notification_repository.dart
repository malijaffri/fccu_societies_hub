import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/notifications/repositories/notification_repository.dart';
import 'package:fccu_societies_hub/models/notification_item.dart';

class FirestoreNotificationRepository implements NotificationRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _items(String userId) =>
      _db.collection('notifications').doc(userId).collection('items');

  @override
  Future<List<NotificationItem>> fetchNotifications(String userId) async {
    final snap = await _items(userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    return snap.docs.map((d) => NotificationItem.fromMap(d.data())).toList();
  }

  @override
  Future<int> fetchUnreadCount(String userId) async {
    final snap = await _items(userId)
        .where('isRead', isEqualTo: false)
        .count()
        .get();
    return snap.count ?? 0;
  }

  @override
  Future<void> markAsRead(String userId, String notifId) =>
      _items(userId).doc(notifId).update({'isRead': true});

  @override
  Future<void> markAllAsRead(String userId) async {
    final unread = await _items(userId)
        .where('isRead', isEqualTo: false)
        .get();
    if (unread.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<void> createNotification(String recipientId, NotificationItem notif) async {
    final ref = _items(recipientId).doc();
    await ref.set(notif.copyWith().toMap()..['id'] = ref.id);
  }
}
