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
