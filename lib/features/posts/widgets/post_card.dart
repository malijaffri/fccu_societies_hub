import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_actions.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_header.dart';
import 'package:fccu_societies_hub/features/posts/widgets/post_media_grid.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  final bool compact;

  const PostCard({super.key, required this.post, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: theme.brightness == Brightness.dark ? 0 : 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: .circular(AppRadius.r_16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(AppRadius.r_16),
          border: theme.brightness == Brightness.dark
              ? Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4))
              : null,
        ),
        child: InkWell(
          borderRadius: .circular(AppRadius.r_16),
          onTap: compact ? () => context.push(AppRoutes.post.resolve({'id': post.id})) : null,
          child: Padding(
            padding: const .all(AppSpacing.s_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeader(post: post),

                const SizedBox(height: AppSpacing.s_12),

                SelectableText(
                  post.content,
                  maxLines: compact ? 3 : null,
                  // overflow: TextOverflow.ellipsis, // TODO
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.42, fontSize: 15.5, overflow: TextOverflow.ellipsis),
                ),

                if (post.media.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s_12),

                  PostMediaGrid(media: post.media),
                ],

                const SizedBox(height: AppSpacing.s_8),

                PostActions(post: post, onLike: () {}, onComment: () {}, onShare: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
