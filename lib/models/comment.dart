class Comment {
  final String id;

  final String postId;

  final String userId;
  final String userName;
  final String? userAvatar;

  final String content;

  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
  });
}
