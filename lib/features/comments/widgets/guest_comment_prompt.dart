import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class GuestCommentPrompt extends StatelessWidget {
  const GuestCommentPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const .all(AppSpacing.s_16),

      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,

        border: Border(top: .new(color: theme.colorScheme.outlineVariant)),
      ),

      child: Row(
        children: [
          Expanded(child: Text('Login to join the discussion.', style: theme.textTheme.bodyMedium)),

          FilledButton(onPressed: () => context.go(AppRoutes.welcome), child: const Text('Login')),
        ],
      ),
    );
  }
}
