import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/features/comments/repositories/firestore_comment_repository.dart';
import 'package:fccu_societies_hub/models/comment.dart';

// final commentRepositoryProvider = Provider<CommentRepository>((ref) => MockCommentRepository());
final commentRepositoryProvider = Provider<CommentRepository>((ref) => FirestoreCommentRepository());

final commentsProvider = FutureProvider.family<List<Comment>, String>(
  (ref, postId) async => ref.watch(commentRepositoryProvider).fetchComments(postId),
);
