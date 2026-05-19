import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/session/repositories/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) => LocalSessionRepository());
