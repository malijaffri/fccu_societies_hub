import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';
import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/current_user_model_provider.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_actions.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_header.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_media_grid.dart';
import 'package:fccu_societies_hub/features/session/providers/session_permissions_provider.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  final bool compact;

  const PostCard({super.key, required this.post, this.compact = true});

  Future<void> _toggleLike(WidgetRef ref) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;

    final repo = ref.read(postRepositoryProvider);
    if (post.isLiked) {
      await repo.unlikePost(post.id, uid);
    } else {
      final userModel = ref.read(currentUserModelProvider).value;
      await repo.likePost(
        post.id,
        uid,
        actorName: userModel?.name,
        actorAvatarUrl: userModel?.avatarUrl,
      );
    }

    ref.invalidate(postProvider(post.id));
    ref.invalidate(postsProvider);
    ref.invalidate(feedProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canReact = ref.watch(canReactProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: theme.brightness == Brightness.dark ? 0 : 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppRadius.r_16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.r_16),
          border: theme.brightness == Brightness.dark
              ? Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4))
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r_16),
          onTap: compact ? () => context.push(AppRoutes.post.resolve({'id': post.id})) : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(post: post),

                const SizedBox(height: AppSpacing.s_12),

                // Use plain Text in compact (list) mode so taps reach the
                // InkWell. SelectableText intercepts gestures for selection
                // and blocks the parent onTap. Only use SelectableText in
                // the full detail view where selection is actually useful.
                if (compact)
                  Text(
                    post.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.42, fontSize: 15.5),
                  )
                else
                  SelectableText(
                    post.content,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.42, fontSize: 15.5),
                  ),

                if (post.media.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s_12),
                  PostMediaGrid(media: post.media),
                ],

                // Linked-event banner
                if (post.eventId != null) ...[
                  const SizedBox(height: AppSpacing.s_12),
                  _EventBanner(eventId: post.eventId!),
                ],

                const SizedBox(height: AppSpacing.s_8),

                PostActions(
                  post: post,
                  onLike: canReact
                      ? () => _toggleLike(ref)
                      : () => context.push(AppRoutes.register),
                  onComment: compact
                      ? () => context.push(AppRoutes.post.resolve({'id': post.id}))
                      : null,
                  onShare: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _EventBanner extends ConsumerWidget {
  final String eventId;
  const _EventBanner({required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return eventAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (event) {
        if (event == null) return const SizedBox.shrink();
        return InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r_12),
          onTap: () => context.push(AppRoutes.event.resolve({'id': event.id})),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s_12,
              vertical: AppSpacing.s_8,
            ),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.r_12),
            ),
            child: Row(
              children: [
                Icon(Icons.event_rounded, size: 18, color: colorScheme.onSecondaryContainer),
                const SizedBox(width: AppSpacing.s_8),
                Expanded(
                  child: Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, size: 18, color: colorScheme.onSecondaryContainer),
              ],
            ),
          ),
        );
      },
    );
  }
}
