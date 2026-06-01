import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/society.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class SocietyCard extends StatelessWidget {
  final Society society;
  final bool compact;
  final VoidCallback? onFollow;

  const SocietyCard({super.key, required this.society, this.compact = true, this.onFollow});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s_16, vertical: AppSpacing.s_8),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.r_16),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.r_16),
          onTap: () => context.push('/society/${society.id}'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s_16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Avatar(
                  avatarUrl: society.imageUrl,
                  name: society.name,
                  radius: 26,
                  backgroundColor: colorScheme.primaryContainer,
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.s_12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(society.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      if (!compact && society.description != null) ...[
                        const SizedBox(height: AppSpacing.s_4),
                        Text(
                          society.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.s_8),
                      Text(
                        '${society.memberCount} members',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s_12),
                FilledButton.tonal(
                  onPressed: society.isFollowed ? null : onFollow,
                  child: Text(society.isFollowed ? 'Following' : 'Follow'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
