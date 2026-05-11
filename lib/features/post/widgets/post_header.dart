import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/utils/time_formatter.dart';
import 'package:fccu_societies_hub/models/post.dart';

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
        CircleAvatar(
          radius: 22,
          backgroundColor: colorScheme.secondaryContainer,
          backgroundImage: post.societyImage != null ? NetworkImage(post.societyImage!) : null,
          child: post.societyImage == null
              ? Text(
                  post.societyName.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join().toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: .w700,
                    color: colorScheme.onSecondaryContainer,
                  ),
                )
              : null,
        ),

        const SizedBox(width: AppSpacing.s_12),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s_2),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(post.societyName, style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, fontWeight: .w600)),

                const SizedBox(height: AppSpacing.s_2),

                Text(
                  TimeFormatter.formatPast(post.createdAt),
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
