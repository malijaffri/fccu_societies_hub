import 'package:firebase_auth/firebase_auth.dart';

import 'package:fccu_societies_hub/features/auth/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserCredential> signIn({required String email, required String password}) async =>
      await _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> register({required String email, required String password}) async =>
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> signOut() async => await _auth.signOut();
}
