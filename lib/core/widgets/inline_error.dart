import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class InlineError extends StatelessWidget {
  final Object error;

  final VoidCallback? onRetry;

  const InlineError({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const .all(AppSpacing.s_16),

      child: Column(
        mainAxisSize: .min,

        children: [
          Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),

          const SizedBox(height: AppSpacing.s_12),

          Text('Something went wrong', style: theme.textTheme.titleMedium),

          const SizedBox(height: AppSpacing.s_8),

          Text(error.toString(), textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),

          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s_16),

            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}
