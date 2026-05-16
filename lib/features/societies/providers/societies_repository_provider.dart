import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/societies/repositories/societies_repository.dart';

final societiesRepositoryProvider = Provider<SocietiesRepository>((ref) => MockSocietiesRepository());
