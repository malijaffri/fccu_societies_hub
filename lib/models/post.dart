import 'media.dart';

class Post {
  final String id;

  final String societyId;
  final String societyName;
  final String? societyImage;

  final String authorId;
  final String authorName;

  final String content;

  final List<Media> media;

  final int likeCount;
  final int commentCount;
  final bool isLiked;

  final DateTime createdAt;

  final String? eventId;

  const Post({
    required this.id,
    required this.societyId,
    required this.societyName,
    this.societyImage,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.media,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
    this.eventId,
  });
}

List<Post> mockPosts = List.generate(10, (i) {
  return Post(
    id: 'post_$i',
    societyId: 'soc_1',
    societyName: 'CS Society',
    societyImage: null,
    authorId: 'user_1',
    authorName: 'Ali',
    content: 'This is a sample post #$i',
    media: [],
    likeCount: i * 3,
    commentCount: i,
    isLiked: i % 2 == 0,
    createdAt: DateTime.now().subtract(Duration(hours: i)),
  );
});
