import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/events/providers/events_repository_provider.dart';

final eventsProvider = FutureProvider((ref) async => ref.watch(eventsRepositoryProvider).fetchEvents());
