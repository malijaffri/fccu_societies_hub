import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/users/providers/users_provider.dart';
import 'package:fccu_societies_hub/models/user_model.dart';

final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final firebaseUser = ref.watch(currentUserProvider);

  if (firebaseUser == null) {
    return null;
  }

  return ref.watch(userRepositoryProvider).getUser(firebaseUser.uid);
});
