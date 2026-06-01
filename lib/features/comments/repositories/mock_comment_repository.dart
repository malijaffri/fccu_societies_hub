import 'package:fccu_societies_hub/features/comments/repositories/comment_repository.dart';
import 'package:fccu_societies_hub/mock/mock_comments.dart';
import 'package:fccu_societies_hub/models/comment.dart';

class MockCommentRepository implements CommentRepository {
  @override
  Future<List<Comment>> fetchComments(String postId) async {
    await Future.delayed(const Duration(seconds: 1));

    return mockComments.where((comment) => comment.postId == postId).toList();
  }

  @override
  Future<void> createComment(Comment comment) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> updateComment(Comment comment) async => await Future.delayed(const Duration(seconds: 1));

  @override
  Future<void> deleteComment(String commentId) async => await Future.delayed(const Duration(seconds: 1));
}
