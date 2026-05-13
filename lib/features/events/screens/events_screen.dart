import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/core/theme/app_spacing.dart';
import 'package:fccu_societies_hub/features/events/widgets/event_card.dart';
import 'package:fccu_societies_hub/mock/mock_events.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Events'),

      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded))],
    ),

    body: ListView.separated(
      padding: const .all(AppSpacing.s_16),

      itemCount: mockEvents.length,

      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s_12),

      itemBuilder: (context, index) => EventCard(event: mockEvents[index]),
    ),
  );
}
