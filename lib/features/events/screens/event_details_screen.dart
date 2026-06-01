import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fccu_societies_hub/core/router/app_router.dart';
import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/core/utils/number_formatter.dart';
import 'package:fccu_societies_hub/core/utils/show_auth_required_sheet.dart';
import 'package:fccu_societies_hub/core/widgets/app_error.dart';
import 'package:fccu_societies_hub/core/widgets/app_loading.dart';
import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';
import 'package:fccu_societies_hub/features/session/providers/session_permissions_provider.dart';
import 'package:fccu_societies_hub/models/event.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailsScreen({super.key, required this.eventId});

  Future<void> _toggleRsvp(WidgetRef ref, Event event) async {
    final uid = ref.read(currentUserProvider)?.uid;
    if (uid == null) return;
    final repo = ref.read(eventRepositoryProvider);
    if (event.isRsvped) {
      await repo.unrsvpEvent(event.id, uid);
    } else {
      await repo.rsvpEvent(event.id, uid);
    }
    ref.invalidate(eventProvider(event.id));
    ref.invalidate(eventsProvider);
  }

  Future<void> _openCalendar(Event event) async {
    // Google Calendar add-event URL
    final fmt = DateFormat("yyyyMMdd'T'HHmmss");
    final start = fmt.format(event.start);
    final end = fmt.format(event.end ?? event.start.add(const Duration(hours: 2)));
    final uri = Uri.https('calendar.google.com', '/calendar/render', {
      'action': 'TEMPLATE',
      'text': event.title,
      'dates': '$start/$end',
      'details': event.description,
      if (event.location != null) 'location': event.location!,
    });
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));
    final canReact = ref.watch(canReactProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return eventAsync.when(
      loading: () => const Scaffold(body: AppLoading()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppError(error: e, onRetry: () => ref.invalidate(eventProvider(eventId))),
      ),
      data: (event) {
        if (event == null) {
          return Scaffold(appBar: AppBar(), body: const Center(child: Text('Event not found')));
        }

        final dateFormat = DateFormat('EEE, MMM d, yyyy');
        final timeFormat = DateFormat('h:mm a');

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.groups_rounded),
                tooltip: 'View Society',
                onPressed: () =>
                    context.push(AppRoutes.society.resolve({'id': event.societyId})),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_today_rounded),
                tooltip: 'Add to Calendar',
                onPressed: () => _openCalendar(event),
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

                Text(event.title,
                    style: theme.textTheme.headlineMedium?.copyWith(height: 1.25)),

                const SizedBox(height: AppSpacing.s_8),

                GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.society.resolve({'id': event.societyId})),
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
                if (event.rsvpCount > 0) ...[
                  const SizedBox(height: AppSpacing.s_12),
                  _InfoTile(
                    icon: Icons.people_rounded,
                    label: 'Interested',
                    value: formatNumber(event.rsvpCount),
                  ),
                ],

                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s_24),
                  Text('About', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.s_8),
                  Text(event.description,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                ],

                const SizedBox(height: AppSpacing.s_32),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: canReact
                            ? () => _toggleRsvp(ref, event)
                            : () => showAuthRequiredSheet(context),
                        icon: Icon(
                          event.isRsvped
                              ? Icons.check_circle_rounded
                              : Icons.check_circle_outline_rounded,
                        ),
                        label: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s_12),
                          child: Text(event.isRsvped ? "I'm Going" : "I'm Interested"),
                        ),
                        style: event.isRsvped
                            ? FilledButton.styleFrom(
                                backgroundColor: colorScheme.secondaryContainer,
                                foregroundColor: colorScheme.onSecondaryContainer,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s_12),
                    OutlinedButton.icon(
                      onPressed: () => _openCalendar(event),
                      icon: const Icon(Icons.calendar_today_rounded, size: 18),
                      label: const Text('Calendar'),
                    ),
                  ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.s_12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 2),
              Text(value, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
