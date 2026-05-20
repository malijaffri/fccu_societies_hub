import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/features/events/repositories/firestore_event_repository.dart';
import 'package:fccu_societies_hub/features/events/repositories/mock_event_repository.dart';
import 'package:fccu_societies_hub/models/event.dart';

// final eventsRepositoryProvider = Provider<EventRepository>((ref) => FirestoreEventRepository());
final eventsRepositoryProvider = Provider<EventRepository>((ref) => MockEventRepository());

final eventsProvider = FutureProvider<List<Event>>((ref) async => ref.watch(eventsRepositoryProvider).fetchEvents());

final eventProvider = FutureProvider.family<Event, String>(
  (ref, eventId) async => ref.watch(eventsRepositoryProvider).getEvent(eventId),
);
