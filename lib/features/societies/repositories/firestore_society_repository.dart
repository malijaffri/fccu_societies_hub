import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/models/society.dart';

class FirestoreSocietyRepository implements SocietyRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Society>> fetchSocieties({String? currentUserId}) async {
    final snapshot = await _db
        .collection('societies')
        .orderBy('name')
        .limit(50)
        .get();
    return snapshot.docs
        .map((d) => Society.fromMap(d.data(), currentUserId: currentUserId))
        .toList();
  }

  @override
  Future<Society?> getSociety(String societyId, {String? currentUserId}) async {
    final doc = await _db.collection('societies').doc(societyId).get();
    if (!doc.exists) return null;
    return Society.fromMap(doc.data()!, currentUserId: currentUserId);
  }

  @override
  Future<void> createSociety(Society society) async {
    final doc = _db.collection('societies').doc();
    await doc.set(society.copyWith(id: doc.id).toMap());
  }

  @override
  Future<void> updateSociety(Society society) async =>
      await _db.collection('societies').doc(society.id).set(society.toMap());

  @override
  Future<void> deleteSociety(String societyId) async =>
      await _db.collection('societies').doc(societyId).delete();

  @override
  Future<void> followSociety(String societyId, String userId) async {
    await _db.collection('societies').doc(societyId).update({
      'followerIds': FieldValue.arrayUnion([userId]),
      'followerCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> unfollowSociety(String societyId, String userId) async {
    await _db.collection('societies').doc(societyId).update({
      'followerIds': FieldValue.arrayRemove([userId]),
      'followerCount': FieldValue.increment(-1),
    });
  }

  @override
  Future<void> joinSociety(String societyId, String userId) async {
    await _db.collection('societies').doc(societyId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'memberCount': FieldValue.increment(1),
      // Joining also follows the society
      'followerIds': FieldValue.arrayUnion([userId]),
      'followerCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> leaveSociety(String societyId, String userId) async {
    await _db.collection('societies').doc(societyId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'memberCount': FieldValue.increment(-1),
    });
  }
}
