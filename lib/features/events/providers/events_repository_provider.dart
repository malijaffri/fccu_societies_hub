import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/events/repositories/events_repository.dart';

final eventsRepositoryProvider = Provider<EventsRepository>((ref) => MockEventsRepository());
