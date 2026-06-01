import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/features/events/repositories/firestore_event_repository.dart';
import 'package:fccu_societies_hub/models/event.dart';

final eventRepositoryProvider =
    Provider<EventRepository>((ref) => FirestoreEventRepository());

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(eventRepositoryProvider).fetchEvents(currentUserId: currentUserId);
});

final eventProvider = FutureProvider.family<Event?, String>((ref, eventId) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref.watch(eventRepositoryProvider).getEvent(eventId, currentUserId: currentUserId);
});

final societyEventsProvider = FutureProvider.family<List<Event>, String>((ref, societyId) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref
      .watch(eventRepositoryProvider)
      .fetchEventsBySociety(societyId, currentUserId: currentUserId);
});
