import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/models/society.dart';

class FirestoreSocietyRepository implements SocietyRepository {
  final _db = FirebaseFirestore.instance;

  // Document ID convention: "{userId}_{societyId}" allows a single get() to
  // check follow/membership status without an extra query.
  String _followId(String userId, String societyId) => '${userId}_$societyId';
  String _membershipId(String userId, String societyId) => '${userId}_$societyId';

  // ---------- helpers --------------------------------------------------

  Future<Set<String>> _followedIds(String userId) async {
    final snap = await _db
        .collection('follows')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.map((d) => d.data()['societyId'] as String).toSet();
  }

  Future<Set<String>> _memberIds(String userId) async {
    final snap = await _db
        .collection('memberships')
        .where('userId', isEqualTo: userId)
        .get();
    return snap.docs.map((d) => d.data()['societyId'] as String).toSet();
  }

  // ---------- reads ----------------------------------------------------

  @override
  Future<List<Society>> fetchSocieties({String? currentUserId}) async {
    final snapshot =
        await _db.collection('societies').orderBy('name').limit(50).get();
    final societies =
        snapshot.docs.map((d) => Society.fromMap(d.data())).toList();

    if (currentUserId == null) return societies;

    final [followedSet, memberSet] = await Future.wait([
      _followedIds(currentUserId),
      _memberIds(currentUserId),
    ]);

    return societies
        .map((s) => s.copyWith(
              isFollowed: followedSet.contains(s.id),
              isMember: memberSet.contains(s.id),
            ))
        .toList();
  }

  @override
  Future<Society?> getSociety(String societyId, {String? currentUserId}) async {
    final doc = await _db.collection('societies').doc(societyId).get();
    if (!doc.exists) return null;

    final society = Society.fromMap(doc.data()!);

    if (currentUserId == null) return society;

    final [followSnap, memberSnap] = await Future.wait([
      _db.collection('follows').doc(_followId(currentUserId, societyId)).get(),
      _db.collection('memberships').doc(_membershipId(currentUserId, societyId)).get(),
    ]);

    return society.copyWith(
      isFollowed: followSnap.exists,
      isMember: memberSnap.exists,
    );
  }

  // ---------- writes ---------------------------------------------------

  @override
  Future<void> createSociety(Society society) async {
    final doc = _db.collection('societies').doc();
    await doc.set(society.copyWith(id: doc.id).toMap());
  }

  @override
  Future<void> updateSociety(Society society) async =>
      _db.collection('societies').doc(society.id).set(society.toMap());

  @override
  Future<void> deleteSociety(String societyId) async =>
      _db.collection('societies').doc(societyId).delete();

  // ---------- follow / unfollow ----------------------------------------

  @override
  Future<void> followSociety(String societyId, String userId) async {
    final batch = _db.batch();
    final followRef =
        _db.collection('follows').doc(_followId(userId, societyId));
    batch.set(followRef, {'userId': userId, 'societyId': societyId});
    batch.update(_db.collection('societies').doc(societyId), {
      'followerCount': FieldValue.increment(1),
    });
    await batch.commit();
  }

  @override
  Future<void> unfollowSociety(String societyId, String userId) async {
    final batch = _db.batch();
    batch.delete(_db.collection('follows').doc(_followId(userId, societyId)));
    batch.update(_db.collection('societies').doc(societyId), {
      'followerCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }

  // ---------- join / leave (membership implies follow) -----------------

  @override
  Future<void> joinSociety(String societyId, String userId) async {
    final batch = _db.batch();

    // Membership
    final memberRef =
        _db.collection('memberships').doc(_membershipId(userId, societyId));
    batch.set(memberRef, {
      'userId': userId,
      'societyId': societyId,
      'permissions': <String>[],
    });

    // Also follow if not already following
    final followRef =
        _db.collection('follows').doc(_followId(userId, societyId));
    batch.set(followRef, {'userId': userId, 'societyId': societyId});

    batch.update(_db.collection('societies').doc(societyId), {
      'memberCount': FieldValue.increment(1),
      'followerCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  @override
  Future<void> leaveSociety(String societyId, String userId) async {
    final batch = _db.batch();
    batch.delete(
        _db.collection('memberships').doc(_membershipId(userId, societyId)));
    batch.update(_db.collection('societies').doc(societyId), {
      'memberCount': FieldValue.increment(-1),
    });
    await batch.commit();
  }
}
