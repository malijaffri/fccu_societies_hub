import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/societies/providers/societies_repository_provider.dart';

final societiesProvider = FutureProvider((ref) async => ref.watch(societiesRepositoryProvider).fetchSocieties());
