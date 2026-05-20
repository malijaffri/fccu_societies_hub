import 'package:fccu_societies_hub/models/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents();

  Future<Event> getEvent(String eventId);

  Future<void> createEvent(Event event);

  Future<void> updateEvent(Event event);

  Future<void> deleteEvent(String eventId);
}
