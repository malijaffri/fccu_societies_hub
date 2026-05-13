import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';

class LinkedPostToggle extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  const LinkedPostToggle({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(AppSpacing.s_12),

    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerLow, borderRadius: .circular(18)),

    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,

            children: [
              Text('Also create post', style: Theme.of(context).textTheme.titleSmall),

              const SizedBox(height: 2),

              Text('Publish this event to the post feed.', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),

        Switch(value: value, onChanged: onChanged),
      ],
    ),
  );
}
