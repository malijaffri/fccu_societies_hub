import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/comments/providers/comments_repository_provider.dart';
import 'package:fccu_societies_hub/models/comment.dart';

final commentsProvider = FutureProvider.family<List<Comment>, String>(
  (ref, postId) async => ref.watch(commentsRepositoryProvider).fetchComments(postId),
);
