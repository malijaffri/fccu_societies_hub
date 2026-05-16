import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/widgets/avatar.dart';

class CommentComposer extends StatelessWidget {
  const CommentComposer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const .fromLTRB(AppSpacing.s_12, AppSpacing.s_8, AppSpacing.s_12, AppSpacing.s_12),

      decoration: BoxDecoration(
        color: colorScheme.surface,

        border: Border(top: .new(color: colorScheme.outlineVariant.withValues(alpha: 0.4))),
      ),

      child: Row(
        crossAxisAlignment: .end,

        children: [
          const Avatar(),

          const SizedBox(width: AppSpacing.s_12),

          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 5,

              textCapitalization: .sentences,

              decoration: .new(
                hintText: 'Write a comment...',

                isDense: true,

                contentPadding: const .all(AppSpacing.s_12),

                border: OutlineInputBorder(borderRadius: .circular(AppRadius.r_24)),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.s_8),

          IconButton.filled(onPressed: () {}, icon: const Icon(Icons.send_rounded)),
        ],
      ),
    );
  }
}
