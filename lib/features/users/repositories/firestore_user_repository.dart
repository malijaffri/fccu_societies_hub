import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fccu_societies_hub/features/users/repositories/user_repository.dart';
import 'package:fccu_societies_hub/models/user_model.dart';

class FirestoreUserRepository implements UserRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<UserModel>> fetchUsers() async {
    final snapshot = await _db.collection('users').orderBy('createdAt', descending: true).limit(20).get();

    return snapshot.docs.map((d) => UserModel.fromMap(d.data())).toList();
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();

    return UserModel.fromMap(doc.data()!);
  }

  @override
  Future<void> createUser(UserModel user) async => await _db.collection('users').doc(user.id).set(user.toMap());

  @override
  Future<void> updateUser(UserModel user) async => await _db.collection('users').doc(user.id).set(user.toMap());

  @override
  Future<void> deleteUser(String userId) async => await _db.collection('users').doc(userId).delete();
}
