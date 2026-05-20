import 'package:fccu_societies_hub/models/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> fetchComments(String postId);

  Future<void> createComment(Comment comment);

  Future<void> updateComment(Comment comment);

  Future<void> deleteComment(String commentId);
}
