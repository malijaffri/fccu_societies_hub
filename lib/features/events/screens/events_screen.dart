import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/events/widgets/events_list.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Events'),

      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded))],
    ),

    body: EventsList(),
  );
}
