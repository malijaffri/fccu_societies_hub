import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/users/repositories/firestore_user_repository.dart';
import 'package:fccu_societies_hub/features/users/repositories/mock_user_repository.dart';
import 'package:fccu_societies_hub/features/users/repositories/user_repository.dart';
import 'package:fccu_societies_hub/models/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => FirestoreUserRepository());
// final userRepositoryProvider = Provider<UserRepository>((ref) => MockUserRepository());

final usersProvider = FutureProvider<List<UserModel>>((ref) async => ref.watch(userRepositoryProvider).fetchUsers());

final userProvider = FutureProvider.family<UserModel?, String>(
  (ref, userId) async => ref.watch(userRepositoryProvider).getUser(userId),
);
