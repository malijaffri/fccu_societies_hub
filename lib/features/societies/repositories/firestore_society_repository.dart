import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/models/society.dart';

class FirestoreSocietyRepository implements SocietyRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Society>> fetchSocieties() async {
    final snapshot = await _db.collection('societies').orderBy('createdAt', descending: true).limit(20).get();

    return snapshot.docs.map((d) => Society.fromMap(d.data())).toList();
  }

  @override
  Future<Society> getSociety(String societyId) async {
    final doc = await _db.collection('societies').doc(societyId).get();

    return Society.fromMap(doc.data()!);
  }

  @override
  Future<void> createSociety(Society society) async =>
      await _db.collection('societies').doc(society.id).set(society.toMap());

  @override
  Future<void> updateSociety(Society society) async =>
      await _db.collection('societies').doc(society.id).set(society.toMap());

  @override
  Future<void> deleteSociety(String societyId) async => await _db.collection('societies').doc(societyId).delete();
}
