import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/models/event.dart';

class FirestoreEventRepository implements EventRepository {
  final _db = FirebaseFirestore.instance;

  String _rsvpId(String userId, String eventId) => '${userId}_$eventId';

  @override
  Future<List<Event>> fetchEvents({String? currentUserId}) async {
    final snapshot = await _db
        .collection('events')
        .orderBy('start', descending: false)
        .limit(50)
        .get();
    final events = snapshot.docs.map((d) => Event.fromMap(d.data())).toList();
    if (currentUserId == null) return events;
    return _attachRsvp(events, currentUserId);
  }

  @override
  Future<List<Event>> fetchEventsBySociety(String societyId, {String? currentUserId}) async {
    final snapshot = await _db
        .collection('events')
        .where('societyId', isEqualTo: societyId)
        .orderBy('start', descending: false)
        .limit(20)
        .get();
    final events = snapshot.docs.map((d) => Event.fromMap(d.data())).toList();
    if (currentUserId == null) return events;
    return _attachRsvp(events, currentUserId);
  }

  @override
  Future<Event?> getEvent(String eventId, {String? currentUserId}) async {
    final doc = await _db.collection('events').doc(eventId).get();
    if (!doc.exists) return null;
    final event = Event.fromMap(doc.data()!);
    if (currentUserId == null) return event;
    final rsvpDoc = await _db
        .collection('event_rsvps')
        .doc(_rsvpId(currentUserId, eventId))
        .get();
    return event.copyWith(isRsvped: rsvpDoc.exists);
  }

  Future<List<Event>> _attachRsvp(List<Event> events, String userId) async {
    if (events.isEmpty) return events;
    final rsvpSnap = await _db
        .collection('event_rsvps')
        .where('userId', isEqualTo: userId)
        .get();
    final rsvpedIds = rsvpSnap.docs
        .map((d) => d.data()['eventId'] as String)
        .toSet();
    return events
        .map((e) => e.copyWith(isRsvped: rsvpedIds.contains(e.id)))
        .toList();
  }

  @override
  Future<String> createEvent(Event event) async {
    final doc = _db.collection('events').doc();
    await doc.set(event.copyWith(id: doc.id).toMap());
    return doc.id;
  }

  @override
  Future<void> updateEventField(String eventId, Map<String, dynamic> fields) async =>
      _db.collection('events').doc(eventId).update(fields);

  @override
  Future<void> updateEvent(Event event) async =>
      _db.collection('events').doc(event.id).set(event.toMap());

  @override
  Future<void> deleteEvent(String eventId) async =>
      _db.collection('events').doc(eventId).delete();

  @override
  Future<void> rsvpEvent(String eventId, String userId) async {
    final batch = _db.batch();
    final rsvpRef = _db.collection('event_rsvps').doc(_rsvpId(userId, eventId));
    batch.set(rsvpRef, {'userId': userId, 'eventId': eventId});
    batch.update(_db.collection('events').doc(eventId), {
      'rsvpCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  @override
  Future<void> unrsvpEvent(String eventId, String userId) async {
    final batch = _db.batch();
    batch.delete(_db.collection('event_rsvps').doc(_rsvpId(userId, eventId)));
    batch.update(_db.collection('events').doc(eventId), {
      'rsvpCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }
}
