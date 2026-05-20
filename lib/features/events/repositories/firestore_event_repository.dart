import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/events/repositories/event_repository.dart';
import 'package:fccu_societies_hub/models/event.dart';

class FirestoreEventRepository implements EventRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Event>> fetchEvents() async {
    final snapshot = await _db.collection('events').orderBy('createdAt', descending: true).limit(20).get();

    return snapshot.docs.map((d) => Event.fromMap(d.data())).toList();
  }

  @override
  Future<Event> getEvent(String eventId) async {
    final doc = await _db.collection('events').doc(eventId).get();

    return Event.fromMap(doc.data()!);
  }

  @override
  Future<void> createEvent(Event event) async => await _db.collection('events').doc(event.id).set(event.toMap());

  @override
  Future<void> updateEvent(Event event) async => await _db.collection('events').doc(event.id).set(event.toMap());

  @override
  Future<void> deleteEvent(String eventId) async => await _db.collection('events').doc(eventId).delete();
}
