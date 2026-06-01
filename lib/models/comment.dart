import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
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

  factory Comment.fromMap(Map<String, dynamic> map) => Comment(
    id: map['id'],
    postId: map['postId'],
    userId: map['userId'],
    userName: map['userName'],
    userAvatar: map['userAvatar'],
    content: map['content'],
    createdAt: (map['createdAt'] as Timestamp).toDate(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'postId': postId,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'content': content,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  Comment copyWith({
    String? id,
    DateTime? createdAt,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
  }) => Comment(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    postId: postId ?? this.postId,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userAvatar: userAvatar ?? this.userAvatar,
    content: content ?? this.content,
  );

  @override
  List<Object?> get props => [id];
}
