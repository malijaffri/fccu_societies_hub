import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/utils/time_formatter.dart';
import 'package:fccu_societies_hub/models/comment.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const .symmetric(horizontal: AppSpacing.s_16, vertical: AppSpacing.s_12),

      child: Row(
        crossAxisAlignment: .start,

        children: [
          Avatar(avatarUrl: comment.userAvatar, name: comment.userName),

          const SizedBox(width: AppSpacing.s_12),

          Expanded(
            child: Column(
              crossAxisAlignment: .start,

              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.userName,

                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),

                    Text(
                      TimeFormatter.formatPast(comment.createdAt),

                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.s_4),

                SelectableText(comment.content, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
