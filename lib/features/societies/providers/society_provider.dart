import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/societies/providers/societies_repository_provider.dart';

final societyProvider = FutureProvider.family(
  (ref, String societyId) async => ref.watch(societiesRepositoryProvider).fetchSociety(societyId),
);
