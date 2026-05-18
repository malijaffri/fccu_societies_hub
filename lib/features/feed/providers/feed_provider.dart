import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/feed/repositories/feed_repository.dart';
import 'package:fccu_societies_hub/models/post.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) => MockFeedRepository());

final feedProvider = FutureProvider<List<Post>>((ref) async => ref.watch(feedRepositoryProvider).fetchFeed());
