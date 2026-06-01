import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum NotificationType { like, comment }

class NotificationItem extends Equatable {
  final String id;
  final NotificationType type;

  final String actorId;
  final String actorName;
  final String? actorAvatarUrl;

  final String postId;
  final String postContent;
  final String? commentContent;

  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.actorId,
    required this.actorName,
    this.actorAvatarUrl,
    required this.postId,
    required this.postContent,
    this.commentContent,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) => NotificationItem(
    id: map['id'] as String,
    type: NotificationType.values.byName(map['type'] as String),
    actorId: map['actorId'] as String,
    actorName: map['actorName'] as String,
    actorAvatarUrl: map['actorAvatarUrl'] as String?,
    postId: map['postId'] as String,
    postContent: map['postContent'] as String? ?? '',
    commentContent: map['commentContent'] as String?,
    isRead: map['isRead'] as bool? ?? false,
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'actorId': actorId,
    'actorName': actorName,
    'actorAvatarUrl': actorAvatarUrl,
    'postId': postId,
    'postContent': postContent,
    'commentContent': commentContent,
    'isRead': isRead,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
    id: id,
    type: type,
    actorId: actorId,
    actorName: actorName,
    actorAvatarUrl: actorAvatarUrl,
    postId: postId,
    postContent: postContent,
    commentContent: commentContent,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id];
}
