import 'package:fccu_societies_hub/mock/mock_events.dart';
import 'package:fccu_societies_hub/models/event.dart';

abstract class EventsRepository {
  Future<List<Event>> fetchEvents();

  Future<Event> fetchEvent(String eventId);
}

class MockEventsRepository implements EventsRepository {
  @override
  Future<List<Event>> fetchEvents() async {
    await Future.delayed(const .new(seconds: 1));

    return mockEvents;
  }

  @override
  Future<Event> fetchEvent(String eventId) async {
    await Future.delayed(const .new(seconds: 1));

    return mockEvents.firstWhere((event) => event.id == eventId);
  }
}
