import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/posts/providers/posts_provider.dart';
import 'package:fccu_societies_hub/models/post.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class PostHeader extends ConsumerWidget {
  final Post post;

  const PostHeader({super.key, required this.post});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('This post will be permanently deleted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(postRepositoryProvider).deletePost(post.id);
    ref.invalidate(postsProvider);
    ref.invalidate(feedProvider);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUid = ref.watch(currentUserProvider)?.uid;
    final isOwner = currentUid != null && currentUid == post.authorId;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.push(AppRoutes.society.resolve({'id': post.societyId})),
          child: Avatar(
            avatarUrl: post.societyImage,
            name: post.societyName,
            radius: 22,
            textStyle: theme.textTheme.titleMedium,
          ),
        ),

        const SizedBox(width: AppSpacing.s_12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s_2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.push(AppRoutes.society.resolve({'id': post.societyId})),
                  child: Text(
                    post.societyName,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: AppSpacing.s_2),

                Text(
                  timeago.format(post.createdAt, locale: 'en_short'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        PopupMenuButton<_PostAction>(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.more_horiz_rounded),
          onSelected: (action) {
            if (action == _PostAction.delete) _confirmDelete(context, ref);
            if (action == _PostAction.edit) {
              context.push(AppRoutes.editPost.resolve({'id': post.id}));
            }
          },
          itemBuilder: (_) => [
            if (isOwner) ...[
              PopupMenuItem(
                value: _PostAction.edit,
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 20),
                    SizedBox(width: AppSpacing.s_8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: _PostAction.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 20, color: colorScheme.error),
                    const SizedBox(width: AppSpacing.s_8),
                    Text('Delete', style: TextStyle(color: colorScheme.error)),
                  ],
                ),
              ),
            ],
            const PopupMenuItem(
              value: _PostAction.report,
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 20),
                  SizedBox(width: AppSpacing.s_8),
                  Text('Report'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _PostAction { edit, delete, report }
