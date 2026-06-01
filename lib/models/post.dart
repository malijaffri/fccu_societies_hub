import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:fccu_societies_hub/models/media.dart';

class Post extends Equatable {
  final String id;

  final String societyId;
  final String societyName;
  final String? societyImage;
  final bool isFollowed;

  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;

  final String content;

  final List<Media> media;

  final List<String> likerIds;
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
    this.authorAvatarUrl,
    required this.content,
    required this.media,
    required this.likerIds,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
    this.eventId,
  });

  factory Post.fromMap(Map<String, dynamic> map, {String? currentUserId}) {
    final likerIds = List<String>.from(map['likerIds'] ?? []);
    return Post(
      id: map['id'] as String,
      societyId: map['societyId'] as String,
      societyName: map['societyName'] as String,
      societyImage: map['societyImage'] as String?,
      isFollowed: false,
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      authorAvatarUrl: map['authorAvatarUrl'] as String?,
      content: map['content'] as String,
      media: (map['media'] as List<dynamic>? ?? [])
          .map((e) => Media.fromMap(e as Map<String, dynamic>))
          .toList(),
      likerIds: likerIds,
      likeCount: likerIds.length,
      commentCount: map['commentCount'] as int? ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isLiked: currentUserId != null && likerIds.contains(currentUserId),
      eventId: map['eventId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'societyId': societyId,
    'societyName': societyName,
    'societyImage': societyImage,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatarUrl': authorAvatarUrl,
    'createdAt': Timestamp.fromDate(createdAt),
    'content': content,
    'media': media.map((m) => m.toMap()).toList(),
    'likerIds': likerIds,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'eventId': eventId,
  };

  Post copyWith({
    String? id,
    DateTime? createdAt,
    String? societyId,
    String? societyName,
    String? societyImage,
    bool? isFollowed,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    String? content,
    List<Media>? media,
    List<String>? likerIds,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    String? eventId,
  }) => Post(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    societyId: societyId ?? this.societyId,
    societyName: societyName ?? this.societyName,
    societyImage: societyImage ?? this.societyImage,
    isFollowed: isFollowed ?? this.isFollowed,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
    content: content ?? this.content,
    media: media ?? this.media,
    likerIds: likerIds ?? this.likerIds,
    likeCount: likeCount ?? this.likeCount,
    commentCount: commentCount ?? this.commentCount,
    isLiked: isLiked ?? this.isLiked,
    eventId: eventId ?? this.eventId,
  );

  @override
  List<Object?> get props => [id];
}
