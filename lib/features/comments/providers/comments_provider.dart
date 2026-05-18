import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/models/comment.dart';

final commentsRepositoryProvider = Provider<CommentRepository>((ref) => MockCommentRepository());

final commentsProvider = FutureProvider.family<List<Comment>, String>(
  (ref, postId) async => ref.watch(commentsRepositoryProvider).fetchComments(postId),
);
