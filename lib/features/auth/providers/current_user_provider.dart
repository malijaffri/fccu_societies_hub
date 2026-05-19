import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fccu_societies_hub/features/auth/providers/auth_state_provider.dart';

final currentUserProvider = Provider<User?>((ref) => ref.watch(authStateProvider).value);
