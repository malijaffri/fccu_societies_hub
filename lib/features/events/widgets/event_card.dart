import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,

      borderRadius: .circular(AppRadius.r_16),

      child: InkWell(
        borderRadius: .circular(AppRadius.r_16),

        onTap: () {},

        child: Padding(
          padding: const .all(AppSpacing.s_16),

          child: Column(
            crossAxisAlignment: .start,

            children: [
              Text(event.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: .w700)),

              const SizedBox(height: AppSpacing.s_8),

              Text(event.description, maxLines: 3, overflow: .ellipsis),

              const SizedBox(height: AppSpacing.s_16),

              Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 18, color: colorScheme.onSurfaceVariant),

                  const SizedBox(width: AppSpacing.s_8),

                  Expanded(
                    child: Text(
                      timeago.format(event.start, allowFromNow: true),

                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
