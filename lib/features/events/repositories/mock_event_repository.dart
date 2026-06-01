import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/mock/mock_events.dart';
import 'package:fccu_societies_hub/models/event.dart';

class MockEventRepository implements EventRepository {
  @override
  Future<List<Event>> fetchEvents({String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockEvents;
  }

  @override
  Future<List<Event>> fetchEventsBySociety(String societyId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    return mockEvents.where((e) => e.societyId == societyId).toList();
  }

  @override
  Future<Event?> getEvent(String eventId, {String? currentUserId}) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return mockEvents.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createEvent(Event event) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updateEvent(Event event) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deleteEvent(String eventId) async => Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> rsvpEvent(String eventId, String userId) async =>
      Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<void> unrsvpEvent(String eventId, String userId) async =>
      Future.delayed(const Duration(milliseconds: 300));
}
