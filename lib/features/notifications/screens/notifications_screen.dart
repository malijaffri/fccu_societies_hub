import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/core/widgets/empty_state.dart';
import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/notifications/providers/notifications_provider.dart';
import 'package:fccu_societies_hub/features/notifications/widgets/notification_tile.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final uid = ref.watch(currentUserProvider)?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: uid == null
                ? null
                : () async {
                    await ref
                        .read(notificationRepositoryProvider)
                        .markAllAsRead(uid);
                    ref.invalidate(notificationsProvider);
                    ref.invalidate(unreadCountProvider);
                  },
            child: const Text('Mark all read'),
          ),
        ],
      ),

      body: notificationsAsync.when(
        loading: () => const AppLoading(),

        error: (e, _) => AppError(
          error: e,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),

        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No notifications yet',
              subtitle: 'Likes and comments on your posts will appear here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadCountProvider);
              await ref.read(notificationsProvider.future);
            },
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final notif = notifications[i];
                return NotificationTile(
                  notif: notif,
                  onTap: notif.isRead || uid == null
                      ? null
                      : () {
                          ref
                              .read(notificationRepositoryProvider)
                              .markAsRead(uid, notif.id);
                          ref.invalidate(notificationsProvider);
                          ref.invalidate(unreadCountProvider);
                        },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
