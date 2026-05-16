import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/feed/providers/feed_repository_provider.dart';
import 'package:fccu_societies_hub/models/post.dart';

final feedProvider = FutureProvider<List<Post>>((ref) async => ref.watch(feedRepositoryProvider).fetchFeed());
