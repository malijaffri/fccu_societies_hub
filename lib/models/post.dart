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
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    isLiked: map['isLiked'],
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
    'createdAt': Timestamp.fromDate(createdAt),
    'content': content,
    'media': media,
    'likeCount': likeCount,
    'commentCount': commentCount,
    'isLiked': isLiked,
    'eventId': eventId,
  };

  Post copyWith({
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
    String? eventId,
  }) => Post(
    id: id,
    createdAt: createdAt,
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
    eventId: eventId ?? this.eventId,
  );

  @override
  List<Object?> get props => [id];
}
