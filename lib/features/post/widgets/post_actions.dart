import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/utils/number_formatter.dart';
import 'package:fccu_societies_hub/models/post.dart';

class PostActions extends StatelessWidget {
  final Post post;

  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;

  const PostActions({super.key, required this.post, this.onLike, this.onComment, this.onShare});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        _ActionButton(
          icon: post.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: post.isLiked ? Colors.red : colorScheme.onSurfaceVariant,
          label: formatNumber(post.likeCount),
          onTap: onLike,
        ),

        const SizedBox(width: AppSpacing.s_20),

        _ActionButton(
          icon: Icons.mode_comment_outlined,
          color: colorScheme.onSurfaceVariant,
          label: formatNumber(post.commentCount),
          onTap: onComment,
        ),

        const SizedBox(width: AppSpacing.s_20),

        _ActionButton(icon: Icons.share_outlined, color: colorScheme.onSurfaceVariant, onTap: onShare),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String? label;

  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.color, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: .circular(AppRadius.pill),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s_8),
        child: Row(
          children: [
            Icon(icon, size: 21, color: color),

            if (label != null) ...[
              const SizedBox(width: 6),

              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: .w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
