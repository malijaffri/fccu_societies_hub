import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/notification_item.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notif;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notif, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (icon, color, verb) = switch (notif.type) {
      NotificationType.like => (Icons.favorite_rounded, Colors.red, 'liked your post'),
      NotificationType.comment => (Icons.mode_comment_rounded, colorScheme.primary, 'commented on your post'),
    };

    return InkWell(
      onTap: () {
        onTap?.call();
        context.push(AppRoutes.post.resolve({'id': notif.postId}));
      },
      child: Container(
        color: notif.isRead ? null : colorScheme.primaryContainer.withValues(alpha: 0.18),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s_16,
          vertical: AppSpacing.s_12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Avatar(avatarUrl: notif.actorAvatarUrl, name: notif.actorName, radius: 22),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.surface, width: 2),
                    ),
                    child: Icon(icon, size: 11, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(width: AppSpacing.s_12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: notif.actorName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: ' $verb'),
                      ],
                    ),
                  ),

                  if (notif.type == NotificationType.comment &&
                      notif.commentContent != null) ...[
                    const SizedBox(height: AppSpacing.s_4),
                    Text(
                      '"${notif.commentContent}"',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  if (notif.postContent.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.s_2),
                    Text(
                      notif.postContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.s_4),

                  Text(
                    timeago.format(notif.createdAt, locale: 'en_short'),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            if (!notif.isRead)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.s_4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
