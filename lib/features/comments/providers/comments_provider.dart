import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/comments/providers/comments_repository_provider.dart';

final commentsProvider = FutureProvider.family(
  (ref, String postId) async => ref.watch(commentsRepositoryProvider).fetchComments(postId),
);
