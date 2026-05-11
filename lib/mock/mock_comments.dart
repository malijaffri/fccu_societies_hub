import 'package:fccu_societies_hub/models/comment.dart';

List<Comment> mockComments({required String postId, int count = 10, String? id}) => List.generate(
  count,
  (i) => Comment(
    id: id ?? 'comment_$i',
    postId: postId,
    userId: 'user_$i',
    userName: 'Ali',
    userAvatar: null,
    content: 'This is a sample post #$i',
    createdAt: DateTime.now().subtract(Duration(hours: i)),
  ),
);
