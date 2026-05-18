import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:fccu_societies_hub/features/events/providers/events_provider.dart';
import 'package:fccu_societies_hub/features/events/widgets/event_card.dart';
import 'package:fccu_societies_hub/models/event.dart';
import 'package:fccu_societies_hub/widgets/items_list.dart';

class EventsList extends ItemsList<Event> {
  static const noItemsYet = 'No events yet';
  static const noItemsFound = 'No events found';
  static const noItemsLong = 'Events from societies will appear here.';

  const EventsList({super.key, super.filter, super.userFilter, super.failMsg});

  @override
  IconData get icon => Icons.calendar_month_outlined;

  @override
  Widget itemCard(Event item) => EventCard(event: item);

  @override
  FutureProvider<List<Event>> get itemsProvider => eventsProvider;
}
