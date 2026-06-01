import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:fccu_societies_hub/core/theme/app_radius.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final bool compact;

  const EventCard({super.key, required this.event, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.r_16),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r_16),
        onTap: () => context.push('/event/${event.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.s_8),
              Text(event.description, maxLines: compact ? 3 : null, overflow: TextOverflow.ellipsis),
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
              if (event.location != null) ...[
                const SizedBox(height: AppSpacing.s_8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 18, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.s_8),
                    Expanded(
                      child: Text(
                        event.location!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
