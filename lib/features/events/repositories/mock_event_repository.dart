import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/mock/mock_events.dart';
import 'package:fccu_societies_hub/models/event.dart';

class MockEventRepository implements EventRepository {
  @override
  Future<List<Event>> fetchEvents() async {
    await Future.delayed(const Duration(seconds: 1));

    return mockEvents;
  }

  @override
  Future<Event?> getEvent(String eventId) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      return mockEvents.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> createEvent(Event event) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updateEvent(Event event) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deleteEvent(String eventId) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<List<Event>> fetchEventsBySociety(String societyId) {
    // TODO: implement fetchEventsBySociety
    throw UnimplementedError();
  }
}
