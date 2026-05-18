import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/models/society.dart';

final societiesRepositoryProvider = Provider<SocietyRepository>((ref) => MockSocietyRepository());

final societiesProvider = FutureProvider<List<Society>>(
  (ref) async => ref.watch(societiesRepositoryProvider).fetchSocieties(),
);

final societyProvider = FutureProvider.family<Society, String>(
  (ref, societyId) async => ref.watch(societiesRepositoryProvider).fetchSociety(societyId),
);
