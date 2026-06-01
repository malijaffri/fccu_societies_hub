import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return eventAsync.when(
      loading: () => const Scaffold(body: AppLoading()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppError(error: error, onRetry: () => ref.invalidate(eventProvider(eventId))),
      ),
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Event not found')),
          );
        }

        final dateFormat = DateFormat('EEE, MMM d, yyyy');
        final timeFormat = DateFormat('h:mm a');

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.groups_rounded),
                tooltip: 'View Society',
                onPressed: () => context.push(AppRoutes.society.resolve({'id': event.societyId})),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      event.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),

                if (event.imageUrl != null) const SizedBox(height: AppSpacing.s_16),

                Text(
                  event.title,
                  style: theme.textTheme.headlineMedium?.copyWith(height: 1.25),
                ),

                const SizedBox(height: AppSpacing.s_8),

                GestureDetector(
                  onTap: () => context.push(AppRoutes.society.resolve({'id': event.societyId})),
                  child: Text(
                    event.societyName,
                    style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary),
                  ),
                ),

                const SizedBox(height: AppSpacing.s_20),

                _InfoTile(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date',
                  value: dateFormat.format(event.start),
                ),

                const SizedBox(height: AppSpacing.s_12),

                _InfoTile(
                  icon: Icons.schedule_rounded,
                  label: 'Time',
                  value: event.end != null
                      ? '${timeFormat.format(event.start)} – ${timeFormat.format(event.end!)}'
                      : timeFormat.format(event.start),
                ),

                if (event.location != null) ...[
                  const SizedBox(height: AppSpacing.s_12),
                  _InfoTile(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    value: event.location!,
                  ),
                ],

                const SizedBox(height: AppSpacing.s_24),

                if (event.description.isNotEmpty) ...[
                  Text('About', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s_8),
                  Text(event.description, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                ],

                const SizedBox(height: AppSpacing.s_32),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('RSVP feature coming soon')),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.s_12),
                      child: Text('RSVP / I\'m Interested'),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.s_16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.s_12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
