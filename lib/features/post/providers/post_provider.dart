import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/post/providers/post_repository_provider.dart';
import 'package:fccu_societies_hub/models/post.dart';

final postProvider = FutureProvider.family<Post, String>(
  (ref, postId) async => ref.watch(postRepositoryProvider).fetchPost(postId),
);
