import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/session/models/session_mode.dart';
import 'package:fccu_societies_hub/features/session/providers/session_repository_provider.dart';

final sessionModeProvider = FutureProvider<SessionMode>((ref) async {
  final firebaseUser = ref.watch(currentUserProvider);

  if (firebaseUser != null) {
    return SessionMode.authenticated;
  }

  return ref.watch(sessionRepositoryProvider).loadSessionMode();
});
