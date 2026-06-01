import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/auth/providers/current_user_provider.dart';
import 'package:fccu_societies_hub/features/societies/repositories/firestore_society_repository.dart';
import 'package:fccu_societies_hub/features/societies/repositories/society_repository.dart';
import 'package:fccu_societies_hub/models/society.dart';

final societyRepositoryProvider =
    Provider<SocietyRepository>((ref) => FirestoreSocietyRepository());

final societiesProvider = FutureProvider<List<Society>>((ref) async {
  final currentUserId = ref.watch(currentUserProvider)?.uid;
  return ref
      .watch(societyRepositoryProvider)
      .fetchSocieties(currentUserId: currentUserId);
});

final societyProvider = FutureProvider.family<Society?, String>(
  (ref, societyId) async {
    final currentUserId = ref.watch(currentUserProvider)?.uid;
    return ref
        .watch(societyRepositoryProvider)
        .getSociety(societyId, currentUserId: currentUserId);
  },
);
