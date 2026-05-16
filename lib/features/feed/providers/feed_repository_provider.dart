import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/feed/repositories/feed_repository.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) => MockFeedRepository());
