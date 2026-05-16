import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class AppError extends StatelessWidget {
  final Object error;

  final VoidCallback? onRetry;

  const AppError({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const .all(AppSpacing.s_20),

        child: Column(
          mainAxisSize: .min,

          children: [
            Icon(Icons.error_outline_rounded, size: 52, color: theme.colorScheme.error),

            const SizedBox(height: AppSpacing.s_16),

            Text('Something went wrong', style: theme.textTheme.titleLarge),

            const SizedBox(height: AppSpacing.s_8),

            Text(error.toString(), textAlign: .center, style: theme.textTheme.bodyMedium),

            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.s_20),

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
