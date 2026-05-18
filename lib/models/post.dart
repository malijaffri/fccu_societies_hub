import 'media.dart';

class Post {
  final String id;

  final String societyId;
  final String societyName;
  final String? societyImage;
  final bool isFollowed;

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
    required this.isFollowed,
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

  factory Post.fromMap(Map<String, dynamic> map) => Post(
    id: map['id'],
    societyId: map['societyId'],
    societyName: map['societyName'],
    societyImage: map['societyImage'],
    isFollowed: map['isFollowed'],
    authorId: map['authorId'],
    authorName: map['authorName'],
    content: map['content'],
    media: map['media'],
    likeCount: map['likeCount'],
    commentCount: map['commentCount'],
    isLiked: map['isLiked'],
    createdAt: map['createdAt'],
    eventId: map['eventId'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'societyId': societyId,
    'societyName': societyName,
    'societyImage': societyImage,
    'isFollowed': isFollowed,
    'authorId': authorId,
    'authorName': authorName,
    'content': content,
    'media': media,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'isLiked': isLiked,
    'createdAt': createdAt,
    'eventId': eventId,
  };

  Post copyWith({
    String? id,
    String? societyId,
    String? societyName,
    String? societyImage,
    bool? isFollowed,
    String? authorId,
    String? authorName,
    String? content,
    List<Media>? media,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    DateTime? createdAt,
    String? eventId,
  }) => Post(
    id: id ?? this.id,
    societyId: societyId ?? this.societyId,
    societyName: societyName ?? this.societyName,
    societyImage: societyImage ?? this.societyImage,
    isFollowed: isFollowed ?? this.isFollowed,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    content: content ?? this.content,
    media: media ?? this.media,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount ?? this.commentCount,
    isLiked: isLiked ?? this.isLiked,
    createdAt: createdAt ?? this.createdAt,
    eventId: eventId ?? this.eventId,
  );
}
