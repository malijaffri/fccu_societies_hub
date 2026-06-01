import 'package:firebase_auth/firebase_auth.dart';

import 'package:fccu_societies_hub/features/users/repositories/user_repository.dart';
import 'package:fccu_societies_hub/models/user_model.dart';

class UserProvisioningService {
  final UserRepository userRepository;

  UserProvisioningService({required this.userRepository});

  Future<void> provisionUser(User firebaseUser, {String? displayName}) async {
    final existingUser = await userRepository.getUser(firebaseUser.uid);

    if (existingUser != null) {
      return;
    }

    final name = displayName?.trim().isNotEmpty == true
        ? displayName!.trim()
        : firebaseUser.displayName ?? 'Unnamed User';

    final user = UserModel(
      id: firebaseUser.uid,
      name: name,
      email: firebaseUser.email ?? '',
      avatarUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );

    await userRepository.createUser(user);
  }
}
