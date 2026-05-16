import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/posts/providers/posts_repository_provider.dart';

final postProvider = FutureProvider.family(
  (ref, String postId) async => ref.watch(postsRepositoryProvider).fetchPost(postId),
);
