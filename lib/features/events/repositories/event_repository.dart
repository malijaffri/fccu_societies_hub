import 'package:fccu_societies_hub/models/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents({String? currentUserId});

  Future<List<Event>> fetchEventsBySociety(String societyId, {String? currentUserId});

  Future<Event?> getEvent(String eventId, {String? currentUserId});

  Future<void> createEvent(Event event);

  Future<void> updateEvent(Event event);

  Future<void> deleteEvent(String eventId);

  Future<void> rsvpEvent(String eventId, String userId);

  Future<void> unrsvpEvent(String eventId, String userId);
}
