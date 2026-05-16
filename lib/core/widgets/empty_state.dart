import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;

  final String title;

  final String? subtitle;

  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const .all(AppSpacing.s_20),

        child: Column(
          mainAxisSize: .min,

          children: [
            Icon(icon, size: 56, color: theme.colorScheme.onSurfaceVariant),

            const SizedBox(height: AppSpacing.s_16),

            Text(title, style: theme.textTheme.titleLarge, textAlign: .center),

            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.s_8),

              Text(
                subtitle!,

                textAlign: .center,

                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
