import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/post.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class PostHeader extends StatelessWidget {
  final Post post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: .start,
      children: [
        Avatar(
          avatarUrl: post.societyImage,
          name: post.societyName,
          radius: 22,
          textStyle: theme.textTheme.titleMedium,
        ),

        const SizedBox(width: AppSpacing.s_12),

        Expanded(
          child: Padding(
            padding: const .only(top: AppSpacing.s_2),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(post.societyName, style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, fontWeight: .w600)),

                const SizedBox(height: AppSpacing.s_2),

                Text(
                  timeago.format(post.createdAt, locale: 'en_short'),
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),

        IconButton(onPressed: () {}, visualDensity: .compact, icon: const Icon(Icons.more_horiz_rounded)),
      ],
    );
  }
}
