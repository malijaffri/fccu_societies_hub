import 'package:fccu_societies_hub/mock/mock_comments.dart';
import 'package:fccu_societies_hub/models/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> fetchComments(String postId);
}

class MockCommentsRepository implements CommentsRepository {
  @override
  Future<List<Comment>> fetchComments(String postId) async {
    await Future.delayed(const .new(seconds: 1));

    return mockComments.where((comment) => comment.postId == postId).toList();
  }
}
